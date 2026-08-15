import 'package:flutter/material.dart';
import '../Widget/AboutPage/AboutIntroSection.dart';
import '../Widget/AboutPage/ContactInfoBanner.dart';
import '../Widget/AboutPage/CustomNavbarAbout.dart';
import '../Widget/AboutPage/ExperienceTabs.dart';
import '../Widget/AboutPage/HistoryTimelineWidget.dart';
import '../Widget/AboutPage/HistoryWayWidget.dart';
import '../Widget/AboutPage/TeamWidget.dart';
import '../Widget/AboutPage/UniqueValueSection.dart';
import '../Widget/AboutPage/UserTestimonials.dart';
import '../Widget/AboutPage/ValuesSectionWidget.dart';
import '../Widget/AboutPage/VisionSection.dart';
import '../Widget/HomePage/BottomNavbar.dart';
import '../Widget/HomePage/ContactSection.dart';
import '../Widget/HomePage/FooterCopyright.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/logout_service.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  bool isAnyDrawerHovering = false;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFDDDDDC),
      endDrawer: isMobile ? _buildDrawer(context) : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // زر فتح Drawer للجوال (يمين)
              if (isMobile)
                Align(
                  alignment: Alignment.topRight,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Color(0xFFAB86B9)),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  ),
                ),

              // صورة الهيرو للجوال: أعلى الصفحة تحت زر القائمة + شريط التنبيه الأحمر
              if (isMobile) ...[
                _buildHeroImage(isMobile),
                const _MobileNoticeBanner(), // الشريط الأحمر العريض
              ],

              // شريط التنقل لسطح المكتب — محاذاة لليمين بدون Row (لتجنّب unbounded width)
              if (!isMobile)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: const CustomNavbarAbout(),
                  ),
                ),

              // صورة الهيرو لسطح المكتب: أعلى المحتوى ومتمركزة
              if (!isMobile) _buildHeroImage(isMobile),

              const SizedBox(height: 35),
              AboutIntroSection(),
              const SizedBox(height: 15),
              UniqueValueSection(),
              const SizedBox(height: 25),
              ExperienceTabs(),
              HistoryTimelineWidget(),
              const SizedBox(height: 5),
              VisionSection(),
              const SizedBox(height: 15),
              ValuesSectionWidget(),
              const SizedBox(height: 15),
              UserTestimonials(),
              const SizedBox(height: 25),
              TeamWidget(),
              const SizedBox(height: 25),
              HistoryWayWidget(),
              const SizedBox(height: 15),
              ContactInfoBanner(),
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
        ),
      ),
    );
  }

  // صورة الهيرو (تعمل على الجوال والديسكتوب)
  Widget _buildHeroImage(bool isMobile) {
    final width = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          top: isMobile ? 8 : 0,
          bottom: isMobile ? 12 : 16,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? width : 520,
          ),
          child: Image.asset(
            'assets/test.png',
            fit: BoxFit.contain,
          ),
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
                    isSpecialActive: true,
                    route: '/about',
                    isAnyHovering: isAnyDrawerHovering,
                    onHoverChanged: (h) => setState(() => isAnyDrawerHovering = h),
                  ),
                  _HoverDrawerItem(
                    label: 'الاسئلة الشائعة',
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

// -------------------------------------------------------
// عنصر القائمة الجانبية مع تأثير التحويم
// -------------------------------------------------------
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
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 15,
                  color: textColor, // ← اعتماد اللون المحسوب ديناميكيًا
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------
// شريط تنبيه للجوال أسفل صورة الهيرو
// -------------------------------------------------------
class _MobileNoticeBanner extends StatelessWidget {
  const _MobileNoticeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.red, // الشريط الأحمر العريض
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.info, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'في الوقت الحالي شطارة تعمل بشكل أفضل على الكمبيوتر',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
