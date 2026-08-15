import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Widget/TweetsPage/TweetTile.dart';
import '../../models/tweet_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Widget/TweetsProfilePage/CustomNavbarTweets.dart';
import '../../Widget/TweetsProfilePage/CustomSidebar.dart';
import '../../Widget/TweetsProfilePage/CustomWidget.dart';
import '../../Widget/TweetsProfilePage/ProfileCardWidget.dart';
import '../../models/NotificationService.dart';
import '../../models/UserModel.dart';
import '../../services/ChatService.dart';
import '../../services/logout_service.dart';
import 'ChatScreen.dart';
import 'edit_profile_screen.dart';
import 'profile_screen.dart'; // ✅ استيراد شاشة الملف الشخصي

class TweetDetailScreen extends StatefulWidget {
  final TweetModel tweet;

  const TweetDetailScreen({required this.tweet});

  @override
  State<TweetDetailScreen> createState() => _TweetDetailScreenState();
}

class _TweetDetailScreenState extends State<TweetDetailScreen> with SingleTickerProviderStateMixin {
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
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.tweet.userId)
        .get();
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
                    // شريط علوي
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

                    // ✅ الصورة في الديسكتوب: أعلى الصفحة وبالمنتصف
                    if (!isMobile) ...[
                      const SizedBox(height: 8),
                      Center(
                        child: Image.asset(
                          'assets/test.png',
                          height: 140,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    const SizedBox(height: 20),

                    Expanded(
                      child: isMobile
                          ? SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 15),

                            // ✅ الصورة في الجوال: في الأعلى + شريط أحمر عريض بالنص
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/test.png',
                                    height: 120,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                    color: Colors.red,
                                    child: const Text(
                                      'في الوقت الحالي شطارة تعمل بشكل أفضل على الكمبيوتر',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Alexandria',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 15),

                            CustomWidget(
                              level: user.level,
                              loginCount: user.login,
                              vsComputerCount: user.play_computer,
                              winCount: user.wins,
                            ),
                            const SizedBox(height: 15),
                            const SizedBox(height: 15),
                            CustomWidget(
                              level: user.level,
                              loginCount: user.login,
                              vsComputerCount: user.play_computer,
                              winCount: user.wins,
                            ),
                            const SizedBox(height: 15),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TweetTile(tweet: widget.tweet),
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton.icon(
                                    icon: const Icon(Icons.favorite, color: Colors.white, size: 18),
                                    label: Text(
                                      "الإعجابات (${widget.tweet.likes.length})",
                                      style: const TextStyle(
                                        fontFamily: 'Alexandria',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color(0xFF6B4E45),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                    ),
                                    onPressed: () => _showUserListDialog(context, widget.tweet.likes, 'المعجبون'),
                                  ),
                                  TextButton.icon(
                                    icon: const Icon(Icons.thumb_down_alt_outlined, color: Colors.white, size: 18),
                                    label: Text(
                                      "لم يعجبهم (${widget.tweet.dislikes.length})",
                                      style: const TextStyle(
                                        fontFamily: 'Alexandria',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color(0xFF6B4E45),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                    ),
                                    onPressed: () => _showUserListDialog(context, widget.tweet.dislikes, 'لم يعجبهم'),
                                  ),
                                  TextButton.icon(
                                    icon: const Icon(Icons.repeat, color: Colors.white, size: 18),
                                    label: const Text(
                                      "الرتويت",
                                      style: TextStyle(
                                        fontFamily: 'Alexandria',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color(0xFF6B4E45),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                    ),
                                    onPressed: () => _showRetweetsDialog(context, widget.tweet.id),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            const SizedBox(height: 15),

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
                              onFollowPressed: isFollowing ? () => _unfollowUser(user) : () => _followUser(user),
                              onMessagePressed: () => _startChatWithUser(user),
                              isFollowing: isFollowing,
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
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TweetTile(tweet: widget.tweet),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // ✅ إصلاح الأقواس هنا
                                        TextButton.icon(
                                          icon: const Icon(Icons.favorite, color: Colors.white, size: 18),
                                          label: Text(
                                            "الإعجابات (${widget.tweet.likes.length})",
                                            style: const TextStyle(
                                              fontFamily: 'Alexandria',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          style: TextButton.styleFrom(
                                            backgroundColor: const Color(0xFF6B4E45),
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                          ),
                                          onPressed: () => _showUserListDialog(context, widget.tweet.likes, 'المعجبون'),
                                        ),
                                        TextButton.icon(
                                          icon: const Icon(Icons.thumb_down_alt_outlined, color: Colors.white, size: 18),
                                          label: const Text(
                                            "لم يعجبهم (0)", // سيتم استبدالها بالأسفل
                                            style: TextStyle(
                                              fontFamily: 'Alexandria',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          style: TextButton.styleFrom(
                                            backgroundColor: const Color(0xFF6B4E45),
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                          ),
                                          onPressed: () => _showUserListDialog(context, widget.tweet.dislikes, 'لم يعجبهم'),
                                        ),
                                        TextButton.icon(
                                          icon: const Icon(Icons.repeat, color: Colors.white, size: 18),
                                          label: const Text(
                                            "الرتويت",
                                            style: TextStyle(
                                              fontFamily: 'Alexandria',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          style: TextButton.styleFrom(
                                            backgroundColor: const Color(0xFF6B4E45),
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                          ),
                                          onPressed: () => _showRetweetsDialog(context, widget.tweet.id),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),

                                  // ✅ عرض الردود
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('tweets')
                                        .where('replyTo', isEqualTo: widget.tweet.id)
                                        .where('type', isEqualTo: "reply")
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                      }
                                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                        return const Center(child: Text("لا توجد ردود حتى الآن"));
                                      }
                                      final replies = snapshot.data!.docs.map((doc) {
                                        return TweetModel.fromMap(doc.data() as Map<String, dynamic>, id: doc.id);
                                      }).toList();

                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: replies.length,
                                        itemBuilder: (context, index) => Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.05),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: TweetTile(tweet: replies[index]),
                                        ),
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
                                    onFollowPressed: isFollowing ? () => _unfollowUser(user) : () => _followUser(user),
                                    onMessagePressed: () => _startChatWithUser(user),
                                    isFollowing: isFollowing,
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
                  _HoverDrawerItem(label: 'ألعب الأن', route: '', isAnyHovering: isAnyDrawerHovering, onHoverChanged: (h) => setState(() => isAnyDrawerHovering = h)),
                  isLoggedIn
                      ? _HoverDrawerItem(label: 'تسجيل الخروج', route: '/home', isAlwaysActive: true, onTapOverride: () async {
                    await LogoutService.signOut(context, redirectRoute: '/main');
                  })
                      : const _HoverDrawerItem(label: 'تسجيل الدخول', route: '/login', isAlwaysActive: true),
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
          child: SelectableText(
            widget.label,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 15,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

void _showUserListDialog(BuildContext context, List userIds, String title) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      backgroundColor: Colors.white,
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontFamily: 'Alexandria',
          fontWeight: FontWeight.bold,
          color: Color(0xFF774E85),
          fontSize: 20,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: userIds.length,
          itemBuilder: (context, index) {
            final userId = userIds[index];
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                final user = snapshot.data!.data() as Map<String, dynamic>;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: (user['profileImageUrl'] != null &&
                        user['profileImageUrl'].toString().isNotEmpty)
                        ? NetworkImage(user['profileImageUrl'])
                        : const AssetImage('assets/default_profile.png') as ImageProvider,
                  ),
                  title: Text(
                    user['username'] ?? 'مستخدم',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontFamily: 'Alexandria',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "إغلاق",
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    ),
  );
}

void _showRetweetsDialog(BuildContext context, String tweetId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('tweets')
      .where('retweetedFrom', isEqualTo: tweetId)
      .where('type', isEqualTo: 'retweet')
      .get();

  final userIds = snapshot.docs.map((doc) => doc['userId']).toList();

  if (userIds.isEmpty) {
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          backgroundColor: Colors.white,
          title: const Text(
            'الرتويت',
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.right,
          ),
          content: const Text(
            'لا يوجد من أعاد المشاركه بعد',
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.right,
          ),
          actions: const [
            TextButton(
              onPressed: null,
              child: Text(
                "إغلاق",
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            )
          ],
        ),
      ),
    );
    return;
  }

  _showUserListDialog(context, userIds, 'أعادوا التغريد');
}
