import 'package:flutter/material.dart';

class TwoStatsRow extends StatelessWidget {
  final String totalUsers;   // مثال: "12,345"
  final String totalTweets;  // مثال: "8,907"

  const TwoStatsRow({
    super.key,
    required this.totalUsers,
    required this.totalTweets,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        final double titleSize = isMobile ? 11 : 15;
        final double valueSize = isMobile ? 15 : 19;
        const color = Color(0xFF6B4E45);

        return Row(
          children: [
            Expanded(
              child: _InfoCard(
                iconAsset: 'assets/icon_users.png',
                title: 'أجمالي المستخدمين',
                value: totalUsers,
                titleSize: titleSize,
                valueSize: valueSize,
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InfoCard(
                iconAsset: 'assets/icon_tweets.png',
                title: 'أجمالي المشاركات',
                value: totalTweets,
                titleSize: titleSize,
                valueSize: valueSize,
                color: color,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String iconAsset;
  final String title;
  final String value;
  final double titleSize;
  final double valueSize;
  final Color color;

  const _InfoCard({
    required this.iconAsset,
    required this.title,
    required this.value,
    required this.titleSize,
    required this.valueSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // خلفية بيضاء
        borderRadius: BorderRadius.circular(12), // الحواف الدائرية
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        textDirection: TextDirection.ltr, // يضمن أن الأيقونة تبقى في اليسار
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(iconAsset, width: 36, height: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end, // نص عربي بمحاذاة يمين
              children: [
                Text(
                  title,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    fontWeight: FontWeight.bold,
                    fontSize: titleSize,   // موبايل 11 / عادي 15
                    color: color,          // 6B4E45
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value, // مثال: "$totalUsers"
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    fontWeight: FontWeight.bold,
                    fontSize: valueSize,   // موبايل 15 / عادي 19
                    color: color,          // 6B4E45
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
