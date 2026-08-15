import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomNewHome extends StatefulWidget {
  const CustomNewHome({super.key});

  @override
  State<CustomNewHome> createState() => _CustomNewHomeState();
}

class _CustomNewHomeState extends State<CustomNewHome> {
  String? hoveredRoute;

  static const _brandBrown = Color(0xFF6B4E45);
  static const _brandPurple = Color(0xFFAB86B9);

  static const String _guidePdfUrl = 'https://shatara.sa/shatraBooks.pdf';
  static const String _storeUrl = 'https://shatarachess.com/';
  static const String _nadiUrl =
      'https://hawi.gov.sa/club/club-details/hxsdFo0dsfyUZLqg2bY0ljSyu3yBXW3UvxMl3Jk3P466Por21Ldno4TUsJotNQHdQsw9PqBv40E';

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(
      uri,
      mode: LaunchMode.platformDefault,
      webOnlyWindowName: '_blank',
    );

    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذّر فتح الرابط')),
      );
    }
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
            ? _buildMobileMenuIcon(context)
            : Row(
                children: _buildNavItems(context),
              ),
      ),
    );
  }

  Widget _buildMobileMenuIcon(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, size: 26, color: _brandBrown),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ),
    );
  }

  List<Widget> _buildNavItems(BuildContext context) {
    const spacing = SizedBox(width: 20);

    return [
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, '/new_home'),
          child: Image.asset(
            'assets/logon.png',
            height: 40,
          ),
        ),
      ),
      spacing,
      _navExternalButton(
        label: 'متجر شطارة',
        id: 'store',
        icon: Icons.storefront_rounded,
        url: _storeUrl,
      ),
      spacing,
      _navExternalButton(
        label: 'نادي شطارة',
        id: 'nadi',
        icon: Icons.groups_rounded,
        url: _nadiUrl,
      ),
      spacing,
      _navExternalButton(
        label: 'دليل شطارة',
        id: 'guide',
        icon: Icons.menu_book_rounded,
        url: _guidePdfUrl,
      ),
      spacing,
      _HoverNavButton(
        label: 'خريطة الفتح',
        id: 'conquest',
        icon: Icons.map_rounded,
        isHovered: hoveredRoute == 'conquest',
        onHoverChanged: (h) =>
            setState(() => hoveredRoute = h ? 'conquest' : null),
        onTapOverride: () {
          Navigator.pushNamed(context, '/conquest');
        },
      ),
      spacing,
      const Spacer(),
      _HoverNavButton(
        label: 'تسجيل الدخول',
        id: 'login',
        icon: Icons.login_rounded,
        isHovered: hoveredRoute == 'login',
        onHoverChanged: (h) =>
            setState(() => hoveredRoute = h ? 'login' : null),
        onTapOverride: () {
          Navigator.pushNamed(context, '/login');
        },
      ),
    ];
  }

  Widget _navExternalButton({
    required String label,
    required String id,
    required IconData icon,
    required String url,
  }) {
    return _HoverNavButton(
      label: label,
      id: id,
      icon: icon,
      isHovered: hoveredRoute == id,
      onHoverChanged: (h) => setState(() => hoveredRoute = h ? id : null),
      onTapOverride: () => _openUrl(url),
    );
  }
}

class _HoverNavButton extends StatelessWidget {
  final String label;
  final String id;
  final IconData icon;
  final bool isHovered;
  final VoidCallback? onTapOverride;
  final ValueChanged<bool> onHoverChanged;

  const _HoverNavButton({
    super.key,
    required this.label,
    required this.id,
    required this.icon,
    required this.isHovered,
    required this.onHoverChanged,
    this.onTapOverride,
  });

  static const _brown = Color(0xFF6B4E45);
  static const _purple = Color(0xFFAB86B9);

  @override
  Widget build(BuildContext context) {
    final textColor = isHovered ? _brown : _purple;

    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTapOverride,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isHovered ? _purple : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: textColor,
              ),
              const SizedBox(width: 8),
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
