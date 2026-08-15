class LocalGameInfo {
  final int id;
  final String gameCode;
  final String? playerWhite;
  final String? playerBlack;
  final String status;
  final String currentTurn;
  final String createdAt;
  final String updatedAt;

  const LocalGameInfo({
    required this.id,
    required this.gameCode,
    required this.playerWhite,
    required this.playerBlack,
    required this.status,
    required this.currentTurn,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LocalGameInfo.fromJson(Map<String, dynamic> json) {
    return LocalGameInfo(
      id: int.tryParse('${json['id']}') ?? 0,
      gameCode: '${json['game_code'] ?? ''}',
      playerWhite: json['player_white']?.toString(),
      playerBlack: json['player_black']?.toString(),
      status: '${json['status'] ?? 'waiting'}',
      currentTurn: '${json['current_turn'] ?? 'white'}',
      createdAt: '${json['created_at'] ?? ''}',
      updatedAt: '${json['updated_at'] ?? ''}',
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
  final String createdAt;

  const LocalMoveInfo({
    required this.moveNumber,
    required this.fromSquare,
    required this.toSquare,
    required this.pieceType,
    required this.color,
    required this.promotion,
    required this.createdAt,
  });

  factory LocalMoveInfo.fromJson(Map<String, dynamic> json) {
    return LocalMoveInfo(
      moveNumber: int.tryParse('${json['move_number']}') ?? 0,
      fromSquare: '${json['from_square'] ?? ''}',
      toSquare: '${json['to_square'] ?? ''}',
      pieceType: json['piece_type']?.toString(),
      color: json['color']?.toString(),
      promotion: json['promotion']?.toString(),
      createdAt: '${json['created_at'] ?? ''}',
    );
  }
}
