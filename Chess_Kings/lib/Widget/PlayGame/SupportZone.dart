import 'package:flutter/material.dart';

import '../../screens/GamePLay/ChessBoard.dart';

/// 🔹 Support Zone — نسخة محسّنة بالكامل
/// - تعتمد على PieceType بدل اسم الصورة
/// - تتعامل مع القطع بشكل ثابت بدون لخبطة بعد الاستبدالات
/// - لا تسبب أخطاء اختيار الملك أو الوزير
class SupportZone extends StatelessWidget {
  final Map<int, String> pieceImages; // id → asset
  final PlayerColor color;
  final PieceType? highlightedSupportType;
  final PlayerColor? highlightedSupportColor;
  final void Function(int index) onPieceTapped;

  const SupportZone({
    Key? key,
    required this.pieceImages,
    required this.color,
    required this.highlightedSupportType,
    required this.highlightedSupportColor,
    required this.onPieceTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    /// 🔥 فلترة القطع حسب اللون بدون الاعتماد على اسم الصورة
    final filtered = pieceImages.entries.where((entry) {
      final type = _pieceType(entry.value);
      final clr = _pieceColor(entry.value);
      return clr == color;
    }).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: isMobile ? 6 : 10,
        crossAxisSpacing: isMobile ? 6 : 10,
      ),
      itemCount: filtered.length,
      itemBuilder: (_, i) {
        final entry = filtered[i];
        final asset = entry.value;

        final type = _pieceType(asset);
        final bool isHighlighted =
            highlightedSupportType == type && highlightedSupportColor == color;

        return GestureDetector(
          onTap: () => onPieceTapped(entry.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(isMobile ? 5 : 8),
            decoration: BoxDecoration(
              color:
                  isHighlighted ? Colors.green.withOpacity(0.25) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isHighlighted ? Colors.green : Colors.grey.shade300,
                width: isHighlighted ? 2 : 1,
              ),
            ),
            child: Image.asset(
              asset,
              width: isMobile ? 28 : 36,
              height: isMobile ? 28 : 36,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  /// 🔹 استخراج نوع القطعة مثلًا من كلمة ضمن الاسم
  PieceType _pieceType(String asset) {
    if (asset.contains('pawn')) return PieceType.pawn;
    if (asset.contains('rook')) return PieceType.rook;
    if (asset.contains('bishop')) return PieceType.bishop;
    if (asset.contains('knight')) return PieceType.knight;
    if (asset.contains('queen')) return PieceType.queen;
    if (asset.contains('king')) return PieceType.king;
    return PieceType.pawn;
  }

  /// 🔹 استخراج لون القطعة من اسم الصورة
  PlayerColor _pieceColor(String asset) {
    if (asset.contains('white')) return PlayerColor.white;
    return PlayerColor.black;
  }
}
