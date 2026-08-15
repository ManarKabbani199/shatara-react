import 'package:flutter/material.dart';

class SocialCard extends StatelessWidget {
  const SocialCard({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Padding(
          padding: const EdgeInsets.all(8), // ✅ تقليل الحشو
          child: isMobile
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMainContent(isCompact: true),
              const SizedBox(height: 8),
              const Divider(height: 1),
              _buildIconsRow(compact: true),
            ],
          )
              : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildMainContent(isCompact: false)),
              const SizedBox(width: 8),
              _buildIconsColumn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent({required bool isCompact}) {
    final textStyle = TextStyle(
      fontSize: isCompact ? 12 : 14,
      color: Colors.grey[800],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الاسم والتاريخ
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("منذ دائم", style: textStyle.copyWith(color: Colors.grey)),
            Text("زكرياء بليوڭ", style: textStyle.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),

        // اليوزر
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "@zjr10__",
            style: textStyle.copyWith(color: Colors.grey),
            textAlign: TextAlign.right,
          ),
        ),

        const SizedBox(height: 6),

        // الوصف
        Text(
          "Hi there! I'm ZJ, an AI enthusiast and fitness aficionado...",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textStyle,
          textAlign: TextAlign.right,
        ),

        const SizedBox(height: 6),

        // الوسوم
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "#photo #street",
            style: textStyle.copyWith(color: Colors.blueAccent),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildIconsColumn() {
    return Container(
      width: 50,
      color: const Color(0xFF6C5851),
      child: Column(
        children: const [
          SizedBox(height: 6),
          Icon(Icons.favorite, color: Colors.white, size: 18),
          Text('6.2K', style: TextStyle(fontSize: 12, color: Colors.white)),
          SizedBox(height: 12),
          Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
          Text('12', style: TextStyle(fontSize: 12, color: Colors.white)),
          SizedBox(height: 12),
          Icon(Icons.repeat, color: Colors.white, size: 18),
          Text('61', style: TextStyle(fontSize: 12, color: Colors.white)),
          SizedBox(height: 12),
          Icon(Icons.bookmark_border, color: Colors.white, size: 18),
          SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildIconsRow({bool compact = false}) {
    double iconSize = compact ? 18 : 22;
    double fontSize = compact ? 11 : 13;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _iconWithText(Icons.favorite, '6.2K', iconSize, fontSize),
        _iconWithText(Icons.chat_bubble_outline, '12', iconSize, fontSize),
        _iconWithText(Icons.repeat, '61', iconSize, fontSize),
        const Icon(Icons.bookmark_border, size: 18, color: Colors.grey),
      ],
    );
  }

  Widget _iconWithText(IconData icon, String text, double size, double fontSize) {
    return Column(
      children: [
        Icon(icon, size: size, color: Colors.grey),
        Text(text, style: TextStyle(fontSize: fontSize, color: Colors.grey)),
      ],
    );
  }
}
