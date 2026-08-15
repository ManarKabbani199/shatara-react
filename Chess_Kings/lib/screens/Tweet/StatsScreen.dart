import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Widget/TweetsProfilePage/CustomNavbarTweets.dart';
import '../../Widget/TweetsProfilePage/CustomSidebar.dart';
import '../../Widget/TweetsProfilePage/ProfileMySelfWidget.dart';
import '../../Widget/TwoStatsRow.dart';
import '../../models/NotificationService.dart';
import '../../models/UserModel.dart';
import '../../services/logout_service.dart';
import 'profile_screen.dart'; // ✅ استيراد شاشة الملف الشخصي
import '../../shared_data.dart' as shared;

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with SingleTickerProviderStateMixin {
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
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(shared.id_user).get();
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

  int totalUsers = 0;
  int totalTweets = 0;

  Map<String, int> userTweetCounts = {}; // userId => tweetCount
  Map<String, String> userNames = {}; // userId => name

  List<Map<String, dynamic>> topInteractiveTweets = []; // tweet info

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStats();
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

  Future<void> fetchStats() async {
    // 🔹 جلب عدد المستخدمين
    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    totalUsers = usersSnapshot.size;

    for (var doc in usersSnapshot.docs) {
      userNames[doc.id] = doc.data()['name'] ?? 'مستخدم';
    }

    // 🔹 جلب جميع التغريدات
    final tweetsSnapshot = await FirebaseFirestore.instance.collection('tweets').get();
    totalTweets = tweetsSnapshot.size;

    // 🔹 تحليل التغريدات
    final List<Map<String, dynamic>> tweetsList = [];

    for (var doc in tweetsSnapshot.docs) {
      final data = doc.data();
      final uid = data['userId'];
      if (uid != null) {
        userTweetCounts[uid] = (userTweetCounts[uid] ?? 0) + 1;
      }

      tweetsList.add({
        'id': doc.id,
        'text': data['text'] ?? '',
        'likes': (data['likes'] as List?)?.length ?? 0,
        'retweets': data['retweetedFrom'] != null ? 1 : 0,
      });
    }

    // 🔹 التغريدات الأكثر تفاعلًا
    tweetsList.sort((a, b) {
      final aScore = a['likes'] + a['retweets'];
      final bScore = b['likes'] + b['retweets'];
      return bScore.compareTo(aScore);
    });
    topInteractiveTweets = tweetsList.take(5).toList();

    setState(() {
      isLoading = false;
    });
  }

  // 🔹 مخطط المستخدمين الأكثر تغريدًا
  List<BarChartGroupData> getBarChartData() {
    final topUsers = userTweetCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top5 = topUsers.take(5).toList();

    return List.generate(top5.length, (index) {
      final entry = top5[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: const Color(0xFFAB86B9),
            width: 25,
          ),
        ],
        showingTooltipIndicators: [0],
      );
    });
  }

  List<String> getBarChartLabels() {
    final topUsers = userTweetCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top5 = topUsers.take(5).toList();
    return top5.map((entry) => userNames[entry.key] ?? 'مستخدم').toList();
  }

  // 🔹 مخطط التغريدات الأكثر تفاعلًا
  List<BarChartGroupData> getTopTweetsBarChart() {
    return List.generate(topInteractiveTweets.length, (index) {
      final item = topInteractiveTweets[index];
      final total = item['likes'] + item['retweets'];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: total.toDouble(),
            color: const Color(0xFFAB86B9),
            width: 25,
          ),
        ],
        showingTooltipIndicators: [0],
      );
    });
  }

  List<String> getTopTweetLabels() {
    return topInteractiveTweets.map((e) {
      String text = e['text'];
      return text.length > 10 ? '${text.substring(0, 10)}...' : text;
    }).toList();
  }

  // ✅ عنصر علوي متكيّف للكمبيوتر والجوال
  Widget _buildTopVisual(bool isMobile) {
    // على الجوال: الصورة بالأعلى + شريط أحمر بالنص
    if (isMobile) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Image.asset(
              'assets/test.png',
              height: 90,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Colors.red,
            child: const Text(
              'في الوقت الحالي شطارة تعمل بشكل أفضل على الكمبيوتر',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      );
    }

    // على الكمبيوتر: الصورة في أعلى الصفحة ومتمركزة في المنتصف
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Center(
        child: Image.asset(
          'assets/test.png',
          height: 120,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final labels = getBarChartLabels();
    final tweetLabels = getTopTweetLabels();
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

                    // ✅ هنا العنصر العلوي المطلوب (صورة + شريط أحمر في الجوال)
                    _buildTopVisual(isMobile),

                    const SizedBox(height: 20),

                    Expanded(
                      child: isMobile
                          ? SingleChildScrollView(
                        child: Column(
                          children: [
                            TwoStatsRow(
                              totalUsers: '$totalUsers',
                              totalTweets: '$totalTweets',
                            ),
                            const SizedBox(height: 35),
                            Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(15.0),
                                            child: Text(
                                              'أكثر المستخدمين نشاطًا',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Alexandria',
                                                color: Color(0xFF472C24),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 250,
                                            child: BarChart(
                                              BarChartData(
                                                alignment: BarChartAlignment.spaceAround,
                                                gridData: FlGridData(show: false),
                                                titlesData: FlTitlesData(
                                                  bottomTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      getTitlesWidget: (value, meta) {
                                                        final index = value.toInt();
                                                        if (index < labels.length) {
                                                          return Padding(
                                                            padding: const EdgeInsets.only(top: 8.0),
                                                            child: Text(
                                                              labels[index],
                                                              style: const TextStyle(fontSize: 10),
                                                            ),
                                                          );
                                                        }
                                                        return const SizedBox.shrink();
                                                      },
                                                    ),
                                                  ),
                                                  leftTitles: const AxisTitles(
                                                    sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                                                  ),
                                                  topTitles: const AxisTitles(
                                                    sideTitles: SideTitles(showTitles: false),
                                                  ),
                                                  rightTitles: const AxisTitles(
                                                    sideTitles: SideTitles(showTitles: false),
                                                  ),
                                                ),
                                                borderData: FlBorderData(show: false),
                                                barGroups: getBarChartData(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),
                            Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text(
                                              'أكثر المشاركات تفاعلًا',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Alexandria',
                                                color: Color(0xFF472C24),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 250,
                                            child: BarChart(
                                              BarChartData(
                                                alignment: BarChartAlignment.spaceAround,
                                                gridData: FlGridData(show: false),
                                                titlesData: FlTitlesData(
                                                  bottomTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      getTitlesWidget: (value, meta) {
                                                        final index = value.toInt();
                                                        if (index < tweetLabels.length) {
                                                          return Padding(
                                                            padding: const EdgeInsets.only(top: 8.0),
                                                            child: Text(
                                                              tweetLabels[index],
                                                              style: const TextStyle(fontSize: 10),
                                                            ),
                                                          );
                                                        }
                                                        return const SizedBox.shrink();
                                                      },
                                                    ),
                                                  ),
                                                  leftTitles: const AxisTitles(
                                                    sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                                                  ),
                                                  topTitles: const AxisTitles(
                                                    sideTitles: SideTitles(showTitles: false),
                                                  ),
                                                  rightTitles: const AxisTitles(
                                                    sideTitles: SideTitles(showTitles: false),
                                                  ),
                                                ),
                                                borderData: FlBorderData(show: false),
                                                barGroups: getTopTweetsBarChart(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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
                      )
                          : Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: TwoStatsRow(
                                      totalUsers: '$totalUsers',
                                      totalTweets: '$totalTweets',
                                    ),
                                  ),
                                  const SizedBox(height: 35),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(15.0),
                                            child: Text(
                                              'أكثر المستخدمين نشاطًا',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Alexandria',
                                                color: Color(0xFF472C24),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 250,
                                            child: BarChart(
                                              BarChartData(
                                                alignment: BarChartAlignment.spaceAround,
                                                gridData: FlGridData(show: false),
                                                titlesData: FlTitlesData(
                                                  bottomTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      getTitlesWidget: (value, meta) {
                                                        final index = value.toInt();
                                                        if (index < labels.length) {
                                                          return Padding(
                                                            padding: const EdgeInsets.only(top: 8.0),
                                                            child: Text(
                                                              labels[index],
                                                              style: const TextStyle(fontSize: 10),
                                                            ),
                                                          );
                                                        }
                                                        return const SizedBox.shrink();
                                                      },
                                                    ),
                                                  ),
                                                  leftTitles: const AxisTitles(
                                                    sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                                                  ),
                                                  topTitles: const AxisTitles(
                                                    sideTitles: SideTitles(showTitles: false),
                                                  ),
                                                  rightTitles: const AxisTitles(
                                                    sideTitles: SideTitles(showTitles: false),
                                                  ),
                                                ),
                                                borderData: FlBorderData(show: false),
                                                barGroups: getBarChartData(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 75),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text(
                                              'أكثر المشاركات تفاعلًا',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Alexandria',
                                                color: Color(0xFF472C24),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 250,
                                            child: BarChart(
                                              BarChartData(
                                                alignment: BarChartAlignment.spaceAround,
                                                gridData: FlGridData(show: false),
                                                titlesData: FlTitlesData(
                                                  bottomTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      getTitlesWidget: (value, meta) {
                                                        final index = value.toInt();
                                                        if (index < tweetLabels.length) {
                                                          return Padding(
                                                            padding: const EdgeInsets.only(top: 8.0),
                                                            child: Text(
                                                              tweetLabels[index],
                                                              style: const TextStyle(fontSize: 10),
                                                            ),
                                                          );
                                                        }
                                                        return const SizedBox.shrink();
                                                      },
                                                    ),
                                                  ),
                                                  leftTitles: const AxisTitles(
                                                    sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                                                  ),
                                                  topTitles: const AxisTitles(
                                                    sideTitles: SideTitles(showTitles: false),
                                                  ),
                                                  rightTitles: const AxisTitles(
                                                    sideTitles: SideTitles(showTitles: false),
                                                  ),
                                                ),
                                                borderData: FlBorderData(show: false),
                                                barGroups: getTopTweetsBarChart(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                    isInDrawer: false,
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
