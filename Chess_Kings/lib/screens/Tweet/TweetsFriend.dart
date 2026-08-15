import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Widget/TweetsFriend/FollowingTimeline.dart';
import '../../Widget/TweetsProfilePage/CustomNavbarTweets.dart';
import '../../Widget/TweetsProfilePage/CustomSidebar.dart';
import '../../Widget/TweetsProfilePage/CustomWidget.dart';
import '../../Widget/TweetsProfilePage/ProfileMySelfWidget.dart';
import '../../Widget/TweetsProfilePage/ProfileName.dart';
import '../../models/NotificationService.dart';
import '../../models/UserModel.dart';
import '../../services/logout_service.dart';
import 'profile_screen.dart'; // ✅ استيراد شاشة الملف الشخصي


class TweetsFriend extends StatefulWidget {
  final String userId;
  const TweetsFriend({super.key, required this.userId});

  @override
  State<TweetsFriend> createState() => _TweetsFriendState();
}

class _TweetsFriendState extends State<TweetsFriend> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool isAnyDrawerHovering = false;

  late Future<UserModel> _userFuture;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  bool isFollowing = false;
  UserModel? currentUser;

  int unreadNotifications = 0;
  int unreadMessages = 0;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    User? firebaseUser = FirebaseAuth.instance.currentUser;

    _loadCounts();
    _userFuture = _fetchUser();
    _loadCurrentUser();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadCounts() async {
    unreadNotifications = await NotificationService.getUnreadNotificationCount(currentUserId);
    unreadMessages = await NotificationService.getUnreadMessagesCount(currentUserId);
    setState(() {});
  }

  Future<void> _loadCurrentUser() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
    currentUser = UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<UserModel> _fetchUser() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
    if (!doc.exists) throw Exception('المستخدم غير موجود');
    UserModel user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
    isFollowing = user.followers.contains(currentUserId);
    return user;
  }



  void _showUserListModal(BuildContext context, List<dynamic> userIds, String title) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: userIds.length,
                  itemBuilder: (context, index) {
                    final uid = userIds[index];
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || !snapshot.data!.exists) return const SizedBox.shrink();
                        final data = snapshot.data!.data() as Map<String, dynamic>;
                        final user = UserModel.fromMap(data);
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: user.profileImageUrl.isNotEmpty
                                ? NetworkImage(user.profileImageUrl)
                                : const AssetImage('assets/default_profile.png') as ImageProvider,
                          ),
                          title: Text(user.name),
                          subtitle: Text('@${user.username}'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ProfileScreen(userId: user.uid)),
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

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    double screenWidth = MediaQuery.of(context).size.width / 3;

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
        final bool isMyProfile = widget.userId == currentUserId;

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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: isMobile
                          ? Align(
                        alignment: Alignment.topRight,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu, color: Color(0xFF6B4E45)),
                            onPressed: () => Scaffold.of(context).openEndDrawer(),
                          ),
                        ),
                      )
                          : const CustomNavbarTweets(),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: isMobile
                          ? SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            CustomWidget(
                              level: user.level,
                              loginCount: user.login,
                              vsComputerCount: user.play_computer,
                              winCount: user.wins,
                            ),
                            const SizedBox(height: 15),
                            ProfileName(
                              onSearchChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: FollowingTimeline(
                                searchQuery: '',              // مرّر نص البحث إن وُجد
                                includeCurrentUser: true,     // لعرض تغريدات المستخدم أيضاً
                                loadingBuilder: (ctx) => const Center(child: CircularProgressIndicator()),
                                emptyBuilder: (ctx) => const Center(child: Text('لا توجد مشاركات.')),
                              ),
                            ),
                            const SizedBox(height: 15),
                            ProfileMySelfWidget(
                              userName: user.name,
                              userTitle: '@${user.username}',
                              imagePath: user.profileImageUrl.isNotEmpty
                                  ? NetworkImage(user.profileImageUrl)
                                  : const AssetImage('assets/default_profile.png'),
                              followersCount: user.followers.length.toString(),
                              followingCount: user.following.length.toString(),
                              aboutMe: user.bio.isNotEmpty ? user.bio : 'لا توجد نبذة حتى الآن',
                              statLeft: user.following.length.toString(),
                              statRight: user.followers.length.toString(),
                              followersList: user.followers,
                              followingList: user.following,
                              onShowUserList: _showUserListModal,
                            ),

                            const SizedBox(height: 15),
                            CustomSidebar(
                              isInDrawer: false,
                              user: currentUser!,
                              currentUserId: currentUserId,
                              unreadMessages: unreadMessages,
                              unreadNotifications: unreadNotifications,
                            ),
                          ],
                        ),
                      ): Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Column(children: [const SizedBox(height: 15),
                                CustomWidget(
                                  level: user.level,
                                  loginCount: user.login,
                                  vsComputerCount: user.play_computer,
                                  winCount: user.wins,
                                ),
                              ]
                              )),

                          Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ProfileName(
                                    onSearchChanged: (value) {
                                      setState(() {
                                        searchQuery = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: FollowingTimeline(
                                      searchQuery: '',              // مرّر نص البحث إن وُجد
                                      includeCurrentUser: true,     // لعرض تغريدات المستخدم أيضاً
                                      loadingBuilder: (ctx) => const Center(child: CircularProgressIndicator()),
                                      emptyBuilder: (ctx) => const Center(child: Text('لا توجد مشاركات.')),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),


                          Expanded(
                            flex: 1,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ProfileMySelfWidget(
                                    userName: user.name,
                                    userTitle: '@${user.username}',
                                    imagePath: user.profileImageUrl.isNotEmpty
                                        ? NetworkImage(user.profileImageUrl)
                                        : const AssetImage('assets/default_profile.png'),
                                    followersCount: user.followers.length.toString(),
                                    followingCount: user.following.length.toString(),
                                    aboutMe: user.bio.isNotEmpty ? user.bio : 'لا توجد نبذة حتى الآن',
                                    statLeft: user.following.length.toString(),
                                    statRight: user.followers.length.toString(),
                                    followersList: user.followers,
                                    followingList: user.following,
                                    onShowUserList: _showUserListModal,
                                  ),
                                  const SizedBox(height: 15),
                                  CustomSidebar(
                                    isInDrawer: false, // أو true إن كنت تستخدمه داخل Drawer
                                    user: currentUser!,
                                    currentUserId: currentUserId,
                                    unreadMessages: unreadMessages,
                                    unreadNotifications: unreadNotifications,
                                  )

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
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            backgroundColor: const Color(0xFFDDDDDC),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                children: [
                  Image.asset('assets/logon.png', height: 60),
                  const Divider(),
                  _HoverDrawerItem(label: 'تعرف على شطاره', route: '/main', isAnyHovering: isAnyDrawerHovering, onHoverChanged: (h) => setState(() => isAnyDrawerHovering = h)),
                  _HoverDrawerItem(label: 'من نحن', route: '/about', isAnyHovering: isAnyDrawerHovering, onHoverChanged: (h) => setState(() => isAnyDrawerHovering = h)),
                  _HoverDrawerItem(label: 'الاسئلة الشائعة', route: '/faq', isAnyHovering: isAnyDrawerHovering, onHoverChanged: (h) => setState(() => isAnyDrawerHovering = h)),
                  _HoverDrawerItem(label: 'ألعب الأن', route: '/playNow', isAnyHovering: isAnyDrawerHovering, onHoverChanged: (h) => setState(() => isAnyDrawerHovering = h)),
                  isLoggedIn
                      ? _HoverDrawerItem(label: 'تسجيل الخروج', route: '/home', isAlwaysActive: true, onTapOverride: () async {
                       await LogoutService.signOut(context, redirectRoute: '/main');
                  })
                      : _HoverDrawerItem(label: 'تسجيل الدخول', route: '/login', isAlwaysActive: true),
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
