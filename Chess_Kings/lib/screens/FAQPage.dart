// lib/Pages/faq_page.dart
import 'package:flutter/material.dart';

import '../Widget/FAQPage/CustomNavbarFAQ.dart';
import '../Widget/FAQPage/FaqSection.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Widget/HomePage/BottomNavbar.dart';
import '../Widget/HomePage/ContactSection.dart';
import '../Widget/HomePage/FooterCopyright.dart';
import '../services/logout_service.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => FAQPageState();
}

class FAQPageState extends State<FAQPage> {
  bool isAnyDrawerHovering = false;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    final content = SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // ✅ امتلاء العرض
        children: [
          // زر فتح Drawer في الجوال (أعلى يمين)
          if (isMobile)
            Align(
              alignment: Alignment.topRight,
              child: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Color(0xFFAB86B9)),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip: 'القائمة',
                ),
              ),
            ),

          // ✅ الصورة
          if (!isMobile)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/test.png',
                  fit: BoxFit.contain,
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/test.png',
                      height: 80, // عدّلها حسب الحاجة
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 8),
                    // ⬇️ خط أحمر عريض أسفل الصورة
                    Container(
                      width: double.infinity,
                      height: 6,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 8),
                    // ⬇️ نص التنبيه
                    const Text(
                      'في الوقت الحالي شطارة تعمل بشكل أفضل على الكمبيوتر',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ✅ شريط التنقل لغير الجوال — يعرض بكامل الصفحة دون محاذاة خاصة
          if (!isMobile) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,   // ⬅️ كامل العرض
              child: CustomNavbarFAQ(), // لا تجعلها const
            ),
          ],

          const SizedBox(height: 35),
          const FaqSection(),
          const SizedBox(height: 15),
          const BottomNavbar(),
          const SizedBox(height: 5),
          Container(width: double.infinity, height: 2, color: const Color(0xFF999999)),
          const ContactSection(),
          Container(width: double.infinity, height: 2, color: const Color(0xFF999999)),
          const SizedBox(height: 5),
          const FooterCopyright(),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFDDDDDC),
      endDrawer: isMobile ? _buildDrawer(context) : null,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          // ⬇️ بدون Center/ConstrainedBox — الصفحة بكامل العرض
          child: content,
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        final isLoggedIn = FirebaseAuth.instance.currentUser != null;
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
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: Image.asset(
                        'assets/logon.png',
                        height: 60,
                      ),
                    ),
                  ),
                  const Divider(),
                  _HoverDrawerItem(
                    label: 'تعرف على شطاره',
                    route: '/main',
                    isAnyHovering: isAnyDrawerHovering,
                    onHoverChanged: (h) => setState(() => isAnyDrawerHovering = h),
                  ),
                  _HoverDrawerItem(
                    label: 'من نحن',
                    route: '/about',
                    isAnyHovering: isAnyDrawerHovering,
                    onHoverChanged: (h) => setState(() => isAnyDrawerHovering = h),
                  ),
                  _HoverDrawerItem(
                    label: 'الاسئلة الشائعة',
                    isSpecialActive: true,
                    route: '/faq',
                    isAnyHovering: isAnyDrawerHovering,
                    onHoverChanged: (h) => setState(() => isAnyDrawerHovering = h),
                  ),
                  _HoverDrawerItem(
                    label: 'ألعب الأن',
                    route: '/playNow',
                    isAnyHovering: isAnyDrawerHovering,
                    onHoverChanged: (h) => setState(() => isAnyDrawerHovering = h),
                  ),
                  isLoggedIn
                      ? _HoverDrawerItem(
                    label: 'تسجيل الخروج',
                    route: '/home',
                    isAlwaysActive: true,
                    onTapOverride: () async {
                      await LogoutService.signOut(context, redirectRoute: '/main');
                    },
                  )
                      : const _HoverDrawerItem(
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
}

// ✅ عنصر القائمة مع تأثير hover
class _HoverDrawerItem extends StatefulWidget {
  final String label;
  final String route;
  final bool isSpecialActive;
  final bool isAlwaysActive;
  final bool isAnyHovering;
  final Function(bool)? onHoverChanged;
  final VoidCallback? onTapOverride;
  final String? iconPath;

  const _HoverDrawerItem({
    super.key,
    required this.label,
    required this.route,
    this.isSpecialActive = false,
    this.isAlwaysActive = false,
    this.isAnyHovering = false,
    this.onHoverChanged,
    this.onTapOverride,
    this.iconPath,
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
          child: Row(
            children: [
              if (widget.iconPath != null) ...[
                Image.asset(widget.iconPath!, width: 18, height: 18),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: const TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 15,
                ).copyWith(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
