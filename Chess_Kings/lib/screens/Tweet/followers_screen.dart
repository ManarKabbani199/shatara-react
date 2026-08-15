import 'package:Chess_Cleverness/screens/Tweet/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/UserModel.dart';
import '../../Widget/TweetsProfilePage/CustomNavbarTweets.dart';
import '../../models/NotificationService.dart';
import '../../shared_data.dart' as shared;
import '../ShataraLoginScreen.dart';

class FollowersScreen extends StatefulWidget {
  final String title;

  const FollowersScreen({required this.title});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen>
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
  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShataraLoginScreen(),
          ),
        );
      });
      return;
    }

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
    currentUser = UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<UserModel> _fetchUser() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(shared.id_user)
        .get();
    if (!doc.exists) throw Exception('المستخدم غير موجود');
    UserModel user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
    isFollowing = user.followers.contains(currentUserId);
    return user;
  }

  // ✅ ويدجت الصورة أعلى الصفحة
  Widget _topVisual(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Image.asset(
              'assets/test.png',
              height: 120,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            height: 6,
            width: double.infinity,
            color: Colors.red,
            margin: const EdgeInsets.only(top: 8),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Text(
              'في الوقت الحالي شطارة تعمل بشكل أفضل على الكمبيوتر',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Alexandria',
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Image.asset(
            'assets/test.png',
            height: 120,
            fit: BoxFit.contain,
          ),
        ),
      );
    }
  }

  // ✅ دالة الإبلاغ (نفس ما أرسلته)
  void reportUser(String reportedUserId) {
    final reporterId = FirebaseAuth.instance.currentUser!.uid;
    TextEditingController reasonController = TextEditingController();
    String? selectedReason;

    List<String> reasons = [
      'مشكلة تتعلق بشخص يقل عمره عن 18 عامًا',
      'المضايقة أو الإساءة',
      'انتحار نفسي',
      'العنف، العنف في الزوجة',
      'نشر أو ترويج للعناصر المحظورة',
      'محتوى إباحي',
      'انتهاك أو السرقة للمعلومات الشخصية',
      'شيء ما لا يعجبني فيك',
    ];

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'الإبلاغ عن المستخدم',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: reasons.map((reason) {
                return RadioListTile<String>(
                  title: Text(reason),
                  value: reason,
                  groupValue: selectedReason,
                  onChanged: (value) {
                    selectedReason = value;
                    (context as Element).markNeedsBuild();
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final extraReason = reasonController.text.trim();
                if (selectedReason != null || extraReason.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('userReports')
                      .add({
                    'reportedUserId': reportedUserId,
                    'reporterUserId': reporterId,
                    'selectedReason': selectedReason,
                    'extraReason': extraReason,
                    'timestamp': Timestamp.now(),
                  });
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: const Text('شكراً لإخطارنا'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('تم'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('إرسال'),
            ),
          ],
        ),
      ),
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

    return FutureBuilder<UserModel>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
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

                    // ✅ الصورة هنا
                    _topVisual(isMobile),

                    const SizedBox(height: 20),

                    Expanded(
                      child: Center(
                        child: Text(
                          'هنا يمكنك إكمال عرض المتابعين أو المستخدمين...',
                          style: const TextStyle(
                            fontFamily: 'Alexandria',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
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
    return Drawer(
      backgroundColor: const Color(0xFFDDDDDC),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          children: const [
            DrawerHeader(
              child: Text('القائمة'),
            ),
            ListTile(title: Text('الرئيسية')),
            ListTile(title: Text('من نحن')),
          ],
        ),
      ),
    );
  }
}
