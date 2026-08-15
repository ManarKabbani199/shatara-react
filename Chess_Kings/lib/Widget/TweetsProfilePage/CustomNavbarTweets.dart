import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/logout_service.dart';

class CustomNavbarTweets extends StatefulWidget {
  const CustomNavbarTweets({super.key});

  @override
  State<CustomNavbarTweets> createState() => _CustomNavbarTweetsState();
}

class _CustomNavbarTweetsState extends State<CustomNavbarTweets> {
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
        color: const Color(0xFFDDDDDC),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: isMobile
            ? _buildDrawerIcon(context)
            : Row(
          children: _buildNavItems(context),
        ),
      ),
    );
  }

  Widget _buildDrawerIcon(BuildContext context) {
    return Builder(
      builder: (context) => Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF6B4E45)),
          onPressed: () => Scaffold.of(context).openEndDrawer(),
        ),
      ),
    );
  }

  List<Widget> _buildNavItems(BuildContext context) {
    const spacing = SizedBox(width: 20);

    return [
      MouseRegion(
        cursor: SystemMouseCursors.click, // تغيير المؤشر إلى شكل يد
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
      _navButton('تعرف على شطارة', '/main'),
      spacing,
      _navButton('ألعب الأن', '/playNow'),
      spacing,
      _navButton('من نحن', '/about'),
      spacing,
      _navButton('الأسئلة الشائعة', '/faq'),
      const Spacer(),

      // ✅ تسجيل الدخول / تسجيل الخروج
      _HoverNavButton(
        label: isLoggedIn ? 'تسجيل الخروج' : 'تسجيل الدخول',
        route: isLoggedIn ? '/main' : '/login',
        isAlwaysActive: true,
        isHovered: false,
        isSpecialActive: false,
        onHoverChanged: (_) {},
        onTapOverride: () async {
          if (isLoggedIn) {
            await LogoutService.signOut(context, redirectRoute: '/home');
          } else {
            Navigator.pushNamed(context, '/login');
          }
        },
      ),
      spacing,
      Image.asset('assets/actionBar.png', height: 40),
    ];
  }


  Widget _navButton(String label, String route, {bool isSpecialActive = false}) {
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

  Widget _navButtonWithIcon(String label, String route) {
    return _HoverNavButtonWithIcon(
      label: label,
      route: route,
      isHovered: hoveredRoute == route,
      onHoverChanged: (isHovering) {
        setState(() {
          hoveredRoute = isHovering ? route : null;
        });
      },
    );
  }

}

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
            borderRadius: BorderRadius.zero,
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


class _HoverNavButtonWithIcon extends StatelessWidget {
  final String label;
  final String route;
  final bool isHovered;
  final Function(bool) onHoverChanged;

  const _HoverNavButtonWithIcon({
    required this.label,
    required this.route,
    required this.isHovered,
    required this.onHoverChanged,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isHovered ? const Color(0xFFAB86B9) : Colors.transparent;
    final textColor = isHovered ? Colors.white : const Color(0xFF6B4E45);

    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, route);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.zero,
          ),
          child: Row(
            children: [
              Image.asset('assets/lock.png', height: 18, width: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

