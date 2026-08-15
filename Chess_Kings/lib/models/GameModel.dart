import 'package:cloud_firestore/cloud_firestore.dart';

class GameModel {
  final String gameId;        // 🟢 GameID بدل playerId
  final int playerNumber;     // رقم اللاعب
  final String gameType;      // نوع اللعبة
  final String pieceColor;    // لون الحجر (white / black)
  final DateTime? playedAt;   // التاريخ
  final int wins;             // ✅ عدد الفوز (0 أو 1)

  GameModel({
    required this.gameId,
    required this.playerNumber,
    required this.gameType,
    required this.pieceColor,
    this.playedAt,
    this.wins = 0, // 🟢 القيمة الافتراضية = 0
  });

  factory GameModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final ts = data['playedAt'];
    return GameModel(
      gameId: doc.id,
      playerNumber: (data['playerNumber'] ?? 0) as int,
      gameType: data['gameType'] ?? '',
      pieceColor: data['pieceColor'] ?? 'white',
      playedAt: ts is Timestamp ? ts.toDate() : null,
      wins: (data['wins'] ?? 0) is int
          ? data['wins'] as int
          : int.tryParse(data['wins'].toString()) ?? 0, // 🟢 قراءة الحقل بأمان
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'playerNumber': playerNumber,
      'gameType': gameType,
      'pieceColor': pieceColor,
      'wins': wins, // 🟢 تخزين قيمة الفوز
      if (playedAt != null) 'playedAt': Timestamp.fromDate(playedAt!),
    };
  }

  /// 🟢 تستخدم عند إنشاء اللعبة لأول مرة
  Map<String, dynamic> toCreateMap() {
    return {
      'gameId': gameId,
      'playerNumber': playerNumber,
      'gameType': gameType,
      'pieceColor': pieceColor,
      'wins': 0, // ✅ القيمة الافتراضية عند الإنشاء
      'playedAt': FieldValue.serverTimestamp(),
    };
  }
}
