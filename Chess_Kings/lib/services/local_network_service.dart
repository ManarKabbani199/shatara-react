import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/local_network_models.dart';

class LocalNetworkService {
  static const String baseUrl = String.fromEnvironment(
    'CHESS_API_BASE',
    defaultValue: 'https://shatara.sa/chess_api/chess_api',
  );

  static dynamic _decodeJson(http.Response response) {
    final body = response.body.trim();

    if (response.statusCode >= 400) {
      throw Exception('HTTP ${response.statusCode}: $body');
    }

    if (body.isEmpty) {
      throw Exception('Server returned empty response');
    }

    if (body.startsWith('<')) {
      throw Exception('Server returned HTML instead of JSON:\n$body');
    }

    try {
      return jsonDecode(body);
    } catch (_) {
      throw Exception('Failed to parse server response as JSON:\n$body');
    }
  }

  static Future<(String gameCode, String side)> createGame({
    required String playerToken,
    required int initialMinutes,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create_game.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'player_token': playerToken,
        'initial_minutes': initialMinutes,
      }),
    );

    final data = _decodeJson(response) as Map<String, dynamic>;
    if (data['success'] != true) {
      throw Exception(data['error'] ?? 'Failed to create game');
    }

    final gameCode = data['game_code']?.toString();
    final side = data['side']?.toString() ?? 'white';

    if (gameCode == null || gameCode.isEmpty) {
      throw Exception('Game code missing in response');
    }

    return (gameCode, side);
  }

  static Future<(LocalGameInfo game, String side)> joinGame({
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

    final data = _decodeJson(response) as Map<String, dynamic>;
    if (data['success'] != true) {
      throw Exception(data['error'] ?? 'Failed to join game');
    }

    final side = data['side']?.toString() ?? 'black';
    final game = LocalGameInfo.fromJson(
      Map<String, dynamic>.from(data['game'] as Map),
    );

    return (game, side);
  }

  static Future<LocalGameInfo> getGame({
    required String gameCode,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_game.php?game_code=$gameCode'),
    );

    final data = _decodeJson(response) as Map<String, dynamic>;
    if (data['success'] != true) {
      throw Exception(data['error'] ?? 'Failed to get game');
    }

    return LocalGameInfo.fromJson(
      Map<String, dynamic>.from(data['game'] as Map),
    );
  }

  static Future<List<LocalMoveInfo>> getMoves({
    required String gameCode,
    int sinceMoveNumber = 0,
  }) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/get_moves.php?game_code=$gameCode&since_move_number=$sinceMoveNumber',
      ),
    );

    final data = _decodeJson(response) as Map<String, dynamic>;
    if (data['success'] != true) {
      throw Exception(data['error'] ?? 'Failed to get moves');
    }

    final rawMoves = (data['moves'] as List? ?? []);
    return rawMoves
        .map((e) => LocalMoveInfo.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  static Future<int> makeMove({
    required String gameCode,
    required String playerToken,
    required String fromSquare,
    required String toSquare,
    required String pieceType,
    required String color,
    String? promotion,
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
      }),
    );

    final data = _decodeJson(response) as Map<String, dynamic>;
    if (data['success'] != true) {
      throw Exception(data['error'] ?? 'Failed to make move');
    }

    return int.tryParse('${data['move_number']}') ?? 0;
  }
}
