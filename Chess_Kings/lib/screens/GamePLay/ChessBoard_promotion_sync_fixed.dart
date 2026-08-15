// ChessBoard_promotion_sync_fixed.dart
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../Widget/HomePage/BottomNavbar.dart';
import '../../Widget/HomePage/FooterCopyright.dart';
import '../../Widget/PlayGame/CustomPlayNavbar.dart';
import '../../shared_data.dart' as shared;
import '../HomePage.dart';
import 'Move.dart';
import 'color.dart';
import 'movePce.dart'; // نستخدم isValidMove / isKingInCheck / canCastle* + حقوق التبييت

class ChessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChessBoard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum PieceType { king, queen, rook, bishop, knight, pawn }

enum PlayerColor { white, black }

// تعريف القطعة
class ChessPiece {
  final PieceType type;
  final PlayerColor color;
  bool hasMoved;

  ChessPiece(
    this.type,
    this.color, {
    this.hasMoved = false,
  });

  ChessPiece copyWith({
    PieceType? type,
    PlayerColor? color,
    bool? hasMoved,
  }) {
    return ChessPiece(
      type ?? this.type,
      color ?? this.color,
      hasMoved: hasMoved ?? this.hasMoved,
    );
  }
}

List<List<ChessPiece?>> cloneBoard(List<List<ChessPiece?>> original) {
  return List.generate(8, (row) {
    return List.generate(8, (col) {
      final piece = original[row][col];
      if (piece == null) return null;
      return ChessPiece(
        piece.type,
        piece.color,
        hasMoved: piece.hasMoved,
      );
    });
  });
}

class LocalGameInfo {
  final int id;
  final String gameCode;
  final String? playerWhite;
  final String? playerBlack;
  final String status;
  final String currentTurn;

  const LocalGameInfo({
    required this.id,
    required this.gameCode,
    required this.playerWhite,
    required this.playerBlack,
    required this.status,
    required this.currentTurn,
  });

  factory LocalGameInfo.fromJson(Map<String, dynamic> json) {
    return LocalGameInfo(
      id: int.tryParse('${json['id']}') ?? 0,
      gameCode: '${json['game_code'] ?? ''}',
      playerWhite: json['player_white']?.toString(),
      playerBlack: json['player_black']?.toString(),
      status: '${json['status'] ?? 'waiting'}',
      currentTurn: '${json['current_turn'] ?? 'white'}',
    );
  }
}

class LocalMoveInfo {
  final int moveNumber;
  final String fromSquare;
  final String toSquare;
  final String? pieceType;
  final String? color;
  final String? promotion;
  final String moveType;
  final Map<String, dynamic>? extraData;

  const LocalMoveInfo({
    required this.moveNumber,
    required this.fromSquare,
    required this.toSquare,
    required this.pieceType,
    required this.color,
    required this.promotion,
    required this.moveType,
    required this.extraData,
  });

  factory LocalMoveInfo.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? parsedExtraData;
    final rawExtraData = json['extra_data'];

    if (rawExtraData is Map<String, dynamic>) {
      parsedExtraData = rawExtraData;
    } else if (rawExtraData is String && rawExtraData.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(rawExtraData);
        if (decoded is Map<String, dynamic>) {
          parsedExtraData = decoded;
        }
      } catch (_) {
        parsedExtraData = null;
      }
    }

    return LocalMoveInfo(
      moveNumber: int.tryParse('${json['move_number']}') ?? 0,
      fromSquare: '${json['from_square'] ?? ''}',
      toSquare: '${json['to_square'] ?? ''}',
      pieceType: json['piece_type']?.toString(),
      color: json['color']?.toString(),
      promotion: json['promotion']?.toString(),
      moveType: '${json['move_type'] ?? 'normal'}',
      extraData: parsedExtraData,
    );
  }
}

class LocalNetworkService {
  static const String baseUrl = String.fromEnvironment(
    'CHESS_API_BASE',
    defaultValue: 'https://shatara.sa/chess_api',
  );

  static Future<String> createGame({required String playerToken}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create_game.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'player_token': playerToken}),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200 || data['success'] != true) {
      throw Exception('Failed to create game: ${response.body}');
    }
    return '${data['game_code'] ?? ''}';
  }

  static Future<LocalGameInfo> joinGame({
    required String gameCode,
    required String playerToken,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/join_game.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'game_code': gameCode,
        'player_token': playerToken,
      }),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200 || data['success'] != true) {
      throw Exception('Failed to join game: ${response.body}');
    }
    return LocalGameInfo.fromJson(data['game'] as Map<String, dynamic>);
  }

  static Future<LocalGameInfo> getGame({required String gameCode}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_game.php?game_code=$gameCode'),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200 || data['success'] != true) {
      throw Exception('Failed to get game: ${response.body}');
    }
    return LocalGameInfo.fromJson(data['game'] as Map<String, dynamic>);
  }

  static Future<List<LocalMoveInfo>> getMoves(
      {required String gameCode}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_moves.php?game_code=$gameCode'),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200 || data['success'] != true) {
      throw Exception('Failed to get moves: ${response.body}');
    }
    return (data['moves'] as List? ?? [])
        .map((e) => LocalMoveInfo.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<void> makeMove({
    required String gameCode,
    required String playerToken,
    required String fromSquare,
    required String toSquare,
    required String pieceType,
    required String color,
    String? promotion,
    String moveType = 'normal',
    Map<String, dynamic>? extraData,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/make_move.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'game_code': gameCode,
        'player_token': playerToken,
        'from_square': fromSquare,
        'to_square': toSquare,
        'piece_type': pieceType,
        'color': color,
        'promotion': promotion,
        'move_type': moveType,
        'extra_data': extraData,
      }),
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200 || data['success'] != true) {
      throw Exception('Failed to make move: ${response.body}');
    }
  }
}

class ChessBoard extends StatefulWidget {
  @override
  _ChessBoardState createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  String _gameId = FirebaseFirestore.instance.collection('games').doc().id;
  String? _pieceColor; // "white" / "black"
  String? _gameType; // مثال: "1+0" أو "3+0" ...
  bool _gameSaved = false;
  bool _userBumpedThisGame = false;

  // 🔹 دعم التلميح داخل منطقة الدعم (Highlight)
  PieceType? highlightedSupportType;
  PlayerColor? highlightedSupportColor;

  // إن كنت تحفظ playerNumber كـ int
  String get _playerNumber => shared.id_user;

  // مفاتيح الالتقاط
  final GlobalKey _boardOnlyKey = GlobalKey(); // للرقعة فقط
  final GlobalKey _boardAndSupportKey = GlobalKey(); // للرقعة + منطقة الدعم

  // تعريف هوية المباراة وعدّاد النقلات
  String gameId = DateTime.now().millisecondsSinceEpoch.toString();
  int moveCounter = 0;

  String? _localGameCode;
  late String _localPlayerToken;
  Timer? _localPollingTimer;
  int _lastAppliedLocalMoveNumber = 0;
  bool _isLocalFriendMode = false;
  final TextEditingController _localJoinCodeController =
      TextEditingController();

