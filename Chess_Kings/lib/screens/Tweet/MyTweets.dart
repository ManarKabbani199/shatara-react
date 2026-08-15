import 'package:Chess_Cleverness/screens/Tweet/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Widget/TweetsProfilePage/CustomNavbarTweets.dart';
import '../../Widget/TweetsProfilePage/CustomSidebar.dart';
import '../../Widget/TweetsProfilePage/CustomWidget.dart';
import '../../Widget/TweetsProfilePage/ProfileCardWidget.dart';
import '../../Widget/TweetsProfilePage/ProfileMySelfWidget.dart';
import '../../Widget/TweetsProfilePage/ProfileName.dart';
import '../../models/UserModel.dart';
import '../../services/ChatService.dart';
import '../../services/logout_service.dart';
import '../../shared_data.dart' as shared;
import 'ChatScreen.dart';
import 'edit_profile_screen.dart';
import '../../Widget/TweetsPage/TweetTile.dart';
import '../../models/tweet_model.dart';

class MyTweets extends StatefulWidget {
  final String userId;

  const MyTweets({required this.userId});

  @override
  State<MyTweets> createState() => _MyTweetsState();
}

class _MyTweetsState extends State<MyTweets> with SingleTickerProviderStateMixin {
  bool isAnyDrawerHovering = false;

  late Future<UserModel> _userFuture;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  bool isFollowing = false;
  UserModel? currentUser;
  String searchQuery = '';

