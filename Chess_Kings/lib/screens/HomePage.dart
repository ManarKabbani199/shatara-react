import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../Widget/HomePage/CustomNavbar.dart';
import '../Widget/HomePage/LiveGuestImages.dart';
import '../Widget/HomePage/ShataraCommunityWidget.dart';
import '../Widget/HomePage/ShataraTopListWidget.dart';
import '../Widget/HomePage/StatsSection.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// أرقام الهاتف
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

// الوقت البشري
import 'package:timeago/timeago.dart' as timeago;

import '../Widget/ShataraFooter.dart';
import 'GamePLay/ChessBoard.dart';

// فيديو
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

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
      print('Visitor log failed: $e');
    }
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
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

  Stream<int> _onlineCountStream() {
    final ref = FirebaseDatabase.instance.ref('status');
    return ref.onValue.map((e) {
      final data = e.snapshot.value;
      if (data == null) return 0;
      final map = Map<String, dynamic>.from(data as Map);
      int count = 0;
      map.forEach((_, v) {
        final m = Map<String, dynamic>.from(v as Map);
        if (m['state'] == 'online') count++;
      });
      return count;
    });
  }

  Stream<int> _countryCountStream() {
    final usersRef = FirebaseFirestore.instance.collection('users');
    return usersRef.snapshots().map((snap) {
      final Set<IsoCode> uniqueIsoCodes = {};
      for (final doc in snap.docs) {
        final data = doc.data();
        final phone = data['phone_number'];
        if (phone is! String) continue;
        final raw = phone.trim();
        if (raw.isEmpty) continue;
        try {
          final parsed = PhoneNumber.parse(raw);
          final iso = parsed.isoCode;
          if (iso != null) uniqueIsoCodes.add(iso);
        } catch (_) {}
      }
      return uniqueIsoCodes.length;
    });
  }

  Stream<int> _visitorCountStream() {
    return FirebaseFirestore.instance
        .collection('visitors')
        .snapshots()
        .map((snap) => snap.size);
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
            child: const CustomNavbar(),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 🔴 تنبيه الجوال
              if (isMobile)
                Container(
                  width: double.infinity,
                  color: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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

              // ===============================
              // Hero Section
              // ===============================
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/aan.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: isMobile ? 5 : 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isMobile)
                          Image.asset(
                            'assets/saoud.png',
                            width: 195,
                            fit: BoxFit.contain,
                          ),
                        if (!isMobile) const SizedBox(height: 15),
                        SelectableText(
                          'المعركة بدأت، وجيشك بانتظار أوامرك',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: isMobile ? 15 : 21,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF6B4E45),
                          ),
                        ),
                        const SizedBox(height: 7),
                        SelectableText(
                          'اختبر شطارتك في أقوى تجربة شطرنج عالمية',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: isMobile ? 11 : 17,
                            color: const Color(0xFF6B4E45),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SelectableText(
                          'ومجتمع متكامل للتواصل معه',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: isMobile ? 11 : 17,
                            color: const Color(0xFF6B4E45),
                          ),
                        ),
                        const SizedBox(height: 25),
                        // ✅ خياران رئيسيان: لعب سريع أو خريطة الفتح
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChessBoard()),
                                ),
                                icon: const Icon(Icons.sports_kabaddi,
                                    color: Colors.white),
                                label: const Text(
                                  'العب الآن',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6B4E45),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/conquest'),
                                icon:
                                    const Icon(Icons.map, color: Colors.white),
                                label: const Text(
                                  'خريطة الفتح',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFAB86B9),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),
              Image.asset('assets/imsh.png'),

              // ===============================
              // الإحصائيات
              // ===============================
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: StreamBuilder<int>(
                  stream: _onlineCountStream(),
                  builder: (context, onlineSnap) {
                    final online = (onlineSnap.data ?? 0).toString();
                    return StreamBuilder<int>(
                      stream: _countryCountStream(),
                      builder: (context, countrySnap) {
                        final countries = (countrySnap.data ?? 0).toString();
                        return StreamBuilder<int>(
                          stream: _visitorCountStream(),
                          builder: (context, visitorSnap) {
                            final visitor = (visitorSnap.data ?? 0).toString();
                            return StatsSection(
                              soldGames: "0",
                              onlineUsers: online,
                              countries: countries,
                              visitor: visitor,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 45),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ResponsiveTopSection(
                  card1: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .orderBy('wins', descending: true)
                        .limit(6)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const ShataraTopListWidget(entries: [
                          RankEntry(
                              avatar: 'assets/ooo.png',
                              name: '—',
                              handle: 'wins 0',
                              iso2: 'SA'),
                          RankEntry(
                              avatar: 'assets/ttt.png',
                              name: '—',
                              handle: 'wins 0',
                              iso2: 'SA'),
                        ]);
                      }

                      final docs = snapshot.data!.docs;
                      final entries = <RankEntry>[];
                      const defaults = [
                        'assets/ooo.png',
                        'assets/ttt.png',
                        'assets/hhh.png',
                        'assets/fff.png',
                        'assets/iiii.png',
                        'assets/sss.png',
                      ];

                      for (var i = 0; i < docs.length; i++) {
                        final data = docs[i].data() as Map<String, dynamic>;
                        final name = (data['username'] ?? data['name'] ?? '')
                            .toString()
                            .trim();
                        final displayName = name.isNotEmpty ? name : 'مجهول';
                        final winsRaw = data['wins'];
                        final wins = winsRaw is num
                            ? winsRaw.toInt()
                            : int.tryParse(winsRaw?.toString() ?? '0') ?? 0;
                        final handle = 'wins $wins';
                        final phone = data['phone_number']?.toString();
                        final iso2 = iso2FromPhone(phone);
                        final avatar =
                            i < defaults.length ? defaults[i] : defaults.last;

                        entries.add(RankEntry(
                          avatar: avatar,
                          name: displayName,
                          handle: handle,
                          iso2: iso2,
                        ));
                      }
                      return ShataraTopListWidget(entries: entries);
                    },
                  ),
                  card2: LiveGuestImages(),
                  mobileHeight1: 460,
                  desktopHeight1: 475,
                  desktopHeight2: 475,
                ),
              ),

              const SizedBox(height: 55),
              ShataraFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    return Drawer(
      backgroundColor: const Color(0xFFDDDDDC),

      // ✅ حواف مستديرة
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
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Image.asset(
                'assets/logon.png',
                height: 60,
              ),
            ),
            const Divider(),
            _HoverDrawerItem(
              label: 'تعرف على شطاره',
              isSpecialActive: true,
              route: '/main',
            ),
            _HoverDrawerItem(label: 'من نحن', route: '/about'),
            _HoverDrawerItem(label: 'الاسئلة الشائعة', route: '/faq'),
            _HoverDrawerItem(label: 'ألعب الأن', route: '/playNow'),
            _HoverDrawerItem(label: 'خريطة الفتح', route: '/conquest'),
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

  String iso2FromPhone(String? phone) {
    if (phone == null) return 'SA';
    final p = phone.trim();
    if (p.isEmpty) return 'SA';

    final digits = p.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return 'SA';

    const codeToIso2 = {
      '966': 'SA',
      '965': 'KW',
      '971': 'AE',
      '973': 'BH',
      '974': 'QA',
      '968': 'OM',
      '962': 'JO',
      '961': 'LB',
      '963': 'SY',
      '964': 'IQ',
      '970': 'PS',
      '967': 'YE',
      '20': 'EG',
      '212': 'MA',
      '213': 'DZ',
      '216': 'TN',
      '218': 'LY',
      '249': 'SD',
    };

    for (final len in [3, 2]) {
      if (digits.length >= len) {
        final key = digits.substring(0, len);
        final iso = codeToIso2[key];
        if (iso != null) return iso;
      }
    }
    return 'SA';
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

/// --------------------------
/// ويدجت: آخر تغريدة لواجهة شطارة
/// --------------------------
class LatestTweetForShatara extends StatelessWidget {
  const LatestTweetForShatara({super.key});

  String _formatLikes(num n) {
    if (n >= 1000000000) return '${(n / 1000000000).toStringAsFixed(1)}B';
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tweets')
          // .where('type', isEqualTo: 'tweet') // فعّلها إذا عندك هذا الحقل
          .orderBy('timestamp', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return const ShataraCommunityWidget(
            coverImagePath: 'assets/RectangleAbout.png',
            headline: 'لا توجد تغريدات حالياً',
            timeAgo: '',
            likes: '0',
            memberTop: ShataraMember(
                avatarPath: 'assets/iconrrrr.png',
                name: 'Nour',
                handle: '@nour_off'),
            memberBottom: ShataraMember(
                avatarPath: 'assets/iconrrrr.png',
                name: 'Maha',
                handle: '@maha_dev'),
          );
        }

        final doc = snap.data!.docs.first;
        final data = doc.data() as Map<String, dynamic>;

        final String text = (data['text'] ?? '') as String;

        DateTime? timestamp;
        final ts = data['timestamp'];
        if (ts is Timestamp) {
          timestamp = ts.toDate();
        } else if (ts is DateTime) {
          timestamp = ts;
        }

        // عدد الإعجابات: قد يكون قائمة أو رقم
        int likesCount = 0;
        final likesField = data['likes'];
        if (likesField is List) {
          likesCount = likesField.length;
        } else if (likesField is int) {
          likesCount = likesField;
        } else if (likesField is num) {
          likesCount = likesField.toInt();
        }

        final String timeAgoStr =
            (timestamp != null) ? timeago.format(timestamp, locale: 'ar') : '';

        // الصورة: إن وجدت نستخدمها، وإلا الافتراضية
        String coverImagePath = 'assets/RectangleAbout.png';
        final String? imageUrl = (data['imageUrl'] as String?)?.trim();
        if (imageUrl != null && imageUrl.isNotEmpty) {
          coverImagePath = imageUrl;
        }

        return ShataraCommunityWidget(
          coverImagePath: coverImagePath,
          headline: text.isEmpty ? '...' : text,
          timeAgo: timeAgoStr,
          likes: _formatLikes(likesCount),
          memberTop: const ShataraMember(
              avatarPath: 'assets/iconrrrr.png',
              name: 'Nour',
              handle: '@nour_off'),
          memberBottom: const ShataraMember(
              avatarPath: 'assets/iconrrrr.png',
              name: 'Maha',
              handle: '@maha_dev'),
        );
      },
    );
  }
}

class LatestTwoMembersCard extends StatefulWidget {
  final String coverImagePath;
  final String headline;
  final String timeAgo;
  final String likes;
  final String? videoUrl;

  const LatestTwoMembersCard({
    super.key,
    required this.coverImagePath,
    required this.headline,
    required this.timeAgo,
    required this.likes,
    this.videoUrl,
  });

  @override
  State<LatestTwoMembersCard> createState() => _LatestTwoMembersCardState();
}

class _LatestTwoMembersCardState extends State<LatestTwoMembersCard> {
  static const String _fallbackAsset = 'assets/iconrrrr.png';

  ShataraMember _toMember(Map<String, dynamic>? d) {
    final data = d ?? {};
    final name = (data['name'] as String?)?.trim().isNotEmpty == true
        ? data['name'] as String
        : 'مستخدم جديد';
    final login = (data['username'] as String?)?.trim().isNotEmpty == true
        ? data['username'] as String
        : 'user';
    final handle = '$login@';
    final banner = (data['bannerImageUrl'] ?? '').toString();
    final avatarPath = banner.isNotEmpty ? banner : _fallbackAsset;
    return ShataraMember(avatarPath: avatarPath, name: name, handle: handle);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .orderBy('createdAt', descending: true)
          .limit(2)
          .snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? [];

        // ✅ تحويل آمن إلى Map<String,dynamic>
        final Map<String, dynamic> d0 = docs.isNotEmpty
            ? Map<String, dynamic>.from(docs[0].data() as Map)
            : <String, dynamic>{};
        final Map<String, dynamic> d1 = docs.length > 1
            ? Map<String, dynamic>.from(docs[1].data() as Map)
            : <String, dynamic>{};

        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ✅ الميديا بحجم ثابت
              SizedBox(
                height: 220,
                width: double.infinity,
                child: _buildMedia(),
              ),

              // ✅ المحتوى
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SelectableText(
                      'أكثر مشاركة تفاعلاَ',
                      style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Alexandria',
                          color: Color(0xFF6B4E45)),
                      textAlign: TextAlign.right,
                    ),
                    SelectableText(
                      widget.headline,
                      maxLines: 3,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'Alexandria',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.timeAgo,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12)),
                        Row(
                          children: [
                            const Icon(Icons.favorite,
                                size: 14, color: Colors.red),
                            const SizedBox(width: 4),
                            Text(widget.likes),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ✅ الأعضاء (من واجهتك)
              ShataraCommunityWidget(
                coverImagePath: widget.coverImagePath.isEmpty
                    ? 'assets/RectangleAbout.png'
                    : widget.coverImagePath,
                headline: widget.headline,
                timeAgo: widget.timeAgo,
                likes: widget.likes,
                memberTop: _toMember(d0),
                memberBottom: _toMember(d1),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMedia() {
    if (widget.videoUrl != null && widget.videoUrl!.trim().isNotEmpty) {
      // ✅ ويدجت فيديو داخلي ثابت الارتفاع
      return _VideoBox(url: widget.videoUrl!, height: 220);
    }

    final src = widget.coverImagePath.trim();
    if (src.startsWith('http')) {
      return Image.network(src, fit: BoxFit.cover);
    } else {
      return Image.asset(
        src.isEmpty ? 'assets/RectangleAbout.png' : src,
        fit: BoxFit.cover,
      );
    }
  }
}

/// ويدجت فيديو داخلي لمنع الـ overflow وإعطاء عرض/ارتفاع مناسبين
class _VideoBox extends StatefulWidget {
  final String url;
  final double height;
  const _VideoBox({required this.url, this.height = 220});

  @override
  State<_VideoBox> createState() => _VideoBoxState();
}

class _VideoBoxState extends State<_VideoBox> {
  VideoPlayerController? _vc;
  ChewieController? _cc;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      _vc = VideoPlayerController.networkUrl(Uri.parse(widget.url));
      await _vc!.initialize();
      _cc = ChewieController(
        videoPlayerController: _vc!,
        autoPlay: false,
        looping: true,
        allowFullScreen: true,
        allowMuting: true,
      );
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted) setState(() => _error = true);
    }
  }

  @override
  void dispose() {
    _cc?.dispose();
    _vc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: _error
          ? const Center(child: Icon(Icons.error_outline))
          : (_cc != null && _vc!.value.isInitialized)
              ? FittedBox(
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    width: _vc!.value.size.width == 0
                        ? 400
                        : _vc!.value.size.width,
                    height: _vc!.value.size.height == 0
                        ? 225
                        : _vc!.value.size.height,
                    child: Chewie(controller: _cc!),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}

// (اختياري) ويدجت قائمة آخر 5 مستخدمين – أبقيته كما هو لمن يحتاجه في أماكن أخرى
class LatestUsersWidget extends StatelessWidget {
  const LatestUsersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .orderBy('createdAt', descending: true) // 🔥 الأحدث أولاً
          .limit(5) // كم مستخدم تريد تعرضه
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text("لا يوجد مستخدمين مسجلين بعد");
        }

        final users = snapshot.data!.docs;

        return Column(
          children: users.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            final avatar = (data['bannerImageUrl'] != null &&
                    data['bannerImageUrl'].toString().isNotEmpty)
                ? data['bannerImageUrl']
                : 'assets/iconrrrr.png'; // 🔥 صورة افتراضية

            final name = data['name'] ?? "مستخدم جديد";
            final username = data['username'] ?? "user";
            final handle = "@$username";

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: avatar.toString().startsWith('http')
                    ? NetworkImage(avatar)
                    : AssetImage(avatar) as ImageProvider,
              ),
              title: Text(name),
              subtitle: Text(handle),
            );
          }).toList(),
        );
      },
    );
  }
}

