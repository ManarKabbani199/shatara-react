import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/logout_service.dart';

class CustomNavbar extends StatefulWidget {
  const CustomNavbar({super.key});

  @override
  State<CustomNavbar> createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> {
  String? hoveredRoute;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      isLoggedIn = user != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: isMobile
            ? _buildMobileMenuIcon(context) // ☰ أيقونة فقط
            : Row(
                children: _buildNavItems(context), // ✅ ديسكتوب
              ),
      ),
    );
  }

  Widget _buildMobileMenuIcon(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Builder(
        builder: (context) => IconButton(
          icon: const Icon(
            Icons.menu,
            size: 26,
            color: Color(0xFF6B4E45),
          ),
          onPressed: () {
            Scaffold.of(context).openEndDrawer(); // ✅ يفتح Drawer
          },
        ),
      ),
    );
  }

  Widget _mobileIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Icon(
          icon,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }

  // ======================================================
  // 🟤 Navbar الديسكتوب (النصّي)
  // ======================================================
  List<Widget> _buildNavItems(BuildContext context) {
    const spacing = SizedBox(width: 20);

    return [
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Image.asset(
            'assets/logon.png',
            height: 40,
          ),
        ),
      ),
      spacing,
      _navButton('تعرف على شطارة', '/main', isSpecialActive: true),
      spacing,
      _navButton('ألعب الأن', '/playNow'),
      spacing,
      _navButton('خريطة الفتح', '/conquest'),
      spacing,
      _navButton('من نحن', '/about'),
      spacing,
      _navButton('الأسئلة الشائعة', '/faq'),
      const Spacer(),
      _HoverNavButton(
        label: isLoggedIn ? 'تسجيل الخروج' : 'تسجيل الدخول',
        route: isLoggedIn ? '/main' : '/login',
        isAlwaysActive: true,
        isHovered: false,
        isSpecialActive: false,
        onHoverChanged: (_) {},
        onTapOverride: () async {
          if (isLoggedIn) {
            await LogoutService.signOut(
              context,
              redirectRoute: '/home',
            );
          } else {
            Navigator.pushNamed(context, '/login');
          }
        },
      ),
      spacing,
      Image.asset('assets/actionBar.png', height: 40),
    ];
  }

  Widget _navButton(
    String label,
    String route, {
    bool isSpecialActive = false,
  }) {
    return _HoverNavButton(
      label: label,
      route: route,
      isSpecialActive: isSpecialActive,
      isHovered: hoveredRoute == route,
      isAlwaysActive: false,
      onHoverChanged: (isHovering) {
        setState(() {
          hoveredRoute = isHovering ? route : null;
        });
      },
    );
  }
}

// ======================================================
// Hover Button (كما هو عندك)
// ======================================================
class _HoverNavButton extends StatelessWidget {
  final String label;
  final String route;
  final bool isSpecialActive;
  final bool isAlwaysActive;
  final bool isHovered;
  final Function(bool) onHoverChanged;
  final VoidCallback? onTapOverride;

  const _HoverNavButton({
    required this.label,
    required this.route,
    this.isSpecialActive = false,
    this.isAlwaysActive = false,
    required this.isHovered,
    required this.onHoverChanged,
    this.onTapOverride,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    if (isAlwaysActive) {
      backgroundColor = const Color(0xFFAB86B9);
      textColor = Colors.white;
    } else if (isSpecialActive) {
      if (isHovered) {
        backgroundColor = Colors.transparent;
        textColor = const Color(0xFF6B4E45);
      } else {
        backgroundColor = const Color(0xFFAB86B9);
        textColor = Colors.white;
      }
    } else {
      if (isHovered) {
        backgroundColor = const Color(0xFFAB86B9);
        textColor = Colors.white;
      } else {
        backgroundColor = Colors.transparent;
        textColor = const Color(0xFF6B4E45);
      }
    }

    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (onTapOverride != null) {
            onTapOverride!();
          } else {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