  int unreadNotifications = 0;
  int unreadMessages = 0;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUser();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
    currentUser = UserModel.fromMap(doc.data() as Map<String, dynamic>);
    if (mounted) setState(() {});
  }

  Future<UserModel> _fetchUser() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
    if (!doc.exists) throw Exception('المستخدم غير موجود');
    UserModel user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
    isFollowing = user.followers.contains(currentUserId);
    return user;
  }

  Future<void> _followUser(UserModel user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'followers': FieldValue.arrayUnion([currentUserId])
    });

    await FirebaseFirestore.instance.collection('users').doc(currentUserId).update({
      'following': FieldValue.arrayUnion([user.uid])
    });

    await FirebaseFirestore.instance.collection('notifications').add({
      'type': 'follow',
      'from': currentUserId,
      'to': user.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      isFollowing = true;
      _userFuture = _fetchUser();
    });
  }

  Future<void> _unfollowUser(UserModel user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'followers': FieldValue.arrayRemove([currentUserId])
    });

    await FirebaseFirestore.instance.collection('users').doc(currentUserId).update({
      'following': FieldValue.arrayRemove([user.uid])
    });

    setState(() {
      isFollowing = false;
      _userFuture = _fetchUser();
    });
  }

  void _goToEditProfile(UserModel user) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfileScreen(user: user)),
    );
    setState(() {
      _userFuture = _fetchUser();
    });
  }

  void _startChatWithUser(UserModel peerUser) async {
    if (currentUser == null) return;

    String conversationId = await ChatService().createOrGetChat(currentUserId, peerUser.uid);

    await FirebaseFirestore.instance.collection('notifications').add({
      'type': 'message',
      'from': currentUserId,
      'to': peerUser.uid,
      'conversationId': conversationId,
      'timestamp': FieldValue.serverTimestamp(),
    });
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            conversationId: conversationId,
            currentUser: currentUser!,
            peerUser: peerUser,
          ),
        ),
      );
    });
  }

  void _showUserListModal(BuildContext context, List<dynamic> userIds, String title) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                        if (!snapshot.hasData || !snapshot.data!.exists) return SizedBox.shrink();
                        final data = snapshot.data!.data() as Map<String, dynamic>;
                        final user = UserModel.fromMap(data);
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: user.profileImageUrl.isNotEmpty
                                ? NetworkImage(user.profileImageUrl)
                                : AssetImage('assets/default_profile.png') as ImageProvider,
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

  // ✅ البانر العلوي (متجاوب للكمبيوتر والجوال)
  Widget _buildTopBanner(bool isMobile) {
    if (isMobile) {
      // الجوال: الصورة في الأعلى + شريط أحمر بالنص
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/test.png',
                height: 80, // يمكنك تعديل الارتفاع
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            color: Colors.red,
            child: const Text(
              'في الوقت الحالي شطارة تعمل بشكل أفضل على الكمبيوتر',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                height: 1.3,
              ),
            ),
          ),
        ],
      );
    } else {
      // الكمبيوتر: الصورة في منتصف أعلى الصفحة
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Align(
          alignment: Alignment.topCenter,
          child: Image.asset(
            'assets/test.png',
            height: 120, // يمكنك تعديل الارتفاع
            fit: BoxFit.contain,
          ),
        ),
      );
    }
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

                    // ✅ البانر العلوي المضاف هنا
                    const SizedBox(height: 20),
                    _buildTopBanner(isMobile),
                    const SizedBox(height: 12),

                    Expanded(
                      child: isMobile
                          ? SingleChildScrollView(
                        child: Column(
                          children: [
                            ProfileCardWidget(
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

                              // تم تمرير الوظائف الجديدة هنا
                              onFollowPressed: isFollowing ? () => _unfollowUser(user) : () => _followUser(user),
                              onMessagePressed: () => _startChatWithUser(user),
                              isFollowing: isFollowing, // حالة المتابعة الحالية
                            ),
                            const SizedBox(height: 15),
                            const Divider(),
                            const SizedBox(height: 15),
                            CustomWidget(
                              level: user.level,
                              loginCount: user.login,
                              vsComputerCount: user.play_computer,
                              winCount: user.wins,
                            ),
                            const SizedBox(height: 15),
                            const SizedBox(height: 15),
                            ProfileName(
                              onSearchChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },
                            ),
                            const SizedBox(height: 15),

                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('tweets')
                                  .where('type', isEqualTo: 'tweet')
                                  .where('userId', isEqualTo: shared.id_user) // ✅ عرض تغريداتي فقط
                                  .orderBy('timestamp', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }

                                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                  return const Center(child: Text('لا توجد تغريدات خاصة بك.'));
                                }

                                final tweets = snapshot.data!.docs.map((doc) {
                                  return TweetModel.fromMap(doc.data() as Map<String, dynamic>, id: doc.id);
                                }).where((tweet) {
                                  final text = tweet.text.toLowerCase();
                                  final query = searchQuery.toLowerCase();
                                  return query.isEmpty || text.contains(query) || text.contains('#$query');
                                }).toList();

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: tweets.length,
                                  itemBuilder: (context, index) {
                                    return TweetTile(tweet: tweets[index]);
                                  },
                                );
                              },
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
                            if (currentUser != null)
                              CustomSidebar(
                                isInDrawer: false,
                                user: currentUser!,
                                currentUserId: currentUserId,
                                unreadMessages: unreadMessages,
                                unreadNotifications: unreadNotifications,
                              ),
                          ],
                        ),
                      )
                          : Row(
                        children: [
                          Expanded(
                            flex: 1,
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
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('tweets')
                                        .where('type', isEqualTo: 'tweet')
                                        .where('userId', isEqualTo: shared.id_user) // ✅ عرض تغريداتي فقط
                                        .orderBy('timestamp', descending: true)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                      }

                                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                        return const Center(child: Text('لا توجد تغريدات خاصة بك.'));
                                      }

                                      final tweets = snapshot.data!.docs.map((doc) {
                                        return TweetModel.fromMap(doc.data() as Map<String, dynamic>, id: doc.id);
                                      }).where((tweet) {
                                        final text = tweet.text.toLowerCase();
                                        final query = searchQuery.toLowerCase();
                                        return query.isEmpty || text.contains(query) || text.contains('#$query');
                                      }).toList();

                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: tweets.length,
                                        itemBuilder: (context, index) {
                                          return TweetTile(tweet: tweets[index]);
                                        },
                                      );
                                    },
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
                                  if (currentUser != null)
                                    CustomSidebar(
                                      isInDrawer: false, // أو true إن كنت تستخدمه داخل Drawer
                                      user: currentUser!,
                                      currentUserId: currentUserId,
                                      unreadMessages: unreadMessages,
                                      unreadNotifications: unreadNotifications,
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