/// ==============================

/// ==============================
/// ✅ كاردين ريسبونسف + تحديد ارتفاع للجوال والكمبيوتر
/// ==============================
class ResponsiveTopSection extends StatelessWidget {
  const ResponsiveTopSection({
    super.key,
    required this.card1,
    required this.card2,
    this.desktopHeight1,
    this.desktopHeight2,
    this.mobileHeight1,
    this.mobileHeight2,
    this.breakpoint = 900,
  });

  final Widget card1;
  final Widget card2;

  // ارتفاعات اختيارية
  final double? desktopHeight1;
  final double? desktopHeight2;
  final double? mobileHeight1;
  final double? mobileHeight2;

  // متى نتحول لصفّين بجانب بعض
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w >= breakpoint;

    // ارتفاعات افتراضية معقولة
    final double dh = (w >= 1400 ? 700 : (w >= 1100 ? 640 : 560));
    final double mh =
        420; // 👈 افتراضي للجوال يمنع اختفاء البطاقة (خاصة الثانية)

    const gap = 16.0;

    Widget _wrap(Widget child, double? h) {
      // إن تم تمرير ارتفاع نلفّه بـ SizedBox، وإلا نتركه طبيعي
      return (h != null)
          ? SizedBox(height: h, child: _CardShell(child: child))
          : _CardShell(child: child);
    }

    if (isWide) {
      // 💻 كمبيوتر: بجانب بعض وبنفس ارتفاعات الديسكتوب
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _wrap(card1, desktopHeight1 ?? dh)),
          const SizedBox(width: gap),
          Expanded(child: _wrap(card2, desktopHeight2 ?? dh)),
        ],
      );
    }

    // 📱 جوال: تحت بعض — مع ارتفاعات للجوال (خاصة الثانية)
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _wrap(card1, mobileHeight1), // اتركها طبيعيًا أو حدّد ارتفاعًا
        const SizedBox(height: gap),
        _wrap(card2, mobileHeight2 ?? mh), // 👈 نعطي ارتفاعًا افتراضيًا 420
      ],
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white, // لو بطاقاتك فيها خلفية خاصّة احذف هذا اللون
        borderRadius: BorderRadius.circular(8),
      ),
      child: child, // لا تستخدم SizedBox.expand داخل البطاقة
    );
  }
}