  //يزيد عدد مرات الدخول1
  Future<void> _markUserOffline() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'online': false,
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ======= التقاط صورة "الرقعة فقط" =======
  Future<Uint8List?> _captureBoardPng() async {
    try {
      await WidgetsBinding.instance.endOfFrame;
      final boundary = _boardOnlyKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;

      double pr = MediaQuery.of(context).devicePixelRatio;
      if (pr > 2.5) pr = 2.5;
      final ui.Image image = await boundary.toImage(pixelRatio: pr);
      final ByteData? bd =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return bd?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  // ======= التقاط صورة "الرقعة + منطقة الدعم" =======
  Future<Uint8List?> _captureBoardAndSupportPng() async {
    try {
      await WidgetsBinding.instance.endOfFrame;
      final boundary = _boardAndSupportKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;

      double pr = MediaQuery.of(context).devicePixelRatio;
      if (pr > 2.5) pr = 2.5;
      final ui.Image image = await boundary.toImage(pixelRatio: pr);
      final ByteData? bd =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return bd?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  // ======= رفع الصورة للسيرفر =======
  Future<String?> _uploadToServer(
    Uint8List bytes, {
    required String gameId,
    required int moveNumber,
  }) async {
    try {
      final uri = Uri.parse('https://shatarachess.com/ShataraGame/upload.php');
      final request = http.MultipartRequest('POST', uri);

      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
      request.fields['uid'] = uid;
      request.fields['gameId'] = gameId;
      request.fields['moveNumber'] = moveNumber.toString();

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: 'game_${gameId}_move_$moveNumber.png',
        contentType: MediaType('image', 'png'),
      ));

      final resp = await request.send();
      final body = await resp.stream.bytesToString();
      if (resp.statusCode != 200) return null;

      final jsonMap = jsonDecode(body) as Map<String, dynamic>;
      if (jsonMap['success'] == true && jsonMap['url'] is String) {
        return jsonMap['url'] as String;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ======= التقط + ارفع (الرقعة + الدعم) =======
  Future<void> _captureAndUploadBoardWithSupport({
    required String by, // 'player' أو 'ai'
    required String moveNotation,
  }) async {
    final bytes = await _captureBoardAndSupportPng();
    if (bytes == null) return;

    moveCounter++;
    final fullGameId = '${gameId}_full';
    await _uploadToServer(bytes, gameId: fullGameId, moveNumber: moveCounter);
  }

  // رابرز سهلة بعد كل نقلة
  void _captureWithSupportAfterMove(
      {required String by, required String moveNotation}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _captureAndUploadBoardWithSupport(by: by, moveNotation: moveNotation);
    });
  }

  Future<void> _maybeSaveGame() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // مش مسجل دخول
    if (_gameSaved) return; // انحفِظت بالفعل
    if (_pieceColor == null || _gameType == null) return;

    final data = {
      'gameId': _gameId,
      'playerNumber': _playerNumber,
      'gameType': _gameType,
      'pieceColor': _pieceColor,
      'playedAt': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance.collection('games').doc(_gameId).set(data);
    _gameSaved = true;
  }

  void _captureWithSupportAfterAiMove({required String moveNotation}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _captureAndUploadBoardWithSupport(by: 'ai', moveNotation: moveNotation);
    });
  }

  // (اختياري) نسخة للرقعة فقط
  Future<void> _captureAndUploadBoardOnly({
    required String by,
    required String moveNumber,
  }) async {
    final bytes = await _captureBoardPng();
    if (bytes == null) return;

    moveCounter++;
    await _uploadToServer(bytes, gameId: gameId, moveNumber: moveCounter);
  }

  // التحقق إذا الوضع كش مات
  bool _isCheckmate(PlayerColor color) {
    // إذا الملك مو بكش، فمستحيل يكون كش مات
    if (!isKingInCheck(color, board)) return false;

    // جرّب كل حركة ممكنة، إذا وحدة بتنقذ الملك → مش كش مات
    for (int fromRow = 0; fromRow < 8; fromRow++) {
      for (int fromCol = 0; fromCol < 8; fromCol++) {
        final piece = board[fromRow][fromCol];
        if (piece == null || piece.color != color) continue;

        for (int toRow = 0; toRow < 8; toRow++) {
          for (int toCol = 0; toCol < 8; toCol++) {
            if (!isValidMove(fromRow, fromCol, toRow, toCol, board)) continue;

            final captured = board[toRow][toCol];
            board[toRow][toCol] = board[fromRow][fromCol];
            board[fromRow][fromCol] = null;

            final stillInCheck = isKingInCheck(color, board);

            // رجع اللوح
            board[fromRow][fromCol] = board[toRow][toCol];
            board[toRow][toCol] = captured;

            if (!stillInCheck) {
              return false; // في حركة تنقذ الملك
            }
          }
        }
      }
    }

    return true; // الملك بكش ومافي ولا حركة تنقذه
  }

  // التحقق إذا الوضع خنق (تعادل)
  bool _isStalemate(PlayerColor color) {
    // إذا الملك بكش → مش خنق
    if (isKingInCheck(color, board)) return false;

    // جرّب كل حركة، إذا في وحدة قانونية → مش خنق
    for (int fromRow = 0; fromRow < 8; fromRow++) {
      for (int fromCol = 0; fromCol < 8; fromCol++) {
        final piece = board[fromRow][fromCol];
        if (piece == null || piece.color != color) continue;

        for (int toRow = 0; toRow < 8; toRow++) {
          for (int toCol = 0; toCol < 8; toCol++) {
            if (!isValidMove(fromRow, fromCol, toRow, toCol, board)) continue;

            final captured = board[toRow][toCol];
            board[toRow][toCol] = board[fromRow][fromCol];
            board[fromRow][fromCol] = null;

            final stillInCheck = isKingInCheck(color, board);

            // رجع اللوح
            board[fromRow][fromCol] = board[toRow][toCol];
            board[toRow][toCol] = captured;

            if (!stillInCheck) {
              return false; // في حركة قانونية
            }
          }
        }
      }
    }

    return true; // لا في كش ولا في أي حركة → خنق (تعادل)
  }

  PlayerColor _getColorFromAsset(String assetName) {
    if (assetName.startsWith('white_')) {
      return PlayerColor.white;
    } else {
      return PlayerColor.black;
    }
  }

  Timer? gameTimer;

  bool isGameOver = false;

  final int initialTimePerPlayer = 300;
  late int playerTimeRemaining;
  late int aiTimeRemaining;

  bool isBoardFlipped = false;
  int moveTimeLimitSeconds = 300;

  String? selectedLevel;
  int? selectedTime;

  // منطقة الدعم (ثابتة في الذاكرة، العرض يقلب فقط)
  final Map<int, String> pieceImages = {
    // أعلى (السود)
    0: 'black_queen.svg',
    1: 'black_queen.svg',
    2: 'black_rook.svg',
    3: 'black_rook.svg',
    4: 'black_horse.svg',
    5: 'black_horse.svg',
    6: 'black_bishop.svg',
    7: 'black_bishop.svg',
    8: 'black_pawn.svg',
    9: 'black_pawn.svg',
    10: 'black_pawn.svg',
    11: 'black_pawn.svg',
    // أسفل (البيض)
    20: 'white_pawn.svg',
    21: 'white_pawn.svg',
    22: 'white_pawn.svg',
    23: 'white_pawn.svg',
    24: 'white_horse.svg',
    25: 'white_horse.svg',
    26: 'white_bishop.svg',
    27: 'white_bishop.svg',
    28: 'white_queen.svg',
    29: 'white_queen.svg',
    30: 'white_rook.svg',
    31: 'white_rook.svg',
  };

  void _initializeSupportPieces() {
    pieceImages
      ..clear()
      ..addAll({
        0: 'black_queen.svg',
        1: 'black_queen.svg',
        2: 'black_rook.svg',
        3: 'black_rook.svg',
        4: 'black_horse.svg',
        5: 'black_horse.svg',
        6: 'black_bishop.svg',
        7: 'black_bishop.svg',
        8: 'black_pawn.svg',
        9: 'black_pawn.svg',
        10: 'black_pawn.svg',
        11: 'black_pawn.svg',
        20: 'white_pawn.svg',
        21: 'white_pawn.svg',
        22: 'white_pawn.svg',
        23: 'white_pawn.svg',
        24: 'white_horse.svg',
        25: 'white_horse.svg',
        26: 'white_bishop.svg',
        27: 'white_bishop.svg',
        28: 'white_queen.svg',
        29: 'white_queen.svg',
        30: 'white_rook.svg',
        31: 'white_rook.svg',
      });
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  Offset? enPassantTarget;

  List<String> movesHistory = [];

  String currentTheme = 'brown';

  late List<List<ChessPiece?>> board;

  int totalGameDuration = 60;

  PlayerColor? startingPlayer;

  int? selectedRow;
  int? selectedCol;

  List<Offset> possibleMoves = [];

  Offset? lastFrom;
  Offset? lastTo;

  String difficulty = 'مبتدئ';
  bool _dialogShown = false;

  late PlayerColor currentPlayerColor;
  late PlayerColor aiColor;
  late PlayerColor playerColor;
  bool isSinglePlayerMode = false;

  /// ✅ دالة لإعادة ضبط حقوق التبييت في movePce.dart عند بداية كل لعبة
  void _resetCastlingFlags() {
    whiteKingMoved = false;
    whiteKingsideRookMoved = false;
    whiteQueensideRookMoved = false;
    blackKingMoved = false;
    blackKingsideRookMoved = false;
    blackQueensideRookMoved = false;
  }

  String _generateLocalPlayerToken() {
    return 'player_${DateTime.now().millisecondsSinceEpoch}_${math.Random().nextInt(999999)}';
  }

  Future<void> _createLocalFriendGame() async {
    try {
      final code = await LocalNetworkService.createGame(
        playerToken: _localPlayerToken,
      );

      setState(() {
        _isLocalFriendMode = true;
        _localGameCode = code;
        _lastAppliedLocalMoveNumber = 0;
        playerColor = PlayerColor.white;
        aiColor = PlayerColor.black;
        currentPlayerColor = PlayerColor.white;
        isSinglePlayerMode = false;
        _pieceColor = 'white';
      });

      _startLocalPolling();
      startProperTimer();

      if (!mounted) return;
      await Clipboard.setData(
        ClipboardData(
          text: '${Uri.base.origin}/#/playNow?mode=friend&code=$code',
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إنشاء مباراة محلية. الكود: $code')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل إنشاء المباراة المحلية: $e')),
      );
    }
  }

  Future<void> _joinLocalFriendGame(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return;
    try {
      final game = await LocalNetworkService.joinGame(
        gameCode: trimmed,
        playerToken: _localPlayerToken,
      );

      setState(() {
        _isLocalFriendMode = true;
        _localGameCode = game.gameCode;
        _lastAppliedLocalMoveNumber = 0;
        playerColor = PlayerColor.black;
        aiColor = PlayerColor.white;
        currentPlayerColor =
            game.currentTurn == 'white' ? PlayerColor.white : PlayerColor.black;
        isSinglePlayerMode = false;
        _pieceColor = 'black';
      });

      _startLocalPolling();
      startProperTimer();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم الانضمام للمباراة ${game.gameCode}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل الانضمام للمباراة: $e')),
      );
    }
  }

