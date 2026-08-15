import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCardWidget extends StatelessWidget {
  final String userName;
  final String userTitle;
  final ImageProvider imagePath;
  final String followersCount;
  final String followingCount;
  final String aboutMe;
  final String statLeft;
  final String statRight;
  final List<dynamic> followersList;
  final List<dynamic> followingList;
  final void Function(BuildContext, List<dynamic>, String) onShowUserList;
  final VoidCallback onFollowPressed;
  final VoidCallback onMessagePressed;
  final bool isFollowing;

  const ProfileCardWidget({
    super.key,
    required this.userName,
    required this.userTitle,
    required this.imagePath,
    required this.followersCount,
    required this.followingCount,
    required this.aboutMe,
    required this.statLeft,
    required this.statRight,
    required this.followersList,
    required this.followingList,
    required this.onShowUserList,
    required this.onFollowPressed,
    required this.onMessagePressed,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    final double titleSize = isMobile ? 18 : 24;
    final double subtitleSize = isMobile ? 12 : 14;
    final double numberSize = isMobile ? 14 : 18;
    final double labelSize = isMobile ? 12 : 14;
    final double aboutSize = isMobile ? 15 : 17;
    final double descSize = isMobile ? 11 : 12;
    final double iconSize = isMobile ? 26 : 30;
    final double imageSize = isMobile ? 50 : 60;
    final double spacing = isMobile ? 12 : 16;

    const Color textColor = Color(0xFF6B4E45);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/backkkb.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => onShowUserList(context, followersList, 'المتابعون'),
                child: _FollowerStat(
                number: followersCount,
                label: "متابعون",
                numberSize: numberSize,
                labelSize: labelSize,
              ),
              ),
              CircleAvatar(
                backgroundImage: imagePath,
                radius: imageSize / 2,
              ),
              GestureDetector(
                onTap: () => onShowUserList(context, followingList, 'يتابع'),
                child: _FollowerStat(
                number: followingCount,
                label: "يتابع",
                numberSize: numberSize,
                labelSize: labelSize,
              ),
              ),
            ],
          ),
          SizedBox(height: spacing),
          Column(
            children: [
              Text(
                userName,
                style: GoogleFonts.alexandria(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                userTitle,
                style: GoogleFonts.alexandria(
                  fontSize: subtitleSize,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: spacing),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "لمحة عني",
              style: GoogleFonts.alexandria(
                fontSize: aboutSize,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            aboutMe,
            style: GoogleFonts.alexandria(
              fontSize: descSize,
              color: Colors.black,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF774E85),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  onPressed: onMessagePressed,
                  child: Text(
                    'مراسلة',
                    style: GoogleFonts.alexandria(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF774E85),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  onPressed: onFollowPressed,
                  child: Text(
                    isFollowing ? 'إلغاء المتابعة' : 'متابعة',
                    style: GoogleFonts.alexandria(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FollowerStat extends StatelessWidget {
  final String number;
  final String label;
  final double numberSize;
  final double labelSize;

  const _FollowerStat({
    required this.number,
    required this.label,
    required this.numberSize,
    required this.labelSize,
  });

  @override
  Widget build(BuildContext context) {
    const Color textColor = Color(0xFF6B4E45);

    return Column(
      children: [
        Text(
          number,
          style: GoogleFonts.alexandria(
            fontSize: numberSize,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.alexandria(
            fontSize: labelSize,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
