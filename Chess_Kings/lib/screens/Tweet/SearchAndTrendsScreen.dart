import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Widget/TweetsPage/TweetTile.dart';
import '../../models/tweet_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Widget/TweetsProfilePage/CustomNavbarTweets.dart';
import '../../Widget/TweetsProfilePage/CustomSidebar.dart';
import '../../Widget/TweetsProfilePage/CustomWidget.dart';
import '../../Widget/TweetsProfilePage/ProfileMySelfWidget.dart';
import '../../models/NotificationService.dart';
import '../../models/UserModel.dart';
import '../../services/logout_service.dart';
import 'profile_screen.dart';
import '../../shared_data.dart' as shared;

class SearchAndTrendsScreen extends StatefulWidget {
  @override
  _SearchAndTrendsScreenState createState() => _SearchAndTrendsScreenState();
}

class _SearchAndTrendsScreenState extends State<SearchAndTrendsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool isAnyDrawerHovering = false;
  late Future<UserModel> _userFuture;

  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  bool isFollowing = false;
  UserModel? currentUser;

  int unreadNotifications = 0;
  int unreadMessages = 0;

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<TweetModel> searchResults = [];
  Map<String, int> trends = {};

  @override
  void initState() {
    super.initState();

    _loadCounts();
    _userFuture = _fetchUser();
    _loadCurrentUser();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.15).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));

    _getTrends();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getTrends() async {
    final snapshot = await FirebaseFirestore.instance.collection('tweets').get();

    final Map<String, int> wordCount = {};
    for (final doc in snapshot.docs) {
      final data = doc.data();
      if (data.containsKey('text')) {
        final words = data['text'].toString().split(RegExp(r'\s+'));
        for (final word in words) {
          if (word.startsWith('#')) {
            wordCount[word] = (wordCount[word] ?? 0) + 1;
          }
        }
      }
    }
    setState(() {
      trends = wordCount;
    });
  }

  Future<void> _loadCounts() async {
    unreadNotifications =
    await NotificationService.getUnreadNotificationCount(currentUserId);
    unreadMessages =
    await NotificationService.getUnreadMessagesCount(currentUserId);
    setState(() {});
  }

  Future<void> _loadCurrentUser() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();
    if (doc.data() != null) {
      currentUser = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      setState(() {});
    }
  }

  Future<UserModel> _fetchUser() async {
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(shared.id_user)
        .get();

    if (!doc.exists) throw Exception('المستخدم غير موجود');

    final UserModel user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
    isFollowing = user.followers.contains(currentUserId);
    return user;
  }

  void _showUserListModal(
      BuildContext context, List<dynamic> userIds, String title) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) => Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
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

  void _searchTweets() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('tweets').get();

    final results = snapshot.docs
        .map((doc) =>
        TweetModel.fromMap(doc.data() as Map<String, dynamic>, id: doc.id))
        .where((tweet) =>
        tweet.text.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    setState(() {
      searchResults = results;
    });
  }

  /// لوحة البحث والترند (بدون Scaffold داخلي)
  Widget _searchTrendsPanel() {
    final sortedTrends = trends.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.zero,
          ),
          child: TextField(
            controller: _searchController,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              hintText: 'ابحث عن كلمة أو هاشتاق...',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  _searchQuery = _searchController.text.trim();
                  _searchTweets();
                },
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
            ),
            onSubmitted: (_) {
              _searchQuery = _searchController.text.trim();
              _searchTweets();
            },
          ),
        ),
        const SizedBox(height: 16),

        // نتائج البحث
        if (searchResults.isNotEmpty)
          ...searchResults.map((tweet) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TweetTile(tweet: tweet),
          )),

        // الترند عند عدم وجود استعلام
        if (_searchQuery.isEmpty) ...[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.zero,
            ),
            padding: const EdgeInsets.all(12),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'المواضيع الشائعة',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: 'Alexandria',
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),

                  if (sortedTrends.isEmpty)
                    const Text(
                      'لا يوجد ترند حتى الآن',
                      textAlign: TextAlign.right,
                    ),

                  ...sortedTrends.take(10).map(
                        (entry) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading:
                      const Icon(Icons.trending_up, color: Colors.deepPurple),
                      title: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          entry.key,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Alexandria',
                          ),
                        ),
                      ),
                      trailing: Text(
                        '${entry.value}',
                        style: const TextStyle(
                          fontSize: 9,
                          fontFamily: 'Alexandria',
                        ),
                      ),
                      onTap: () {
                        _searchController.text = entry.key;
                        _searchQuery = entry.key;
                        _searchTweets();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// صورة أعلى الصفحة للعرض على الكمبيوتر (متمركزة أفقياً)
  Widget _desktopTopImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Center(
        child: Image.asset(
          'assets/test.png',
          height: 120,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  /// صورة + شريط تنبيه أحمر للجوال
  Widget _mobileTopNotice() {
    return Column(
      children: [
        // الصورة في الأعلى
        Center(
          child: Image.asset(
            'assets/test.png',
            height: 100,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 8),
        // شريط أحمر عريض بالنص المطلوب
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          color: Colors.red,
          child: const Text(
            'في الوقت الحالي شطارة تعمل بشكل أفضل على الكمبيوتر',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Alexandria',
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return FutureBuilder<UserModel>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('خطأ: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('لم يتم العثور على المستخدم'));
        }

        final user = snapshot.data!;
        final bool isMyProfile = shared.id_user == currentUserId;

        return Scaffold(
          backgroundColor: const Color(0xFFDDDDDC),
          endDrawer: isMobile ? _buildDrawer(context) : null,
          body: Stack(
            children: [
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
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

                    // ✅ الصورة أعلى الصفحة:
                    if (!isMobile) _desktopTopImage(),

                    const SizedBox(height: 10),

                    Expanded(
                      child: isMobile
                          ? SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Column(
                          children: [
                            // ✅ للجوال: الصورة + الشريط الأحمر
                            _mobileTopNotice(),

                            const SizedBox(height: 15),
                            CustomWidget(
                              level: user.level,
                              loginCount: user.login,
                              vsComputerCount: user.play_computer,
                              winCount: user.wins,
                            ),
                            const SizedBox(height: 15),
                            _searchTrendsPanel(),
                            const SizedBox(height: 15),
                            ProfileMySelfWidget(
                              userName: user.name,
                              userTitle: '@${user.username}',
                              imagePath: user.profileImageUrl.isNotEmpty
                                  ? NetworkImage(user.profileImageUrl)
                                  : const AssetImage(
                                  'assets/default_profile.png'),
                              followersCount:
                              user.followers.length.toString(),
                              followingCount:
                              user.following.length.toString(),
                              aboutMe: user.bio.isNotEmpty
                                  ? user.bio
                                  : 'لا توجد نبذة حتى الآن',
                              statLeft: user.following.length.toString(),
                              statRight: user.followers.length.toString(),
                              followersList: user.followers,
                              followingList: user.following,
                              onShowUserList: _showUserListModal,
                            ),
                            const SizedBox(height: 15),
                            currentUser == null
                                ? const SizedBox.shrink()
                                : CustomSidebar(
                              isInDrawer: false,
                              user: currentUser!,
                              currentUserId: currentUserId,
                              unreadMessages: unreadMessages,
                              unreadNotifications:
                              unreadNotifications,
                            ),
                          ],
                        ),
                      )
                          : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Column(
                                children: [
                                  const SizedBox(height: 15),
                                  CustomWidget(
                                    level: user.level,
                                    loginCount: user.login,
                                    vsComputerCount: user.play_computer,
                                    winCount: user.wins,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Column(
                                children: [
                                  _searchTrendsPanel(),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Column(
                                children: [
                                  ProfileMySelfWidget(
                                    userName: user.name,
                                    userTitle: '@${user.username}',
                                    imagePath:
                                    user.profileImageUrl.isNotEmpty
                                        ? NetworkImage(
                                        user.profileImageUrl)
                                        : const AssetImage(
                                        'assets/default_profile.png'),
                                    followersCount:
                                    user.followers.length.toString(),
                                    followingCount:
                                    user.following.length.toString(),
                                    aboutMe: user.bio.isNotEmpty
                                        ? user.bio
                                        : 'لا توجد نبذة حتى الآن',
                                    statLeft:
                                    user.following.length.toString(),
                                    statRight:
                                    user.followers.length.toString(),
                                    followersList: user.followers,
                                    followingList: user.following,
                                    onShowUserList: _showUserListModal,
                                  ),
                                  const SizedBox(height: 15),
                                  currentUser == null
                                      ? const SizedBox.shrink()
                                      : CustomSidebar(
                                    isInDrawer: false,
                                    user: currentUser!,
                                    currentUserId: currentUserId,
                                    unreadMessages: unreadMessages,
                                    unreadNotifications:
                                    unreadNotifications,
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
            shape:
            const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
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
                      route: '/home',
                      isAlwaysActive: true,
                      onTapOverride: () async {
                        await LogoutService.signOut(context,
                            redirectRoute: '/main');
                      })
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

// ✅ يمكنك الحفاظ على كلاس _HoverDrawerItem كما هو دون تغيير
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
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 15,
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
