import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(

        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: isMobile
            ? SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/logon.png', height: 30),
              const SizedBox(width: 12),
              _navItems(context, isMobile),
              const SizedBox(width: 12),
              _socialIcons(isMobile),
            ],
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // أقصى اليمين: اللوجو
            Image.asset('assets/logon.png', height: 40),

            // الوسط: القوائم
            _navItems(context, isMobile),

            // أقصى اليسار: السوشيال
            _socialIcons(isMobile),
          ],
        ),
      ),
    );
  }

  /// عناصر القوائم
  Widget _navItems(BuildContext context, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _HoverNavItem(context, 'الشروط و الأحكام', '/TermsAndConditionsPage', isMobile),
        const SizedBox(width: 12),
        _HoverNavItem(context, 'الملكية الفكرية', '/PropertyPolicyPage', isMobile),
      ],
    );
  }

  /// أيقونات السوشيال
  Widget _socialIcons(bool isMobile) {
    return Row(
      children: [
        _HoverSocialIcon(
          'assets/icon_in.png',
          'https://www.linkedin.com/in/%D8%B4%D8%B7%D8%B1%D9%86%D8%AC-%D8%B4%D8%B7%D8%A7%D8%B1%D8%A9-shatara-chess-4a4833346/',
          isMobile,
        ),
        const SizedBox(width: 8),
        _HoverSocialIcon(
          'assets/icon_xx.png',
          'https://x.com/ShataraChess',
          isMobile,
        ),
        const SizedBox(width: 8),
        _HoverSocialIcon(
          'assets/icon_inst.png',
          'https://www.instagram.com/shatarachess/',
          isMobile,
        ),
        const SizedBox(width: 8),
        _HoverSocialIcon(
          'assets/icon_tic.png',
          'https://www.tiktok.com/@shatarachess',
          isMobile,
        ),
        const SizedBox(width: 8),
        _HoverSocialIcon(
          'assets/icon_fa.png',
          'https://www.facebook.com/profile.php?id=61573055570890',
          isMobile,
        ),
        const SizedBox(width: 3),
      ],
    );
  }
}

class _HoverNavItem extends StatefulWidget {
  final BuildContext context;
  final String label;
  final String route;
  final bool isMobile;

  const _HoverNavItem(this.context, this.label, this.route, this.isMobile);

  @override
  State<_HoverNavItem> createState() => _HoverNavItemState();
}

class _HoverNavItemState extends State<_HoverNavItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(widget.context, widget.route),
        child: Container(
          constraints: const BoxConstraints(minWidth: 25),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: widget.isMobile ? 8 : 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B4E45),
              decoration: _isHovering
                  ? TextDecoration.underline
                  : TextDecoration.none,
              decorationColor: const Color(0xFF6B4E45),
              decorationThickness: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _HoverSocialIcon extends StatefulWidget {
  final String assetPath;
  final String url;
  final bool isMobile;

  const _HoverSocialIcon(this.assetPath, this.url, this.isMobile);

  @override
  State<_HoverSocialIcon> createState() => _HoverSocialIconState();
}

class _HoverSocialIconState extends State<_HoverSocialIcon> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launchURL(widget.url),
        child: AnimatedOpacity(
          opacity: _isHovering ? 0.7 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Image.asset(
            widget.assetPath,
            height: widget.isMobile ? 20 : 24,
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
