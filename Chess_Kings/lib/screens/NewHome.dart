import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// الوقت البشري
import 'package:timeago/timeago.dart' as timeago;

import '../Widget/HomePage/ShataraCommunityWidget.dart';
import '../Widget/NewHome/CustomNewHome.dart';
import '../Widget/NewHome/FooterNewHome.dart';
import '../Widget/NewHome/ShataraJoinGuideWidget.dart';
import '../Widget/NewHome/ShataraStoreWidget.dart';

// فيديو
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

import '../Widget/NewHome/ShataraVideoTextWidget.dart';
import 'package:url_launcher/url_launcher.dart';

/// ✅ تأكدي من إضافة الخلفية في pubspec.yaml:
/// flutter:
///   assets:
///     - assets/back_home.png

/// --------------------------
/// تتبع زيارة مرّة واحدة لكل جلسة
/// --------------------------
class VisitorTracker {
  static bool _visited = false;

  static Future<void> registerOncePerSession() async {
    if (_visited) return;
    _visited = true;

    try {
      await FirebaseFirestore.instance.collection('visitors').add({
        'at': FieldValue.serverTimestamp(),
        'platform': kIsWeb ? 'web' : 'mobile',
        'uid': FirebaseAuth.instance.currentUser?.uid,
        'source': 'home',
      });
    } catch (e) {
      // ignore: avoid_print
      print('Visitor log failed: $e');
    }
  }
}

class NewHome extends StatefulWidget {
  const NewHome({super.key});

  @override
  State<NewHome> createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool isAnyDrawerHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _setupPresence();
    _initTimeagoArabic();
    VisitorTracker.registerOncePerSession();
  }

  void _initTimeagoArabic() {
    timeago.setLocaleMessages('ar', timeago.ArMessages());
  }

  Future<void> _setupPresence() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final db = FirebaseDatabase.instance;
    final statusRef = db.ref('status/${user.uid}');
    final connectedRef = db.ref('.info/connected');

    final isOnline = {
      'state': 'online',
      'last_changed': ServerValue.timestamp,
    };
    final isOffline = {
      'state': 'offline',
      'last_changed': ServerValue.timestamp,
    };

    connectedRef.onValue.listen((event) async {
      final connected = event.snapshot.value == true;
      if (!connected) return;
      await statusRef.onDisconnect().set(isOffline);
      await statusRef.set(isOnline);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      // ✅ مهم: يخلي الخلفية تظهر خلف الـ AppBar
      extendBodyBehindAppBar: true,

      // ✅ Drawer للجوال
      endDrawer: isMobile ? _buildDrawer(context) : null,
      endDrawerEnableOpenDragGesture: true,

      // ✅ AppBar شفاف يحتوي CustomNavbar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            bottom: false,
            child: const CustomNewHome(),
          ),
        ),
      ),

      // ✅ الخلفية + المحتوى فوقها
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backhome.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 🔴 تنبيه الجوال
                  if (isMobile)
                    Container(
                      width: double.infinity,
                      color: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      child: const Text(
                        'في الوقت الحالي شطارة تعمل بشكل أفضل على الكمبيوتر',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Alexandria',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ShataraVideoTextWidget(),

                  const SizedBox(height: 25),

                  // ===============================
                  // المتجر
                  // ===============================
                  ShataraStoreWidget(),
                  const SizedBox(height: 15),
                  ShataraJoinGuideWidget(),
                  FooterNewHome(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    return Drawer(
      backgroundColor: const Color(0xFFDDDDDC),

      // ✅ حواف حادة (كما عندك)
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.zero,
          bottomLeft: Radius.zero,
        ),
      ),

      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/new_home');
              },
              child: Image.asset(
                'assets/logon.png',
                height: 60,
              ),
            ),
            const Divider(),
            _HoverDrawerItem(
              label: 'متجر شطارة',
              route: '/noop',
              onTapOverride: () => _openUrl(_storeUrl),
            ),
            _HoverDrawerItem(
              label: 'نادي شطارة',
              route: '/noop',
              onTapOverride: () => _openUrl(_nadiUrl),
            ),
            _HoverDrawerItem(
              label: 'دليل شطارة',
              route: '/noop',
              onTapOverride: () => _openUrl(_guidePdfUrl),
            ),
            _HoverDrawerItem(
              label: 'خريطة الفتح',
              route: '/conquest',
            ),
            isLoggedIn
                ? _HoverDrawerItem(
                    label: 'تسجيل الخروج',
                    route: '/home',
                    isAlwaysActive: true,
                    onTapOverride: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/main');
                      }
                    },
                  )
                : _HoverDrawerItem(
                    label: 'تسجيل الدخول',
                    route: '/login',
                    isAlwaysActive: true,
                  ),
          ],
        ),
      ),
    );
  }

  static const String _storeUrl = 'https://shatarachess.com/';
  static const String _guidePdfUrl = 'https://shatara.sa/shatraBooks.pdf';
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
}

class _HoverDrawerItem extends StatefulWidget {
  final String label;
  final String route;
  final bool isSpecialActive;
  final bool isAlwaysActive;
  final VoidCallback? onTapOverride;

  const _HoverDrawerItem({
    required this.label,
    required this.route,
    this.isSpecialActive = false,
    this.isAlwaysActive = false,
    this.onTapOverride,
  });

  @override
  State<_HoverDrawerItem> createState() => _HoverDrawerItemState();
}

class _HoverDrawerItemState extends State<_HoverDrawerItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.transparent;
    Color text = const Color(0xFF6B4E45);

    if (widget.isAlwaysActive) {
      bg = const Color(0xFFAB86B9);
      text = Colors.white;
    } else if (_isHovering) {
      bg = const Color(0xFFAB86B9);
      text = Colors.white;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () {
          if (widget.onTapOverride != null) {
            widget.onTapOverride!();
          } else {
            Navigator.pushNamed(context, widget.route);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.zero,
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 15,
              color: text,
            ),
          ),
        ),
      ),
    );
  }
}
