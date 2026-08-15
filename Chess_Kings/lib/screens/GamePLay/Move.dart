class Move {
  final int fromRow;
  final int fromCol;
  final int toRow;
  final int toCol;
  final String? promotion;

  const Move(this.fromRow, this.fromCol, this.toRow, this.toCol,
      {this.promotion});

  Map<String, dynamic> toJson() => {
        'fromRow': fromRow,
        'fromCol': fromCol,
        'toRow': toRow,
        'toCol': toCol,
        'promotion': promotion,
      };

  factory Move.fromJson(Map<String, dynamic> json) => Move(
        (json['fromRow'] as num).toInt(),
        (json['fromCol'] as num).toInt(),
        (json['toRow'] as num).toInt(),
        (json['toCol'] as num).toInt(),
        promotion: json['promotion']?.toString(),
      );
}
