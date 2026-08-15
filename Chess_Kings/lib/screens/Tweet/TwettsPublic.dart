import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Widget/TweetsPage/TweetTile.dart';
import '../../Widget/TweetsProfilePage/CustomNavbarTweets.dart';
import '../../models/NotificationService.dart';
import '../../models/UserModel.dart';
import '../../models/tweet_model.dart';
import '../../services/logout_service.dart';
import 'profile_screen.dart'; // ✅ استيراد شاشة الملف الشخصي

class TweetsPublic extends StatefulWidget {
  const TweetsPublic({super.key});

  @override
  State<TweetsPublic> createState() => _TweetsPublicState();
}

class _TweetsPublicState extends State<TweetsPublic>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool isAnyDrawerHovering = false;

  Future<UserModel?>? _userFuture;
  bool isFollowing = false;
  UserModel? currentUser;

  int unreadNotifications = 0;
  int unreadMessages = 0;
  String searchQuery = '';

  bool get _isLoggedIn => FirebaseAuth.instance.currentUser != null;

  void _askLogin(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('الرجاء تسجيل الدخول للمتابعة')),
    );
  }

  /// تغليف أي ويدجت لمنع التفاعل إذا المستخدم ضيف
  Widget _wrapIfGuest(BuildContext context, Widget child) {
    if (_isLoggedIn) return child;
    return Stack(
      children: [
        AbsorbPointer(absorbing: true, child: child),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(onTap: () => _askLogin(context)),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userFuture = _loadCurrentUser(user.uid);
      _loadCounts(user.uid);
    } else {
      _userFuture = Future.value(null);
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadCounts(String uid) async {
    unreadNotifications =
    await NotificationService.getUnreadNotificationCount(uid);
    unreadMessages = await NotificationService.getUnreadMessagesCount(uid);
    if (mounted) setState(() {});
  }

  Future<UserModel?> _loadCurrentUser(String uid) async {
    final doc =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    currentUser = UserModel.fromMap(doc.data() as Map<String, dynamic>);
    return currentUser;
  }

  void _showUserListModal(
      BuildContext context, List<dynamic> userIds, String title) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: userIds.length,
                  itemBuilder: (context, index) {
                    final uid = userIds[index];
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return const SizedBox.shrink();
                        }
                        final data =
                        snapshot.data!.data() as Map<String, dynamic>;
                        final user = UserModel.fromMap(data);
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: user.profileImageUrl.isNotEmpty
                                ? NetworkImage(user.profileImageUrl)
                                : const AssetImage('assets/default_profile.png')
                            as ImageProvider,
                          ),
                          title: Text(user.name),
                          subtitle: Text('@${user.username}'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      ProfileScreen(userId: user.uid)),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// ✅ رأس الصورة: في الديسكتوب تكون أعلى الصفحة وبالمنتصف، وفي الجوال أعلى المحتوى
  /// ✅ رأس الصورة: في الديسكتوب تكون أعلى الصفحة وبالمنتصف،
  /// وفي الجوال أعلى المحتوى ومعها شريط أحمر تحذيري
  Widget _buildTopHeroImage({required bool isMobile}) {
    if (isMobile) {
      // 📱 تصميم الجوال
      return Column(
        children: [
          const SizedBox(height: 8),
          Center(
            child: Image.asset(
              'assets/test.png',
              width: 140,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            color: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: const Text(
              'في الوقت الحالي شطارة تعمل بشكل أفضل على الكمبيوتر',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      );
    } else {
      // 💻 تصميم الكمبيوتر
      return Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 16),
        child: Align(
          alignment: Alignment.topCenter,
          child: Image.asset(
            'assets/test.png',
            width: 320,
            fit: BoxFit.contain,
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return FutureBuilder<UserModel?>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          debugPrint('TweetsPublic error: ${snapshot.error}');
        }

        return Scaffold(
          backgroundColor: const Color(0xFFDDDDDC),
          endDrawer: isMobile ? _buildDrawer(context) : null,
          body: Stack(
            children: [
              // خلفية الصفحة
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/back_tweets.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    // شريط علوي
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: isMobile
                          ? Align(
                        alignment: Alignment.topRight,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu,
                                color: Color(0xFF6B4E45)),
                            onPressed: () =>
                                Scaffold.of(context).openEndDrawer(),
                          ),
                        ),
                      )
                          : const CustomNavbarTweets(),
                    ),

                    const SizedBox(height: 8),

                    // ✅ الصورة أعلى الصفحة:
                    // - تظهر دائمًا، لكن بحجم وتموضع يناسب الجهاز
                    _buildTopHeroImage(isMobile: isMobile),

                    Expanded(
                      child: isMobile
                          ? SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('tweets')
                                  .where('type', isEqualTo: 'tweet')
                                  .orderBy('timestamp', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child:
                                      CircularProgressIndicator());
                                }
                                if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return const Center(
                                      child: Text('لا توجد مشاركات.'));
                                }
                                final tweets = snapshot.data!.docs
                                    .map((doc) {
                                  return TweetModel.fromMap(
                                      doc.data()
                                      as Map<String, dynamic>,
                                      id: doc.id);
                                }).where((tweet) {
                                  final text =
                                  tweet.text.toLowerCase();
                                  final query =
                                  searchQuery.toLowerCase();
                                  return query.isEmpty ||
                                      text.contains(query) ||
                                      text.contains('#$query');
                                }).toList();

                                final listView = ListView.builder(
                                  shrinkWrap: true,
                                  physics:
                                  const NeverScrollableScrollPhysics(),
                                  itemCount: tweets.length,
                                  itemBuilder: (context, index) {
                                    return TweetTile(
                                        tweet: tweets[index]);
                                  },
                                );
                                return _wrapIfGuest(context, listView);
                              },
                            ),
                          ],
                        ),
                      )
                          : Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(height: 8),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('tweets')
                                        .where('type',
                                        isEqualTo: 'tweet')
                                        .orderBy('timestamp',
                                        descending: true)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child:
                                            CircularProgressIndicator());
                                      }
                                      if (!snapshot.hasData ||
                                          snapshot.data!.docs.isEmpty) {
                                        return const Center(
                                            child: Text(
                                                'لا توجد مشاركات.'));
                                      }
                                      final tweets = snapshot.data!.docs
                                          .map((doc) {
                                        return TweetModel.fromMap(
                                            doc.data() as Map<String,
                                                dynamic>,
                                            id: doc.id);
                                      }).where((tweet) {
                                        final text =
                                        tweet.text.toLowerCase();
                                        final query = searchQuery
                                            .toLowerCase();
                                        return query.isEmpty ||
                                            text.contains(query) ||
                                            text.contains('#$query');
                                      }).toList();

                                      final listView = ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                        const NeverScrollableScrollPhysics(),
                                        itemCount: tweets.length,
                                        itemBuilder: (context, index) {
                                          return TweetTile(
                                              tweet: tweets[index]);
                                        },
                                      );
                                      return _wrapIfGuest(
                                          context, listView);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        final isLoggedIn = FirebaseAuth.instance.currentUser != null;
        return ClipRRect(
          borderRadius: BorderRadius.zero,
          child: Drawer(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero),
            backgroundColor: const Color(0xFFDDDDDC),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView(
                padding:
                const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                children: [
                  Image.asset('assets/logon.png', height: 60),
                  const Divider(),
                  _HoverDrawerItem(
                      label: 'تعرف على شطاره',
                      route: '/main',
                      isAnyHovering: isAnyDrawerHovering,
                      onHoverChanged: (h) =>
                          setState(() => isAnyDrawerHovering = h)),
                  _HoverDrawerItem(
                      label: 'من نحن',
                      route: '/about',
                      isAnyHovering: isAnyDrawerHovering,
                      onHoverChanged: (h) =>
                          setState(() => isAnyDrawerHovering = h)),
                  _HoverDrawerItem(
                      label: 'الاسئلة الشائعة',
                      route: '/faq',
                      isAnyHovering: isAnyDrawerHovering,
                      onHoverChanged: (h) =>
                          setState(() => isAnyDrawerHovering = h)),
                  _HoverDrawerItem(
                      label: 'ألعب الأن',
                      route: '/playNow',
                      isAnyHovering: isAnyDrawerHovering,
                      onHoverChanged: (h) =>
                          setState(() => isAnyDrawerHovering = h)),
                  isLoggedIn
                      ? _HoverDrawerItem(
                    label: 'تسجيل الخروج',
                    route: '/homeس',
                    isAlwaysActive: true,
                    onTapOverride: () async {
                      await LogoutService.signOut(context,
                          redirectRoute: '/main');
                    },
                  )
                      : _HoverDrawerItem(
                      label: 'تسجيل الدخول',
                      route: '/login',
                      isAlwaysActive: true),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ✅ يمكنك الحفاظ على كلاس _HoverDrawerItem كما هو
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
