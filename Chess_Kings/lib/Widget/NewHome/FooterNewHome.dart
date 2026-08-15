import 'package:flutter/material.dart';
import '../../screens/NewHome.dart';
import '../../screens/PropertyPolicyPage.dart';
import '../../screens/TermsAndConditionsPage.dart';


class FooterNewHome extends StatelessWidget {
  const FooterNewHome({super.key});

  static const primaryColor = Color(0xFFAB86B9);
  static const textColor = Color(0xFF6B4E45);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 40,
          vertical: 40,
        ),
        child: Column(
          children: [
            const SizedBox(height: 5),

            const Divider(
              color: Color(0x336B4E45),
              thickness: 1,
              height: 1,
            ),

            const SizedBox(height: 16),

            isMobile
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '© 2025 شطارة. جميع الحقوق محفوظة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 12,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 20,
                  children: [
                    _FooterLink(
                      text: 'الشروط و الأحكام',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const TermsAndConditionsPage(),
                          ),
                        );
                      },
                    ),
                    _FooterLink(
                      text: 'سياسة الملكية الفكرية',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const PropertyPolicyPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '© 2025 شطارة. جميع الحقوق محفوظة',
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 12,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    _FooterLink(
                      text: 'الشروط و الأحكام',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const TermsAndConditionsPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 20),
                    _FooterLink(
                      text: 'سياسة الملكية الفكرية',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const PropertyPolicyPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ================= COMPONENTS =================

class _FooterLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _FooterLink({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 13,
              color: Color(0xFF6B4E45),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  const _SocialIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xFFAB86B9),
        borderRadius: BorderRadius.zero,
      ),
      child: Icon(icon, size: 16, color: Colors.white),
    );
  }
}

class _SupportButton extends StatelessWidget {
  const _SupportButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFAB86B9),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      onPressed: () {},
      child: const Text(
        'مركز المساعدة و الدعم',
        style: TextStyle(
          fontFamily: 'Alexandria',
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}