  void _showLocalFriendSetupDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('اللعب الشبكي المحلي'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _createLocalFriendGame();
                },
                child: const Text('إنشاء مباراة محلية'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _localJoinCodeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'أدخل كود المباراة',
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final code = _localJoinCodeController.text.trim();
                  Navigator.of(context).pop();
                  await _joinLocalFriendGame(code);
                },
                child: const Text('انضمام للمباراة'),
              ),
              if (_localGameCode != null && _localGameCode!.isNotEmpty) ...[
                const SizedBox(height: 12),
                SelectableText('الكود الحالي: $_localGameCode'),
              ],
            ],
          ),
        );
      },
    );
  }

  void _startLocalPolling() {
    _localPollingTimer?.cancel();
    _localPollingTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final code = _localGameCode;
      if (code == null || code.isEmpty) return;
      try {
        final game = await LocalNetworkService.getGame(gameCode: code);
        final moves = await LocalNetworkService.getMoves(gameCode: code);
        if (!mounted) return;
        setState(() {
          currentPlayerColor = game.currentTurn == 'white'
              ? PlayerColor.white
              : PlayerColor.black;
        });
        await _applyPendingLocalMoves(moves);
      } catch (_) {}
    });
  }

  Future<void> _applyPendingLocalMoves(List<LocalMoveInfo> moves) async {
    final pending = moves
        .where((m) => m.moveNumber > _lastAppliedLocalMoveNumber)
        .toList()
      ..sort((a, b) => a.moveNumber.compareTo(b.moveNumber));

    for (final move in pending) {
      final from = _squareNameToPosition(move.fromSquare);
      final to = _squareNameToPosition(move.toSquare);

      if (from == null || to == null) {
        _lastAppliedLocalMoveNumber = move.moveNumber;
        continue;
      }

      final moveType = move.moveType.toLowerCase();
      final isSameSquare = from.$1 == to.$1 && from.$2 == to.$2;
      final promotionType = _pieceTypeFromName(move.promotion);

      // 🟢 تنزيل بيدق من منطقة الدعم
      if (moveType == 'support_drop') {
        final extra = move.extraData ?? const <String, dynamic>{};
        final supportIndex = int.tryParse('${extra['support_index'] ?? ''}');
        final moveColor =
            move.color == 'black' ? PlayerColor.black : PlayerColor.white;

        setState(() {
          board[to.$1][to.$2] = ChessPiece(
            PieceType.pawn,
            moveColor,
            hasMoved: false,
          );

          if (supportIndex != null) {
            pieceImages.remove(supportIndex);
          }

          lastFrom = Offset(from.$1.toDouble(), from.$2.toDouble());
          lastTo = Offset(to.$1.toDouble(), to.$2.toDouble());
        });

        _lastAppliedLocalMoveNumber = move.moveNumber;
        continue;
      }

      // 🏰 تبييت شبكي: حرّك الملك والقلعة معاً عند الطرف الآخر
      if (moveType == 'castle') {
        final king = board[from.$1][from.$2];

        if (king != null && king.type == PieceType.king) {
          final rookFromCol = to.$2 > from.$2 ? 7 : 0;
          final rookToCol = to.$2 > from.$2 ? to.$2 - 1 : to.$2 + 1;
          final rook = board[from.$1][rookFromCol];

          setState(() {
            board[to.$1][to.$2] = king;
            board[from.$1][from.$2] = null;
            king.hasMoved = true;

            if (rook != null && rook.type == PieceType.rook) {
              board[from.$1][rookToCol] = rook;
              board[from.$1][rookFromCol] = null;
              rook.hasMoved = true;
            }

            lastFrom = Offset(from.$1.toDouble(), from.$2.toDouble());
            lastTo = Offset(to.$1.toDouble(), to.$2.toDouble());
          });
        }

        _lastAppliedLocalMoveNumber = move.moveNumber;
        continue;
      }

      // ♟️ تبديل/ترقية من منطقة الدعم: نزّل القطعة الجديدة وأرجع القديمة للدعم
      if (moveType == 'support_swap') {
        final extra = move.extraData ?? const <String, dynamic>{};
        final supportIndex = int.tryParse('${extra['support_index'] ?? ''}');

        final newType = _pieceTypeFromName(
              move.promotion ?? extra['support_piece']?.toString(),
            ) ??
            promotionType;

        final oldType = _pieceTypeFromName(
          extra['board_piece']?.toString() ?? move.pieceType,
        );

        final moveColor =
            move.color == 'black' ? PlayerColor.black : PlayerColor.white;

        if (newType != null && oldType != null) {
          setState(() {
            board[to.$1][to.$2] = ChessPiece(
              newType,
              moveColor,
              hasMoved: true,
            );

            if (supportIndex != null) {
              pieceImages[supportIndex] = _getAssetName(oldType, moveColor);
            }

            lastFrom = Offset(from.$1.toDouble(), from.$2.toDouble());
            lastTo = Offset(to.$1.toDouble(), to.$2.toDouble());
          });
        }

        _lastAppliedLocalMoveNumber = move.moveNumber;
        continue;
      }

      // ترقية عادية بنفس المربع
      if (isSameSquare) {
        final currentPiece = board[to.$1][to.$2];

        if (currentPiece != null && promotionType != null) {
          setState(() {
            board[to.$1][to.$2] = ChessPiece(
              promotionType,
              currentPiece.color,
              hasMoved: true,
            );

            lastFrom = Offset(from.$1.toDouble(), from.$2.toDouble());
            lastTo = Offset(to.$1.toDouble(), to.$2.toDouble());
          });
        }

        _lastAppliedLocalMoveNumber = move.moveNumber;
        continue;
      }

      // حركة عادية
      final piece = board[from.$1][from.$2];

      if (piece == null) {
        _lastAppliedLocalMoveNumber = move.moveNumber;
        continue;
      }

      setState(() {
        board[to.$1][to.$2] = piece;
        board[from.$1][from.$2] = null;
        piece.hasMoved = true;

        if (promotionType != null) {
          board[to.$1][to.$2] = ChessPiece(
            promotionType,
            piece.color,
            hasMoved: true,
          );
        }

        lastFrom = Offset(from.$1.toDouble(), from.$2.toDouble());
        lastTo = Offset(to.$1.toDouble(), to.$2.toDouble());
      });

      _lastAppliedLocalMoveNumber = move.moveNumber;
    }
  }

  PieceType? _pieceTypeFromName(String? name) {
    switch ((name ?? '').toLowerCase()) {
      case 'king':
        return PieceType.king;
      case 'queen':
        return PieceType.queen;
      case 'rook':
        return PieceType.rook;
      case 'bishop':
        return PieceType.bishop;
      case 'knight':
        return PieceType.knight;
      case 'pawn':
        return PieceType.pawn;
      default:
        return null;
    }
  }

  (int, int)? _squareNameToPosition(String square) {
    if (square.length < 2) return null;
    const files = 'ABCDEFGH';
    final file = square[0].toUpperCase();
    final rank = int.tryParse(square.substring(1));
    if (rank == null) return null;
    final col = files.indexOf(file);
    if (col == -1) return null;
    final row = 8 - rank;
    if (row < 0 || row > 7) return null;
    return (row, col);
  }

  Future<void> _createGameIfNotExists() async {
    final gameRef = FirebaseFirestore.instance.collection('games').doc(_gameId);

    final snapshot = await gameRef.get();

    if (snapshot.exists) return; // اللعبة موجودة مسبقًا

    await gameRef.set({
      'gameId': _gameId,
      'gameType': _gameType, // مثال: "30+0"
      'status': 'playing',
      'createdAt': FieldValue.serverTimestamp(),
      'playerWhite': playerColor == PlayerColor.white
          ? FirebaseAuth.instance.currentUser?.uid
          : 'AI',
      'playerBlack': playerColor == PlayerColor.black
          ? FirebaseAuth.instance.currentUser?.uid
          : 'AI',
    });
  }

  @override
  void initState() {
    super.initState();
    _localPlayerToken = _generateLocalPlayerToken();
    _gameId = FirebaseFirestore.instance.collection('games').doc().id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showColorSelectionDialog();
    });

    playerTimeRemaining = initialTimePerPlayer;
    aiTimeRemaining = initialTimePerPlayer;

    _resetCastlingFlags(); // ✅ مهمة
    board = List.generate(8, (i) => List.filled(8, null));
    _initializeBoard();

    _initializeSupportPieces();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dialogShown) {
      _dialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _showDifficultyDialog();
        _showGameTimeDialog();
      });
    }
  }

  Future<void> _showDifficultyDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('اختيار مستوى الصعوبة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() => difficulty = 'مبتدئ');
                  Navigator.pop(context);
                },
                child: Text('مبتدئ'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() => difficulty = 'متوسط');
                  Navigator.pop(context);
                },
                child: Text('متوسط'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() => difficulty = 'متقدم');
                  Navigator.pop(context);
                },
                child: Text('متقدم'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showGameTimeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('اختيار وقت المباراة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildGameTimeOption(context, '1+0', 'Bullet', 60),
              _buildGameTimeOption(context, '3+0', 'Bullet', 180),
              _buildGameTimeOption(context, '10+0', 'Rapid', 600),
              _buildGameTimeOption(context, '30+0', 'Classical', 1800),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGameTimeOption(
      BuildContext context, String label, String category, int seconds) {
    return ListTile(
      title: Text('$label ($category)'),
      onTap: () {
        Navigator.pop(context);
        setState(() {
          moveTimeLimitSeconds = seconds;
          playerTimeRemaining = seconds;
          aiTimeRemaining = seconds;

          _gameType = label; // ✅ نخزن "1+0" أو "3+0" ...
          _maybeSaveGame(); // ✅

          startProperTimer();
        });
        _bumpUserOnGameStart(); //زيادت عددة مرات الدخول
      },
    );
  }

  Future<void> _bumpUserOnGameStart() async {
    if (_userBumpedThisGame) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ref = FirebaseFirestore.instance.collection('users').doc(uid);

    await FirebaseFirestore.instance.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final data = (snap.data() ?? {}) as Map<String, dynamic>;
      int current = 0;

      if (data['play_computer'] is String) {
        current = int.tryParse(data['play_computer']) ?? 0;
      } else if (data['play_computer'] is int) {
        current = data['play_computer'] as int;
      }

      tx.set(
          ref,
          {
            'play_computer': (current + 1).toString(), // ← يُحفظ كسلسلة
            'lastSeen': FieldValue.serverTimestamp(),
            'online': true,
          },
          SetOptions(merge: true));
    });

    _userBumpedThisGame = true;
  }

  void _initializeBoard() {
    for (int i = 0; i < 8; i++) {
      board[1][i] =
          ChessPiece(PieceType.pawn, PlayerColor.black, hasMoved: false);
      board[6][i] =
          ChessPiece(PieceType.pawn, PlayerColor.white, hasMoved: false);
    }

    List<PieceType> backRow = [
      PieceType.rook,
      PieceType.knight,
      PieceType.bishop,
      PieceType.queen,
      PieceType.king,
      PieceType.bishop,
      PieceType.knight,
      PieceType.rook,
    ];

    for (int i = 0; i < 8; i++) {
      board[0][i] = ChessPiece(backRow[i], PlayerColor.black, hasMoved: false);
      board[7][i] = ChessPiece(backRow[i], PlayerColor.white, hasMoved: false);
    }
  }

  Timer? moveTimer;

  void startProperTimer() {
    moveTimer?.cancel();

    moveTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (isGameOver) {
        timer.cancel();
        return;
      }

      setState(() {
        if (currentPlayerColor == playerColor) {
          if (playerTimeRemaining > 0) {
            playerTimeRemaining--;
          } else {
            isGameOver = true;
            timer.cancel();
            _handlePlayerTimeOut();
          }
        } else if (currentPlayerColor == aiColor) {
          if (aiTimeRemaining > 0) {
            aiTimeRemaining--;
          } else {
            isGameOver = true;
            timer.cancel();
            _handleAITimeOut();
          }
        }
      });
    });
  }

  String getFormattedTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSecs = seconds % 60;
    return '${minutes}:${remainingSecs.toString().padLeft(2, '0')}';
  }

  void _handleAITimeOut() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('🎉 تهانينا!'),
        content:
            Text('لقد انتهى وقت الخصم (الذكاء الاصطناعي).\nفزت بالمباراة! 🏆'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Future.delayed(Duration(milliseconds: 200), () {
                _resetGame();
              });
            },
            child: Text('ابدأ مباراة جديدة'),
          ),
        ],
      ),
    );
  }

  void _handleTimeOut() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('انتهى الوقت!'),
          content: Text('لقد خسرت بسبب نفاد الوقت.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Future.delayed(Duration(milliseconds: 200), () {
                  _resetGame();
                });
              },
              child: Text('إعادة المباراة'),
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      isGameOver = false;
      _gameId = FirebaseFirestore.instance.collection('games').doc().id;
      // (1) إعادة ضبط التبييت
      whiteKingMoved = false;
      whiteKingsideRookMoved = false;
      whiteQueensideRookMoved = false;
      blackKingMoved = false;
      blackKingsideRookMoved = false;
      blackQueensideRookMoved = false;

      // (2) إعادة بناء الرقعة
      board = List.generate(8, (i) => List.filled(8, null));
      _initializeBoard();

      // ⭐ تثبيت king & queen hasMoved = true
      for (int r = 0; r < 8; r++) {
        for (int c = 0; c < 8; c++) {
          final p = board[r][c];
          if (p == null) continue;
          if (p.type == PieceType.king || p.type == PieceType.queen) {
            p.hasMoved = true;
          }
        }
      }

      // (3) إعادة الدعم
      _initializeSupportPieces();

      // (4) إعادة المؤشرات
      selectedRow = null;
      selectedCol = null;
      possibleMoves.clear();
      movesHistory.clear();
      lastFrom = null;
      lastTo = null;
      enPassantTarget = null;
      highlightedSupportType = null;

      // (5) إعادة الوقت
      playerTimeRemaining = moveTimeLimitSeconds;
      aiTimeRemaining = moveTimeLimitSeconds;

      // (6) اللاعب يبدأ
      currentPlayerColor = PlayerColor.white;

      moveTimer?.cancel();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showColorSelectionDialog();
    });

    _gameSaved = false;
    _pieceColor = null;
    _gameType = null;
    _gameId = FirebaseFirestore.instance.collection('games').doc().id;
  }

  @override
  void dispose() {
    moveTimer?.cancel();
    _localPollingTimer?.cancel();
    _localJoinCodeController.dispose();
    _markUserOffline();
    super.dispose();
  }

  bool _isInSupportZone(int row, int col) {
    int index = row * 4 + col;
    return pieceImages.containsKey(index);
  }

  void _showColorSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('اختر لونك'),
          content: Text('من أي لون تود اللعب؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                playerColor = PlayerColor.white;
                aiColor = PlayerColor.black;
                currentPlayerColor = PlayerColor.white;
                isSinglePlayerMode = true;

                _pieceColor = 'white'; // ✅
                _maybeSaveGame(); // ✅

                startProperTimer();
              },
              child: Text('♔ الأبيض'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                playerColor = PlayerColor.black;
                aiColor = PlayerColor.white;
                currentPlayerColor = PlayerColor.white; // AI يبدأ
                isSinglePlayerMode = true;
                _isLocalFriendMode = false;

                _pieceColor = 'black'; // ✅
                _maybeSaveGame(); // ✅

                startProperTimer();

                Future.delayed(const Duration(milliseconds: 500), () {
                  _makeAIMove();
                });
              },
              child: Text('♚ الأسود'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showLocalFriendSetupDialog();
              },
              child: const Text('👥 شبكي محلي'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveMoveToFirestore({
    required String from,
    required String to,
    required String notation,
    required PieceType pieceType,
    required PlayerColor color,
    String? promotion,
    String moveType = 'normal',
    Map<String, dynamic>? extraData,
  }) async {
    try {
      if (_isLocalFriendMode) {
        final code = _localGameCode;
        if (code == null || code.isEmpty) return;
        await LocalNetworkService.makeMove(
          gameCode: code,
          playerToken: _localPlayerToken,
          fromSquare: from,
          toSquare: to,
          pieceType: pieceType.name,
          color: color.name,
          promotion: promotion,
          moveType: moveType,
          extraData: extraData,
        );
        return;
      }

      final gameId = _gameId; // نفس gameId للمباراة

      await FirebaseFirestore.instance
          .collection('games')
          .doc(gameId)
          .collection('moves')
          .add({
        'from': from,
        'to': to,
        'notation': notation,
        'pieceType': pieceType.name,
        'color': color.name,
        'promotion': promotion,
        'moveType': moveType,
        'extraData': extraData,
        'createdAt': FieldValue.serverTimestamp(),
        'moveNumber': movesHistory.length + 1,
      });
    } catch (e) {
      debugPrint('❌ Error saving move: $e');
    }
  }

  Future<void> _onTileTapped(int row, int col) async {
    if (isGameOver) return;

    final movingColor = currentPlayerColor;
    final cell = board[row][col];
    final opponentColor = currentPlayerColor == PlayerColor.white
        ? PlayerColor.black
        : PlayerColor.white;

    // -------------------------------------------------------
    // 🔵 (1) لا يوجد تحديد سابق
    // -------------------------------------------------------
    if (selectedRow == null || selectedCol == null) {
      // 🟢 إمكانية إدخال بيدق من الدعم
      if (cell == null &&
          ((row == 6 && currentPlayerColor == PlayerColor.white) ||
              (row == 1 && currentPlayerColor == PlayerColor.black))) {
        final insert = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('🟢 إدخال بيدق من الدعم'),
              content: const Text(
                  'هل تريد إدخال بيدق من منطقة الدعم إلى هذا الموقع؟'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('إلغاء'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('إدخال'),
                ),
              ],
            );
          },
        );

        if (insert == true) {
          final supportIndex = pieceImages.entries
              .firstWhere(
                (entry) =>
                    _getPieceTypeFromAsset(entry.value) == PieceType.pawn &&
                    (currentPlayerColor == PlayerColor.white
                        ? entry.value.contains('white')
                        : entry.value.contains('black')),
                orElse: () => const MapEntry(-1, ''),
              )
              .key;

          if (supportIndex != -1) {
            _replacePawnWithSupportPiece(
                row, col, supportIndex, currentPlayerColor);
            _checkForGameOver();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('⚠️ لا يوجد بيدق متاح في منطقة الدعم!'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
        return;
      }

      // 🟥 خلية فارغة خارج صف الإدخال → ممنوع
      if (cell == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ الخانة فارغة ولا يمكن إدخال بيدق هنا'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // -------------------------------------------------------
      // 🔷 (1-A) تحديد قطعة من نفس اللون (اول ضغطة)
      // -------------------------------------------------------
      if (cell.color == currentPlayerColor) {
        final bool isKingOrQueen =
            cell.type == PieceType.king || cell.type == PieceType.queen;

        if (!isKingOrQueen &&
            cell.hasMoved &&
            !isKingInCheck(opponentColor, board)) {
          // قطعة مؤهلة للدعم
          final hintType = getSupportHintType(cell.type);

          if (hintType != null) {
            List<List<ChessPiece?>> tempBoard =
                List.generate(8, (i) => List.from(board[i]));

            final newPiece =
                ChessPiece(hintType, currentPlayerColor, hasMoved: true);
            tempBoard[row][col] = newPiece;

            final causesCheck = isKingInCheck(opponentColor, tempBoard);

            if (!causesCheck) {
              setState(() {
                selectedRow = row;
                selectedCol = col;
                possibleMoves = _calculatePossibleMoves(row, col);

                highlightedSupportType = hintType;
                highlightedSupportColor = cell.color;
              });
            } else {
              // حركة الدعم تسبب كش → لا تلوين
              setState(() {
                selectedRow = row;
                selectedCol = col;
                possibleMoves = _calculatePossibleMoves(row, col);
                highlightedSupportType = null;
                highlightedSupportColor = null;
              });
            }

            return;
          }
        }

        // 🔵 (1-B) اختيار ملك أو وزير → تحديد طبيعي بدون شروط
        setState(() {
          selectedRow = row;
          selectedCol = col;
          possibleMoves = _calculatePossibleMoves(row, col);

          highlightedSupportType = null;
          highlightedSupportColor = null;
        });
        return;
      }

      // 🟥 نقر على خصم بدون تحديد → تجاهل
      setState(() {
        selectedRow = null;
        selectedCol = null;
        possibleMoves.clear();
        highlightedSupportType = null;
        highlightedSupportColor = null;
      });
      return;
    }

    // -------------------------------------------------------
    // 🔵 (2) هناك تحديد سابق
    // -------------------------------------------------------

    final selectedPiece = board[selectedRow!][selectedCol!];
    final targetPiece = board[row][col];

    // 🔸 إلغاء إذا ضغط نفس الخانة
    if (selectedRow == row && selectedCol == col) {
      setState(() {
        selectedRow = null;
        selectedCol = null;
        possibleMoves.clear();
        highlightedSupportType = null;
        highlightedSupportColor = null;
      });
      return;
    }

    // 🔷 تغيير التحديد لقطعة من نفس اللون
    if (targetPiece != null &&
        selectedPiece != null &&
        targetPiece.color == selectedPiece.color) {
      final bool isKingOrQueen = targetPiece.type == PieceType.king ||
          targetPiece.type == PieceType.queen;

      setState(() {
        selectedRow = row;
        selectedCol = col;
        possibleMoves = _calculatePossibleMoves(row, col);

        if (!isKingOrQueen &&
            targetPiece.hasMoved &&
            !isKingInCheck(opponentColor, board)) {
          highlightedSupportType = getSupportHintType(targetPiece.type);
          highlightedSupportColor = targetPiece.color;
        } else {
          highlightedSupportType = null;
          highlightedSupportColor = null;
        }
      });
      return;
    }

    // 🔥 محاولة حركة غير قانونية
    if (!isValidMove(selectedRow!, selectedCol!, row, col, board,
        enPassantTarget: enPassantTarget)) {
      return;
    }

    // 🎵 صوت الحركة
    _audioPlayer.play(AssetSource('sounds/move.mp3'));

    final movingPiece = board[selectedRow!][selectedCol!];

    // 🔴 لا تترك ملكك في كش
    ChessPiece? tempCaptured = board[row][col];
    board[row][col] = movingPiece;
    board[selectedRow!][selectedCol!] = null;

    final stillInCheck = isKingInCheck(movingColor, board);

    board[selectedRow!][selectedCol!] = board[row][col];
    board[row][col] = tempCaptured;

    if (stillInCheck) {
      _showKingInCheckDialog();
      return;
    }

    // 🏰 تحديث حقوق التبييت
    if (movingPiece != null) {
      updateCastlingRights(selectedRow!, selectedCol!, movingPiece);
    }

    // -------------------------------------------------------
    // 🔵 تنفيذ الحركة فعليًا
    // -------------------------------------------------------
    setState(() {
      // 🟤 أكل بالمرور
      if (movingPiece != null &&
          movingPiece.type == PieceType.pawn &&
          col != selectedCol &&
          board[row][col] == null &&
          enPassantTarget != null &&
          enPassantTarget == Offset(row.toDouble(), col.toDouble())) {
        int capturedRow =
            movingPiece.color == PlayerColor.white ? row + 1 : row - 1;
        board[capturedRow][col] = null;
      }

      // 🏰 التبييت
      if (movingPiece != null &&
          movingPiece.type == PieceType.king &&
          (col - selectedCol!).abs() == 2) {
        _performCastling(movingPiece, row, col);
      } else {
        final temp = board[row][col];
        board[row][col] = movingPiece;
        board[selectedRow!][selectedCol!] = null;
        movingPiece?.hasMoved = true;
      }

      lastFrom = Offset(selectedRow!.toDouble(), selectedCol!.toDouble());
      lastTo = Offset(row.toDouble(), col.toDouble());
    });

    // ⬆ ترقية بيدق إذا لازم
    await _promotePawnIfNeeded(row, col);

    // -------------------------------------------------------
    // 🔵 بعد تنفيذ الحركة
    // -------------------------------------------------------
    setState(() {
      _updateEnPassantTarget(movingPiece, selectedRow!, row, col);

      if (movingPiece != null) {
        final pieceSymbol = _getPieceSymbol(movingPiece);
        final moveNotation =
            '$pieceSymbol ${_getSquareName(selectedRow!, selectedCol!)}-${_getSquareName(row, col)}';
        movesHistory.add(movingColor == PlayerColor.white
            ? '褐 $moveNotation'
            : '黑 $moveNotation');

        final localMoveType = movingPiece.type == PieceType.king &&
                (row == selectedRow!) &&
                (col - selectedCol!).abs() == 2
            ? 'castle'
            : 'normal';

        _saveMoveToFirestore(
          from: _getSquareName(selectedRow!, selectedCol!),
          to: _getSquareName(row, col),
          notation: moveNotation,
          pieceType: movingPiece.type,
          color: movingColor,
          moveType: localMoveType,
        );

        _captureWithSupportAfterMove(
          by: (movingColor == playerColor) ? 'player' : 'ai',
          moveNotation: moveNotation,
        );
      }

      highlightedSupportType = null;
      highlightedSupportColor = null;

      currentPlayerColor = currentPlayerColor == PlayerColor.white
          ? PlayerColor.black
          : PlayerColor.white;

      selectedRow = null;
      selectedCol = null;
      possibleMoves.clear();

      _checkSupportZoneAndUpgrade(row, col);
      _checkForGameOver();
    });

    // 🤖 شغّل الذكاء الصناعي
    if (!_isLocalFriendMode && !isGameOver && currentPlayerColor == aiColor) {
      await Future.delayed(const Duration(milliseconds: 500));
      _makeAIMove();
    }
  }

  void _checkSupportZoneAndUpgrade(int row, int col) {
    final piece = board[row][col];
    if (piece == null) return;

    // (لو عندك قواعد خاصة للدعم هنا؛ غير متعلقة بالترقية القياسية)
  }

  // Dialog ترقية (Blocking) بدون خصم من الدعم
  Future<PieceType?> _showPromotionDialogAndWait(
    int row,
    int col,
    PlayerColor color,
    List<PieceType> options,
  ) async {
    final displayOptions = isBoardFlipped ? options.reversed.toList() : options;

    String _assetFor(PieceType t, PlayerColor c) {
      final colorPrefix = c == PlayerColor.white ? 'white' : 'black';
      final name = switch (t) {
        PieceType.king => 'king',
        PieceType.queen => 'queen',
        PieceType.rook => 'rook',
        PieceType.bishop => 'bishop',
        PieceType.knight => 'horse',
        PieceType.pawn => 'pawn',
      };
      return 'assets/images/${colorPrefix}_$name.svg';
    }

    return showDialog<PieceType>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('اختر القطعة للترقية'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: displayOptions.map((type) {
            final asset = _assetFor(type, color);
            return ElevatedButton(
              onPressed: () => Navigator.of(context).pop(type),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(asset, width: 30, height: 30),
                  const SizedBox(width: 8),
                  Text(_getPieceName(type)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // الترقية القياسية (خيارات ثابتة، بدون خصم من الدعم)
  Future<PieceType?> _promotePawnIfNeeded(int row, int col) async {
    final movedPiece = board[row][col];

    if (movedPiece == null || movedPiece.type != PieceType.pawn) {
      return null;
    }

    final isWhitePromo = movedPiece.color == PlayerColor.white && row == 0;
    final isBlackPromo = movedPiece.color == PlayerColor.black && row == 7;

    if (!isWhitePromo && !isBlackPromo) {
      return null;
    }

    final options = <PieceType>[
      PieceType.queen,
      PieceType.rook,
      PieceType.bishop,
      PieceType.knight,
    ];

    final chosen =
    await _showPromotionDialogAndWait(row, col, movedPiece.color, options);

    if (chosen == null) {
      return null;
    }

    setState(() {
      board[row][col] = ChessPiece(
        chosen,
        movedPiece.color,
        hasMoved: true,
      );
    });

    return chosen;
  }

  /// 🔸 دالة تحدد نوع القطعة المقابلة في الدعم حسب قانون شطارة
  PieceType? getSupportHintType(PieceType movedType) {
    switch (movedType) {
      case PieceType.pawn:
        return PieceType.knight; // البيدق → حصان
      case PieceType.knight:
        return PieceType.bishop; // الحصان → فيل
      case PieceType.bishop:
        return PieceType.rook; // الفيل → قلعة
      case PieceType.rook:
        return PieceType.queen; // القلعة → وزير
      default:
        return null; // الملك والوزير لا يترقيان
    }
  }

  // AI move (صار async عشان يوقف عند الترقية)
  Future<void> _makeAIMove() async {
    if (isGameOver) return;

    final aiMovingColor = currentPlayerColor;
    final opponentColor = aiMovingColor == PlayerColor.white
        ? PlayerColor.black
        : PlayerColor.white;

    int bestScore = -9999;
    Move? bestMove;

    // نسخة مؤقتة من الرقعة للتحليل
    List<List<ChessPiece?>> tempBoard =
        List.generate(8, (i) => List<ChessPiece?>.from(board[i]));

    int searchDepth = switch (difficulty) {
      'مبتدئ' => 2,
      'متوسط' => 3,
      'متقدم' => 4,
      _ => 2,
    };

    List<Move> allMoves = [];

    /// ========================
    /// 🧠 توليد جميع الحركات القانونية
    /// ========================
    for (int fromRow = 0; fromRow < 8; fromRow++) {
      for (int fromCol = 0; fromCol < 8; fromCol++) {
        final piece = tempBoard[fromRow][fromCol];
        if (piece == null || piece.color != aiMovingColor) continue;

        for (int toRow = 0; toRow < 8; toRow++) {
          for (int toCol = 0; toCol < 8; toCol++) {
            if (!isValidMove(
              fromRow,
              fromCol,
              toRow,
              toCol,
              tempBoard,
              enPassantTarget: enPassantTarget,
            )) {
              continue;
            }

            // 🚫 منع التبييت للـ AI (حل مشكلة تحرك الملك مربعين)
            if (piece.type == PieceType.king && (toCol - fromCol).abs() == 2) {
              continue;
            }

            // محاكاة الحركة
            final captured = tempBoard[toRow][toCol];
            tempBoard[toRow][toCol] = piece;
            tempBoard[fromRow][fromCol] = null;

            final stillSafe = !isKingInCheck(aiMovingColor, tempBoard);

            // تراجع
            tempBoard[fromRow][fromCol] = piece;
            tempBoard[toRow][toCol] = captured;

            if (stillSafe) {
              allMoves.add(Move(fromRow, fromCol, toRow, toCol));
            }
          }
        }
      }
    }

    /// ========================
    /// 🚫 لا توجد حركات
    /// ========================
    if (allMoves.isEmpty) {
      if (isKingInCheck(aiMovingColor, board)) {
        _showError(aiMovingColor == PlayerColor.white
            ? '♔ كش مات للأبيض!'
            : '♚ كش مات للأسود!');
      } else {
        _showError('🤝 تعادل (جمود)');
      }
      isGameOver = true;
      setState(() {});
      return;
    }

    /// ========================
    /// 🔍 اختيار أفضل حركة (Minimax)
    /// ========================
    if (allMoves.length == 1) {
      bestMove = allMoves.first;
    } else {
      for (final move in allMoves) {
        final piece = tempBoard[move.fromRow][move.fromCol];
        final captured = tempBoard[move.toRow][move.toCol];

        tempBoard[move.toRow][move.toCol] = piece;
        tempBoard[move.fromRow][move.fromCol] = null;

        final score = minimaxWithAlphaBeta(
          tempBoard,
          searchDepth - 1,
          false,
          -9999,
          9999,
        );

        tempBoard[move.fromRow][move.fromCol] = piece;
        tempBoard[move.toRow][move.toCol] = captured;

        if (score > bestScore) {
          bestScore = score;
          bestMove = move;
        }
      }
    }

    bestMove ??= allMoves.first;

    /// ========================
    /// ✅ تنفيذ الحركة فعليًا
    /// ========================
    final fromRow = bestMove.fromRow;
    final fromCol = bestMove.fromCol;
    final toRow = bestMove.toRow;
    final toCol = bestMove.toCol;

    final movedPiece = board[fromRow][fromCol];
    if (movedPiece == null) return;

    // ✅ أكل بالمرور
    if (movedPiece.type == PieceType.pawn &&
        (toCol - fromCol).abs() == 1 &&
        board[toRow][toCol] == null &&
        enPassantTarget == Offset(toRow.toDouble(), toCol.toDouble())) {
      int capturedRow =
          movedPiece.color == PlayerColor.white ? toRow + 1 : toRow - 1;
      board[capturedRow][toCol] = null;
    }

    // الحركة الأساسية
    setState(() {
      board[toRow][toCol] = movedPiece;
      board[fromRow][fromCol] = null;
      movedPiece.hasMoved = true;
    });

    // ✅ ترقية البيدق تلقائيًا (مؤقتًا وزير فقط)
    if (movedPiece.type == PieceType.pawn &&
        ((movedPiece.color == PlayerColor.white && toRow == 0) ||
            (movedPiece.color == PlayerColor.black && toRow == 7))) {
      setState(() {
        board[toRow][toCol] =
            ChessPiece(PieceType.queen, movedPiece.color, hasMoved: true);
      });
    }

    _updateEnPassantTarget(movedPiece, fromRow, toRow, toCol);

    /// ========================
    /// 📝 تسجيل الحركة
    /// ========================
    final moveNotation =
        '${_getPieceSymbol(movedPiece)} ${_getSquareName(fromRow, fromCol)}-${_getSquareName(toRow, toCol)}';

    movesHistory.add(
      aiMovingColor == PlayerColor.white
          ? '褐 $moveNotation'
          : '黑 $moveNotation',
    );

    await _saveMoveToFirestore(
      from: _getSquareName(fromRow, fromCol),
      to: _getSquareName(toRow, toCol),
      notation: moveNotation,
      pieceType: movedPiece.type,
      color: aiMovingColor,
    );

    lastFrom = Offset(fromRow.toDouble(), fromCol.toDouble());
    lastTo = Offset(toRow.toDouble(), toCol.toDouble());

    currentPlayerColor = opponentColor;

    setState(() {});
    _checkForGameOver();
  }

  void _showKingInCheckDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('⚠️ تنبيه'),
          content: Text('الملك في خطر!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('حسنًا'),
            ),
          ],
        );
      },
    );
  }

  PieceType _getPieceTypeFromAsset(String assetName) {
    final lower = assetName.toLowerCase();

    if (lower.contains('pawn')) return PieceType.pawn;
    if (lower.contains('knight') || lower.contains('horse'))
      return PieceType.knight;
    if (lower.contains('bishop')) return PieceType.bishop;
    if (lower.contains('rook')) return PieceType.rook;
    if (lower.contains('queen')) return PieceType.queen;
    if (lower.contains('king')) return PieceType.king;

    throw Exception('❌ نوع غير معروف في اسم الصورة: $assetName');
  }

  void _updateEnPassantTarget(
      ChessPiece? piece, int fromRow, int toRow, int col) {
    if (piece != null &&
        piece.type == PieceType.pawn &&
        (fromRow - toRow).abs() == 2) {
      int direction = piece.color == PlayerColor.white ? 1 : -1;
      enPassantTarget = Offset((toRow + direction).toDouble(), col.toDouble());
    } else {
      enPassantTarget = null;
    }
  }

  // تنفيذ التبييت فعليًا على اللوح (بدون فحص)
  void _performCastling(ChessPiece movingPiece, int row, int col) {
    if (col > selectedCol!) {
      final rook = board[row][7];
      if (rook != null &&
          rook.type == PieceType.rook &&
          !movingPiece.hasMoved &&
          !rook.hasMoved) {
        board[row][col] = movingPiece;
        board[selectedRow!][selectedCol!] = null;
        board[row][col - 1] = rook;
        board[row][7] = null;

        movingPiece.hasMoved = true;
        rook.hasMoved = true;
      } else {
        return;
      }
    } else {
      final rook = board[row][0];
      if (rook != null &&
          rook.type == PieceType.rook &&
          !movingPiece.hasMoved &&
          !rook.hasMoved) {
        board[row][col] = movingPiece;
        board[selectedRow!][selectedCol!] = null;
        board[row][col + 1] = rook;
        board[row][0] = null;

        movingPiece.hasMoved = true;
        rook.hasMoved = true;
      } else {
        return;
      }
    }
  }

  Future<void> _checkForGameOver() async {
    if (_isCheckmate(currentPlayerColor)) {
      isGameOver = true;
      moveTimer?.cancel();

      final winnerColor = currentPlayerColor == PlayerColor.white
          ? PlayerColor.black
          : PlayerColor.white;

      // إذا كان الفائز هو المستخدم: زِد wins
      if (winnerColor == _pieceColor) {
        await _incrementWinsIfLoggedIn();
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('🏆 النهاية'),
            content: Text(
              winnerColor == PlayerColor.white ? 'الأبيض ربح!' : 'الأسود ربح!',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetGame();
                },
                child: const Text('🔄 إعادة اللعب'),
              ),
            ],
          );
        },
      );
    } else if (_isStalemate(currentPlayerColor)) {
      isGameOver = true;
      moveTimer?.cancel();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('🤝 تعادل'),
            content: const Text('انتهت المباراة بحالة خنق (Stalemate).'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetGame();
                },
                child: const Text('🔄 إعادة اللعب'),
              ),
            ],
          );
        },
      );
    }
  }

  //زيادة عدد مرات الفوز
  Future<void> _safeIncrementUserField({
    required String uid,
    required String fieldName,
  }) async {
    final ref = FirebaseFirestore.instance.collection('users').doc(uid);

    await FirebaseFirestore.instance.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) return;

      final data = snap.data() as Map<String, dynamic>? ?? {};
      final current = data[fieldName];

      // إذا كان رقم: استعمل FieldValue.increment
      if (current is num) {
        tx.update(ref, {fieldName: FieldValue.increment(1)});
        return;
      }

      // إذا كان نصًا: حوّله لرقم، ثم خزّنه كنص (نفس النمط الحالي)
      if (current is String) {
        final parsed = int.tryParse(current) ?? 0;
        final next = parsed + 1;
        tx.update(ref, {fieldName: next.toString()});
        return;
      }

      // غير موجود/نوع غير معروف: ابدأ من 1 (رقم)
      tx.update(ref, {fieldName: 1});
    });
  }

  Future<void> _incrementWinsIfLoggedIn() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await _safeIncrementUserField(uid: uid, fieldName: 'wins');
  }

  Future<void> _incrementPlayComputerIfLoggedIn() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await _safeIncrementUserField(uid: uid, fieldName: 'play_computer');
  }

  // إدخال/استبدال من منطقة الدعم (ممنوع أثناء الكش)
  void _replacePawnWithSupportPiece(
      int fromRow, int fromCol, int supportIndex, PlayerColor color) {
    // ✅ منع أي استخدام لمنطقة الدعم إذا الملك في كش
    if (isKingInCheck(color, board)) {
      _showError('❌ لا يمكنك استخدام منطقة الدعم بينما ملكك في كش!');
      return;
    }

    final piece = board[fromRow][fromCol];

    if (!pieceImages.containsKey(supportIndex)) {
      _showError('⚠️ لا توجد قطعة دعم في هذا الموقع!');
      return;
    }

    final assetName = pieceImages[supportIndex]!;
    if ((color == PlayerColor.white && assetName.contains('black')) ||
        (color == PlayerColor.black && assetName.contains('white'))) {
      _showError('⚠️ لا يمكنك استخدام قطعة من لون الخصم!');
      return;
    }

    final newType = _getPieceTypeFromAsset(assetName);
    final isTargetCellEmpty = board[fromRow][fromCol] == null;

    int pawnCount = 0;
    int totalCount = 0;
    for (var row in board) {
      for (var cell in row) {
        if (cell != null && cell.color == color) {
          totalCount++;
          if (cell.type == PieceType.pawn) pawnCount++;
        }
      }
    }

    // ✅ إدخال بيدق جديد من الدعم (صف 6 للأبيض، صف 1 للأسود)
    if (newType == PieceType.pawn &&
        isTargetCellEmpty &&
        ((color == PlayerColor.white && fromRow == 6) ||
            (color == PlayerColor.black && fromRow == 1))) {
      if (totalCount >= 16 || pawnCount >= 8) {
        _showError(
            '⚠️ لا يمكنك إدخال بيدق لأن عدد القطع أو البيادق تجاوز الحد!');
        return;
      }

      setState(() {
        board[fromRow][fromCol] =
            ChessPiece(PieceType.pawn, color, hasMoved: false);

        pieceImages.remove(supportIndex);

        selectedRow = null;
        selectedCol = null;
        possibleMoves.clear();

        enPassantTarget = null;

        currentPlayerColor = (color == PlayerColor.white)
            ? PlayerColor.black
            : PlayerColor.white;

        startProperTimer();
      });

      movesHistory.add(
        (color == PlayerColor.white ? '褐' : '黑') +
            ' إدخال بيدق من الدعم إلى ${_getSquareName(fromRow, fromCol)}',
      );

      // ✅ إرسال الحركة للشبكة
      if (_isLocalFriendMode) {
        _saveMoveToFirestore(
          from: _getSquareName(fromRow, fromCol),
          to: _getSquareName(fromRow, fromCol),
          notation: 'support_pawn_drop',
          pieceType: PieceType.pawn,
          color: color,
          moveType: 'support_drop',
          extraData: {
            'support_piece': 'pawn',
            'support_index': supportIndex,
          },
        );
      }

      if (!_isLocalFriendMode &&
          isSinglePlayerMode &&
          currentPlayerColor == aiColor) {
        Future.delayed(const Duration(milliseconds: 500), _makeAIMove);
      }

      return;
    }

    // ⚠️ التحقق من وجود قطعة للاستبدال
    if (piece == null) {
      _showError('⚠️ لا توجد قطعة للاستبدال!');
      return;
    }

    // ⚠️ لا يمكن استبدال قطعة لم تتحرك بعد
    if (!piece.hasMoved) {
      _showError('⚠️ لا يمكنك استبدال قطعة لم تتحرك!');
      return;
    }

    // 🚫 منع استبدال الملك أو الوزير
    if (piece.type == PieceType.king || piece.type == PieceType.queen) {
      _showError('❌ لا يمكنك استبدال الملك أو الوزير!');
      return;
    }

    // ⚙️ قواعد الترقية/الاستبدال الخاصة بشطارة
    if (piece.type == PieceType.pawn && newType != PieceType.knight) {
      _showError('❌ يمكنك فقط استبدال البيدق بـ "حصان"!');
      return;
    } else if (piece.type == PieceType.bishop && newType != PieceType.rook) {
      _showError('❌ يمكنك فقط استبدال الفيل بـ "قلعة"!');
      return;
    } else if (piece.type == PieceType.knight && newType != PieceType.bishop) {
      _showError('❌ يمكنك فقط استبدال الحصان بـ "فيل"!');
      return;
    } else if (piece.type == PieceType.rook && newType != PieceType.queen) {
      _showError('❌ يمكنك فقط استبدال القلعة بـ "وزير"!');
      return;
    }

    // 🚫 منع الترقية أو الاستبدال إذا ملك اللاعب في وضع كش
    if (isKingInCheck(color, board)) {
      _showError('❌ لا يمكنك الترقية أو الاستبدال بينما ملكك في وضع كش!');
      return;
    }

    // 🚫 منع الترقية التي تضع ملك الخصم في كش فوري
    final tempBoard = List.generate(8, (r) => List<ChessPiece?>.from(board[r]));
    final opponentColor =
        (color == PlayerColor.white) ? PlayerColor.black : PlayerColor.white;

    final oldPiece = tempBoard[fromRow][fromCol];
    tempBoard[fromRow][fromCol] = ChessPiece(newType, color, hasMoved: true);

    if (isKingInCheck(opponentColor, tempBoard)) {
      _showError('⚠️ لا يمكنك تنفيذ ترقية تؤدي إلى كش فوري للملك الخصم!');
      return;
    }

    // ✅ تنفيذ الترقية أو الاستبدال
    setState(() {
      board[fromRow][fromCol] =
          ChessPiece(newType, piece.color, hasMoved: true);
      pieceImages[supportIndex] = _getAssetName(piece.type, piece.color);

      selectedRow = null;
      selectedCol = null;
      possibleMoves.clear();
      enPassantTarget = null;

      currentPlayerColor = (piece.color == PlayerColor.white)
          ? PlayerColor.black
          : PlayerColor.white;

      startProperTimer();
    });

    movesHistory.add(
      (piece.color == PlayerColor.white ? '褐' : '黑') +
          ' ترقية ${_getPieceName(piece.type)} إلى ${_getPieceName(newType)}',
    );

    if (_isLocalFriendMode) {
      _saveMoveToFirestore(
        from: _getSquareName(fromRow, fromCol),
        to: _getSquareName(fromRow, fromCol),
        notation: 'support_promotion',
        pieceType: piece.type,
        color: piece.color,
        promotion: newType.name,
        moveType: 'support_swap',
        extraData: {
          'support_piece': newType.name,
          'board_piece': piece.type.name,
          'support_index': supportIndex,
        },
      );
    }

    if (!_isLocalFriendMode &&
        isSinglePlayerMode &&
        currentPlayerColor == aiColor) {
      Future.delayed(const Duration(milliseconds: 500), _makeAIMove);
    }

    _captureWithSupportAfterMove(
      by: (color == playerColor) ? 'player' : 'ai',
      moveNotation: 'دعم: ... (اشرح التغيير إن شئت)',
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildLocalNetworkStatusCard() {
    if (!_isLocalFriendMode) {
      return ElevatedButton(
        onPressed: _showLocalFriendSetupDialog,
        child: const Text('شبكي محلي'),
      );
    }

    final code = _localGameCode;
    final invite = (code == null || code.isEmpty)
        ? '-'
        : '${Uri.base.origin}/#/playNow?mode=friend&code=$code';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('وضع الشبكي المحلي مفعل'),
            const SizedBox(height: 8),
            SelectableText('الكود: ${code ?? '-'}'),
            const SizedBox(height: 8),
            SelectableText(invite),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _showLocalFriendSetupDialog,
              child: const Text('إدارة المباراة'),
            ),
          ],
        ),
      ),
    );
  }

  String _getAssetName(PieceType type, PlayerColor color) {
    final colorName = color == PlayerColor.white ? 'white' : 'black';
    final name = switch (type) {
      PieceType.king => 'king',
      PieceType.queen => 'queen',
      PieceType.rook => 'rook',
      PieceType.bishop => 'bishop',
      PieceType.knight => 'horse',
      PieceType.pawn => 'pawn',
    };
    return '$colorName\_$name.svg';
  }

  String _getPieceName(PieceType type) {
    switch (type) {
      case PieceType.king:
        return "ملك";
      case PieceType.queen:
        return "وزير";
      case PieceType.rook:
        return "قلعة";
      case PieceType.bishop:
        return "فيل";
      case PieceType.knight:
        return "حصان";
      case PieceType.pawn:
        return "جندي";
    }
  }

  List<Offset> _calculatePossibleMoves(int fromRow, int fromCol) {
    List<Offset> moves = [];
    final piece = board[fromRow][fromCol];

    if (piece == null) return moves;

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if (isValidMove(fromRow, fromCol, row, col, board,
            enPassantTarget: enPassantTarget)) {
          final isCastlingMove =
              piece.type == PieceType.king && (col - fromCol).abs() == 2;

          if (isCastlingMove) {
            if (col > fromCol && !canCastleKingside(piece.color, board))
              continue;
            if (col < fromCol && !canCastleQueenside(piece.color, board))
              continue;
          }

          final temp = board[row][col];
          board[row][col] = board[fromRow][fromCol];
          board[fromRow][fromCol] = null;

          final inCheck = isKingInCheck(currentPlayerColor, board);

          board[fromRow][fromCol] = board[row][col];
          board[row][col] = temp;

          if (!inCheck) {
            moves.add(Offset(row.toDouble(), col.toDouble()));
          }
        }
      }
    }

    return moves;
  }

  Widget _buildSupportPanelMobile(PlayerColor color, double squareSize) {
    // 🔸 تعريف صفوف القطع لكل لون
    List<List<int>> rows = color == PlayerColor.black
        ? const [
            [0, 1, 2, 3],
            [4, 5, 6, 7],
            [8, 9, 10, 11],
          ]
        : const [
            [20, 21, 22, 23],
            [24, 25, 26, 27],
            [28, 29, 30, 31],
          ];

    // 🔸 قلب الترتيب إذا كانت الرقعة مقلوبة
    final displayRows = isBoardFlipped
        ? rows.reversed.map((r) => r.reversed.toList()).toList()
        : rows;

    // 🔹 دالة لبناء خلية قطعة واحدة
    Widget buildCell(int index) {
      final asset = pieceImages[index];
      final type = (asset != null) ? _getPieceTypeFromAsset(asset) : null;

      // ✅ تلوين القطعة فقط إذا:
      // 1. نوعها مطابق لتلميح الترقية
      // 2. لون التلميح مطابق لمنطقة الدعم الحالية
      final isHighlighted = (type != null &&
          highlightedSupportType == type &&
          highlightedSupportColor != null &&
          highlightedSupportColor == color &&
          selectedRow != null &&
          selectedCol != null &&
          board[selectedRow!][selectedCol!] != null &&
          board[selectedRow!][selectedCol!]!.hasMoved);

      return GestureDetector(
        onTap: () {
          if (isGameOver || asset == null) return;

          final assetColor = _getColorFromAsset(asset);
          // لا يمكن استخدام قطعة من لون الخصم
          if (assetColor != currentPlayerColor) return;

          if (selectedRow == null || selectedCol == null) return;

          // استبدال القطعة من منطقة الدعم
          _replacePawnWithSupportPiece(
            selectedRow!,
            selectedCol!,
            index,
            currentPlayerColor,
          );

          setState(() {
            selectedRow = null;
            selectedCol = null;
            possibleMoves.clear();
          });
        },
        child: Container(
          width: squareSize,
          height: squareSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isHighlighted
                ? Colors.green.withOpacity(0.30)
                : Colors.transparent,
            border: Border.all(
              color: isHighlighted ? Colors.green : Colors.transparent,
              width: isHighlighted ? 2 : 0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: asset == null
              ? const SizedBox.shrink()
              : SvgPicture.asset(
                  'assets/images/$asset',
                  fit: BoxFit.contain,
                ),
        ),
      );
    }

    // 🔹 عرض منطقة الدعم (3 صفوف × 4 أعمدة)
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: displayRows
          .map(
            (indices) => SizedBox(
              height: squareSize,
              width: squareSize * 4,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                ),
                itemCount: 4,
                itemBuilder: (_, i) => buildCell(indices[i]),
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // قياسات عامة
    final media = MediaQuery.of(context);
    final double screenW = media.size.width;
    final double screenH = media.size.height;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 900;

            if (isMobile) {
              // 🟣 موبايل: بدون Scroll — كل المحتوى ضمن ارتفاع الشاشة
              final double w = constraints.maxWidth;
              final double h = constraints.maxHeight;

              // توزيع نسبي للارتفاع
              final double topBarH = 56; // Navbar
              final double buttonsH = 44;
              final double gapSmall = 8;
              final double gapMed = 10;

              // المساحة المتبقية للوحة + الدعم
              final double remainH =
                  h - (topBarH + buttonsH + gapSmall + gapMed * 6);
              // حصّص: دعم علوي 0.18, رقعة 0.54, دعم سفلي 0.18 تقريبًا
              final double supportH = remainH * 0.18;
              final double boardH = remainH * 0.54;

              // حجم الرقعة = مربّع 9x9 (يشمل صف/عمود التسميات)
              final double boardSize = math.min(w, boardH);
              final double tileSize = boardSize / 9;
              final double supportTileSize = tileSize; // نفس حجم مربعات الرقعة

              Widget movesLog = const SizedBox.shrink(); // ❌ مخفي على الموبايل

              // الرقعة الرئيسية
              Widget mainBoard = RepaintBoundary(
                key: _boardOnlyKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: tileSize * 9,
                      height: tileSize * 9,
                      child: Stack(
                        children: [
                          Positioned(
                            left: tileSize,
                            top: tileSize,
                            child: SizedBox(
                              width: tileSize * 8,
                              height: tileSize * 8,
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 64,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 8,
                                ),
                                itemBuilder: (context, index) {
                                  final origRow = index ~/ 8;
                                  final origCol = index % 8;
                                  final row =
                                      isBoardFlipped ? 7 - origRow : origRow;
                                  final col =
                                      isBoardFlipped ? 7 - origCol : origCol;

                                  final piece = board[row][col];
                                  final isWhiteTile = (row + col) % 2 == 0;
                                  final isSelected =
                                      selectedRow == row && selectedCol == col;
                                  final isPossibleMove = possibleMoves.contains(
                                    Offset(row.toDouble(), col.toDouble()),
                                  );
                                  final isLastMoveFrom = lastFrom ==
                                      Offset(row.toDouble(), col.toDouble());
                                  final isLastMoveTo = lastTo ==
                                      Offset(row.toDouble(), col.toDouble());

                                  final backgroundColor = isSelected
                                      ? Colors.greenAccent
                                      : (isLastMoveFrom || isLastMoveTo)
                                          ? Colors.amberAccent.withOpacity(0.5)
                                          : isWhiteTile
                                              ? BoardThemes.themes[
                                                  currentTheme]!['light']!
                                              : BoardThemes.themes[
                                                  currentTheme]!['dark']!;

                                  return GestureDetector(
                                    onTap: () => _onTileTapped(row, col),
                                    child: Container(
                                      decoration:
                                          BoxDecoration(color: backgroundColor),
                                      child: Stack(
                                        children: [
                                          if (isPossibleMove)
                                            Container(
                                                color: Colors.green
                                                    .withOpacity(0.3)),
                                          if (piece != null)
                                            Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: SvgPicture.asset(
                                                  _getPieceAsset(piece)!,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: tileSize,
                            left: 0,
                            child: Column(
                              children: List.generate(8, (i) {
                                final number =
                                    isBoardFlipped ? (i + 1) : (8 - i);
                                return SizedBox(
                                  width: tileSize,
                                  height: tileSize,
                                  child: Center(
                                    child: Text(
                                      number.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: tileSize * 9,
                      height: tileSize,
                      child: Row(
                        children: [
                          SizedBox(width: tileSize),
                          ...List.generate(8, (i) {
                            final letterIndex = isBoardFlipped ? 7 - i : i;
                            return SizedBox(
                              width: tileSize,
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + letterIndex),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              );

              // دعم للموبايل (خلايا مربعة تمامًا، مع تلوين الخلية المميزة)
              Widget buildSupportRow(PlayerColor color) {
                return _buildSupportPanelMobile(color, supportTileSize);
              }

              return SizedBox(
                width: w,
                height: h,
                child: Container(
                  color: const Color(0xFFFDF5F9),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 🔹 الأعلى: Navbar + الأزرار
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: topBarH,
                            width: double.infinity,
                            child: CustomPlayNavbar(),
                          ),
                          const SizedBox(height: 6),

                          // 🔹 أزرار التحكم (إعادة – رئيسية – تدوير)
                          SizedBox(
                            height: buttonsH,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // زر إعادة اللعب
                                SizedBox(
                                  width: 90,
                                  height: 36,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFDDDDDC),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                    ),
                                    onPressed: _resetGame,
                                    child: const Text(
                                      'إعادة اللعب',
                                      style: TextStyle(
                                        color: Color(0xFF6B4E45),
                                        fontFamily: 'Alexandria',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // زر الرئيسية
                                SizedBox(
                                  width: 90,
                                  height: 36,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFAB86B9),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => Home()),
                                        (route) => false,
                                      );
                                    },
                                    child: const Text(
                                      'الرئيسية',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Alexandria',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // زر تدوير الرقعة
                                SizedBox(
                                  width: 100,
                                  height: 36,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFB9A16B),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isBoardFlipped = !isBoardFlipped;
                                      });
                                    },
                                    child: const Text(
                                      '🔁 تدوير الرقعة',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Alexandria',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),

// زر تغيير لون الرقعة
                                SizedBox(
                                  width: 90,
                                  height: 36,
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      filled: true,
                                      fillColor: Color(0xFFDDDDDC),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.zero,
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    value: currentTheme,
                                    items: const [
                                      DropdownMenuItem(
                                          value: 'brown',
                                          child: Text("بني كلاسيكي")),
                                      DropdownMenuItem(
                                          value: 'black_white',
                                          child: Text("أبيض / أسود")),
                                      DropdownMenuItem(
                                          value: 'blue_white',
                                          child: Text("أبيض / أزرق")),
                                      DropdownMenuItem(
                                          value: 'brown_modern',
                                          child: Text("بني حديث")),
                                    ],
                                    onChanged: (v) {
                                      setState(() {
                                        currentTheme = v!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // 🔹 الوسط: الدعم + الرقعة
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // دعم علوي + ساعة الكمبيوتر
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildSupportRow(
                                  isBoardFlipped
                                      ? PlayerColor.white
                                      : PlayerColor.black,
                                ),
                                const SizedBox(width: 8),
                                _clockCard(aiTimeRemaining),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // الرقعة تأخذ العرض بالكامل
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: mainBoard,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // دعم سفلي + ساعة اللاعب
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _clockCard(playerTimeRemaining),
                                const SizedBox(width: 8),
                                buildSupportRow(
                                  isBoardFlipped
                                      ? PlayerColor.black
                                      : PlayerColor.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // 🔹 الأسفل: الفوتر
                      Container(
                        width: double.infinity,
                        color: const Color(0xFFEFE8F2),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '© 2025 جميع الحقوق محفوظة لشطارة شطرنج',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Alexandria',
                                color: Color(0xFF6B4E45),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Shatara Chess',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alexandria',
                                color: Color(0xFFAB86B9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // 🖥️ ديسكتوب
              final double w = constraints.maxWidth;
              final double h = constraints.maxHeight;
              final double boardSize = math.min(w, h) * 0.7;
              final double tileSize = boardSize / 9;

              Widget movesLog = Container(
                width: tileSize * 3,
                height: tileSize * 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isBoardFlipped = !isBoardFlipped;
                        });
                      },
                      child: const Text('🔁 تدوير الرقعة'),
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'سجل النقلات',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: movesHistory.length,
                        itemBuilder: (context, index) {
                          final move = movesHistory[index];
                          return ListTile(
                            dense: true,
                            title: Text(move),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );

              // الرقعة الرئيسية لديسكتوب
              Widget mainBoard = RepaintBoundary(
                key: _boardOnlyKey,
                child: Column(
                  children: [
                    // 🔵 شريط الأزرار في نسخة الكمبيوتر (Desktop)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // زر إعادة اللعب
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDDDDDC),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                          ),
                          onPressed: _resetGame,
                          child: const Text(
                            "إعادة اللعب",
                            style: TextStyle(
                              color: Color(0xFF6B4E45),
                              fontFamily: "Alexandria",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // زر الرئيسية
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFAB86B9),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                          ),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Home()),
                              (route) => false,
                            );
                          },
                          child: const Text(
                            "الرئيسية",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Alexandria",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // زر تدوير الرقعة
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB9A16B),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                          ),
                          onPressed: () {
                            setState(() {
                              isBoardFlipped = !isBoardFlipped;
                            });
                          },
                          child: const Text(
                            "🔁 تدوير الرقعة",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Alexandria",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // قائمة اختيار الألوان
                        DropdownButton<String>(
                          value: currentTheme,
                          dropdownColor: Colors.white,
                          items: const [
                            DropdownMenuItem(
                                value: 'brown', child: Text("بني كلاسيكي")),
                            DropdownMenuItem(
                                value: 'black_white',
                                child: Text("أبيض / أسود")),
                            DropdownMenuItem(
                                value: 'blue_white',
                                child: Text("أبيض / أزرق")),
                            DropdownMenuItem(
                                value: 'brown_modern', child: Text("بني حديث")),
                          ],
                          onChanged: (v) {
                            setState(() {
                              currentTheme = v!;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: tileSize * 9,
                      height: tileSize * 9,
                      child: Stack(
                        children: [
                          Positioned(
                            left: tileSize,
                            top: tileSize,
                            child: SizedBox(
                              width: tileSize * 8,
                              height: tileSize * 8,
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 64,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 8,
                                ),
                                itemBuilder: (context, index) {
                                  final origRow = index ~/ 8;
                                  final origCol = index % 8;
                                  final row =
                                      isBoardFlipped ? 7 - origRow : origRow;
                                  final col =
                                      isBoardFlipped ? 7 - origCol : origCol;

                                  final piece = board[row][col];
                                  final isWhiteTile = (row + col) % 2 == 0;
                                  final isSelected =
                                      selectedRow == row && selectedCol == col;
                                  final isPossibleMove = possibleMoves.contains(
                                    Offset(row.toDouble(), col.toDouble()),
                                  );
                                  final isLastMoveFrom = lastFrom ==
                                      Offset(row.toDouble(), col.toDouble());
                                  final isLastMoveTo = lastTo ==
                                      Offset(row.toDouble(), col.toDouble());

                                  final backgroundColor = isSelected
                                      ? Colors.greenAccent
                                      : (isLastMoveFrom || isLastMoveTo)
                                          ? Colors.amberAccent.withOpacity(0.5)
                                          : isWhiteTile
                                              ? BoardThemes.themes[
                                                  currentTheme]!['light']!
                                              : BoardThemes.themes[
                                                  currentTheme]!['dark']!;

                                  return GestureDetector(
                                    onTap: () => _onTileTapped(row, col),
                                    child: Container(
                                      decoration:
                                          BoxDecoration(color: backgroundColor),
                                      child: Stack(
                                        children: [
                                          if (isPossibleMove)
                                            Container(
                                                color: Colors.green
                                                    .withOpacity(0.3)),
                                          if (piece != null)
                                            Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: SvgPicture.asset(
                                                  _getPieceAsset(piece)!,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: tileSize,
                            left: 0,
                            child: Column(
                              children: List.generate(8, (i) {
                                final number =
                                    isBoardFlipped ? (i + 1) : (8 - i);
                                return SizedBox(
                                  width: tileSize,
                                  height: tileSize,
                                  child: Center(
                                    child: Text(
                                      number.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: tileSize * 9,
                      height: tileSize,
                      child: Row(
                        children: [
                          SizedBox(width: tileSize),
                          ...List.generate(8, (i) {
                            final letterIndex = isBoardFlipped ? 7 - i : i;
                            return SizedBox(
                              width: tileSize,
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + letterIndex),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              );
              // دعم للديسكتوب: عمودين (سود بالأعلى/بيض بالأسفل) مع تلوين الخلية
              Widget sideBoard = SizedBox(
                width: tileSize * 4,
                child: Column(
                  children: [
                    _buildSupportPanelMobile(
                      isBoardFlipped ? PlayerColor.white : PlayerColor.black,
                      tileSize,
                    ),
                    const SizedBox(height: 8),
                    _buildSupportPanelMobile(
                      isBoardFlipped ? PlayerColor.black : PlayerColor.white,
                      tileSize,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );

              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildLocalNetworkStatusCard(),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          movesLog,
                          const SizedBox(width: 16),
                          mainBoard,
                          const SizedBox(width: 16),
                          sideBoard,
                        ],
                      ),
                      const SizedBox(height: 16),
                      const BottomNavbar(),
                      const SizedBox(height: 8),
                      const FooterCopyright(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Color _getTileColor(int row, int col) {
    if (_isInSupportZone(row, col)) {
      return row < 3 ? Colors.black54 : Colors.black12;
    }
    return Colors.transparent;
  }

  Color _getBorderColor(int row, int col) {
    if (_isInSupportZone(row, col)) {
      return row < 3 ? Colors.white38 : Colors.black;
    }
    return Colors.transparent;
  }

  String? _getPieceAsset(ChessPiece piece) {
    final color = piece.color == PlayerColor.white ? 'white' : 'black';
    final name = switch (piece.type) {
      PieceType.king => 'king',
      PieceType.queen => 'queen',
      PieceType.rook => 'rook',
      PieceType.bishop => 'bishop',
      PieceType.knight => 'horse',
      PieceType.pawn => 'pawn',
    };
    return 'assets/images/${color}_${name}.svg';
  }

  int minimaxWithAlphaBeta(List<List<ChessPiece?>> board, int depth,
      bool isMaximizingPlayer, int alpha, int beta) {
    if (depth == 0) {
      return evaluateBoard(board); // من movePce.dart
    }

    PlayerColor currentColor =
        isMaximizingPlayer ? PlayerColor.black : PlayerColor.white;
    List<Move> moves = generateAllLegalMoves(board, currentColor);

    moves.sort((a, b) {
      final aPiece = board[a.toRow][a.toCol];
      final bPiece = board[b.toRow][b.toCol];
      return (bPiece != null ? 1 : 0) - (aPiece != null ? 1 : 0);
    });

    if (isMaximizingPlayer) {
      int bestScore = -9999;
      for (Move move in moves) {
        final movedPiece = board[move.fromRow][move.fromCol];
        final captured = board[move.toRow][move.toCol];

        board[move.toRow][move.toCol] = movedPiece;
        board[move.fromRow][move.fromCol] = null;

        int score = minimaxWithAlphaBeta(board, depth - 1, false, alpha, beta);

        board[move.fromRow][move.fromCol] = movedPiece;
        board[move.toRow][move.toCol] = captured;

        bestScore = score > bestScore ? score : bestScore;
        alpha = alpha > bestScore ? alpha : bestScore;
        if (beta <= alpha) break;
      }
      return bestScore;
    } else {
      int bestScore = 9999;
      for (Move move in moves) {
        final movedPiece = board[move.fromRow][move.fromCol];
        final captured = board[move.toRow][move.toCol];

        board[move.toRow][move.toCol] = movedPiece;
        board[move.fromRow][move.fromCol] = null;

        int score = minimaxWithAlphaBeta(board, depth - 1, true, alpha, beta);

        board[move.fromRow][move.fromCol] = movedPiece;
        board[move.toRow][move.toCol] = captured;

        bestScore = score < bestScore ? score : bestScore;
        beta = beta < bestScore ? beta : bestScore;
        if (beta <= alpha) break;
      }
      return bestScore;
    }
  }

  void _handlePlayerTimeOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('انتهى وقتك!'),
          content: Text('لقد انتهى وقتك، الكمبيوتر يفوز!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Future.delayed(Duration(milliseconds: 300), () {
                  moveTimer?.cancel();
                  _resetGame();
                });
              },
              child: Text('إعادة اللعب'),
            ),
          ],
        );
      },
    );
  }

  PlayerColor _getPieceColorFromAsset(String assetName) {
    if (assetName.contains('white')) return PlayerColor.white;
    if (assetName.contains('black')) return PlayerColor.black;
    throw Exception('لون غير معروف في: $assetName');
  }

  // دوال مساعدة
  String _getPieceSymbol(ChessPiece piece) {
    if (piece.color == PlayerColor.white) {
      switch (piece.type) {
        case PieceType.king:
          return '♔';
        case PieceType.queen:
          return '♕';
        case PieceType.rook:
          return '♖';
        case PieceType.bishop:
          return '♗';
        case PieceType.knight:
          return '♘';
        case PieceType.pawn:
          return '♙';
      }
    } else {
      switch (piece.type) {
        case PieceType.king:
          return '♚';
        case PieceType.queen:
          return '♛';
        case PieceType.rook:
          return '♜';
        case PieceType.bishop:
          return '♝';
        case PieceType.knight:
          return '♞';
        case PieceType.pawn:
          return '♟';
      }
    }
  }

  String _getSquareName(int row, int col) {
    String columnLetter = String.fromCharCode('a'.codeUnitAt(0) + col);
    int rowNumber = 8 - row;
    return '$columnLetter$rowNumber';
  }

  Widget _clockCard(int seconds) {
    final timeStr = getFormattedTime(seconds);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black26, width: 1),
        boxShadow: const [
          BoxShadow(blurRadius: 4, color: Colors.black12, offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        timeStr,
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 26),
      ),
    );
  }
}

// دالة توليد الحركات القانونية (UI)
List<Move> generateAllLegalMoves(
    List<List<ChessPiece?>> board, PlayerColor color) {
  List<Move> moves = [];

  for (int fromRow = 0; fromRow < 8; fromRow++) {
    for (int fromCol = 0; fromCol < 8; fromCol++) {
      final piece = board[fromRow][fromCol];
      if (piece == null || piece.color != color) continue;

      for (int toRow = 0; toRow < 8; toRow++) {
        for (int toCol = 0; toCol < 8; toCol++) {
          if (isValidMove(fromRow, fromCol, toRow, toCol, board)) {
            final temp = board[toRow][toCol];
            board[toRow][toCol] = piece;
            board[fromRow][fromCol] = null;

            bool inCheck = isKingInCheck(color, board);

            board[fromRow][fromCol] = piece;
            board[toRow][toCol] = temp;

            if (!inCheck) {
              moves.add(Move(fromRow, fromCol, toRow, toCol));
            }
          }
        }
      }
    }
  }

  return moves;
}

Widget _buildDrawer(BuildContext context) {
  return StatefulBuilder(
    builder: (context, setState) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;

      bool isAnyDrawerHovering = false;
      return ClipRRect(
        borderRadius: BorderRadius.zero,
        child: Drawer(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          backgroundColor: const Color(0xFFDDDDDC),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              children: [
                Image.asset('assets/logon.png', height: 60),
                const Divider(),
                _HoverDrawerItem(
                  label: 'تعرف على شطاره',
                  route: '/main',
                  isAnyHovering: isAnyDrawerHovering,
                  onHoverChanged: (hovering) =>
                      setState(() => isAnyDrawerHovering = hovering),
                ),
                _HoverDrawerItem(
                  label: 'من نحن',
                  route: '/about',
                  isAnyHovering: isAnyDrawerHovering,
                  onHoverChanged: (hovering) =>
                      setState(() => isAnyDrawerHovering = hovering),
                ),
                _HoverDrawerItem(
                  label: 'الاسئلة الشائعة',
                  route: '/faq',
                  isAnyHovering: isAnyDrawerHovering,
                  onHoverChanged: (hovering) =>
                      setState(() => isAnyDrawerHovering = hovering),
                ),
                _HoverDrawerItem(
                  label: 'ألعب الأن',
                  route: '/playNow',
                  isSpecialActive: true,
                  isAnyHovering: isAnyDrawerHovering,
                  onHoverChanged: (hovering) =>
                      setState(() => isAnyDrawerHovering = hovering),
                ),
                _HoverDrawerItem(
                  label: 'المجتمع',
                  route: '/aboutn',
                  isAnyHovering: isAnyDrawerHovering,
                  onHoverChanged: (hovering) =>
                      setState(() => isAnyDrawerHovering = hovering),
                ),
                _HoverDrawerItem(
                  label: 'المتجر',
                  route: '/store',
                  isAnyHovering: isAnyDrawerHovering,
                  onHoverChanged: (hovering) =>
                      setState(() => isAnyDrawerHovering = hovering),
                ),
                _HoverDrawerItem(
                  label: 'أكاديمية شطارة',
                  route: '/learn',
                  isAnyHovering: isAnyDrawerHovering,
                  onHoverChanged: (hovering) =>
                      setState(() => isAnyDrawerHovering = hovering),
                ),
                isLoggedIn
                    ? _HoverDrawerItem(
                        label: 'تسجيل الخروج',
                        route: '/main',
                        isAlwaysActive: true,
                        onTapOverride: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacementNamed(context, '/main');
                        },
                      )
                    : _HoverDrawerItem(
                        label: 'تسجيل الدخول',
                        route: '/login',
                        isAlwaysActive: true,
                      ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _HoverDrawerItem extends StatefulWidget {
  final String label;
  final String route;
  final bool isSpecialActive;
  final bool isAlwaysActive;
  final bool isAnyHovering;
  final Function(bool)? onHoverChanged;
  final VoidCallback? onTapOverride;

  const _HoverDrawerItem({
    required this.label,
    required this.route,
    this.isSpecialActive = false,
    this.isAlwaysActive = false,
    this.isAnyHovering = false,
    this.onHoverChanged,
    this.onTapOverride,
  });

  @override
  State<_HoverDrawerItem> createState() => _HoverDrawerItemState();
}

class _HoverDrawerItemState extends State<_HoverDrawerItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    if (widget.isAlwaysActive) {
      backgroundColor = const Color(0xFFAB86B9);
      textColor = Colors.white;
    } else if (widget.isSpecialActive) {
      if (widget.isAnyHovering) {
        backgroundColor = Colors.transparent;
        textColor = const Color(0xFF6B4E45);
      } else {
        backgroundColor = const Color(0xFFAB86B9);
        textColor = Colors.white;
      }
    } else {
      if (_isHovering) {
        backgroundColor = const Color(0xFFAB86B9);
        textColor = Colors.white;
      } else {
        backgroundColor = Colors.transparent;
        textColor = const Color(0xFF6B4E45);
      }
    }

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovering = true);
        widget.onHoverChanged?.call(true);
      },
      onExit: (_) {
        setState(() => _isHovering = false);
        widget.onHoverChanged?.call(false);
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          if (widget.onTapOverride != null) {
            widget.onTapOverride!();
          } else {
            final currentRoute = ModalRoute.of(context)?.settings.name;
            if (currentRoute != widget.route) {
              Navigator.pushNamed(context, widget.route);
            }
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.zero,
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 15,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
