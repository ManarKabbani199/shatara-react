import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:Chess_Cleverness/screens/Tweet/profile_screen.dart';
import '../../Widget/TweetsProfilePage/CustomNavbarTweets.dart';
import '../../Widget/TweetsProfilePage/CustomWidget.dart';
import '../../Widget/TweetsProfilePage/ProfileMySelfWidget.dart';
import '../../Widget/TweetsProfilePage/CustomSidebar.dart';
import '../../models/UserModel.dart';
import '../../services/logout_service.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  late Future<UserModel> _userFuture;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  bool isFollowing = false;
  UserModel? currentUser;

  int unreadNotifications = 0;
  int unreadMessages = 0;
  String searchQuery = '';

  late final TextEditingController nameController;
  late final TextEditingController usernameController;
  late final TextEditingController bioController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  String? selectedLevel;
  Uint8List? profileImageBytes;
  Uint8List? bannerImageBytes;
  final List<String> levels = const ['مبتدئ', 'متوسط', 'خبير'];
  bool isSaving = false;

  bool get isMobile => MediaQuery.of(context).size.width < 900;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    usernameController = TextEditingController(text: widget.user.username);
    bioController = TextEditingController(text: widget.user.bio);
    passwordController = TextEditingController(text: widget.user.password);
    confirmPasswordController = TextEditingController();
    selectedLevel = widget.user.level;

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _userFuture = _fetchUser();
    _loadCurrentUser();
  }

  @override
  void dispose() {
    _controller.dispose();
    nameController.dispose();
    usernameController.dispose();
    bioController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
    if (!doc.exists) return;
    setState(() {
      currentUser = UserModel.fromMap(doc.data() as Map<String, dynamic>);
    });
  }

  Future<UserModel> _fetchUser() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(widget.user.uid).get();
    if (!doc.exists) throw Exception('المستخدم غير موجود');
    final user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
    isFollowing = user.followers.contains(currentUserId);
    return user;
  }

  Future<void> pickImage(bool isProfile) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final originalBytes = await picked.readAsBytes();
    final resizedBytes = resizeImage(originalBytes, width: isProfile ? 512 : 1200);
    setState(() {
      if (isProfile) profileImageBytes = resizedBytes;
      else bannerImageBytes = resizedBytes;
    });
  }

  Uint8List resizeImage(Uint8List data, {int width = 600}) {
    final decoded = img.decodeImage(data);
    if (decoded == null) return data;
    final resized = img.copyResize(decoded, width: width);
    return Uint8List.fromList(img.encodeJpg(resized, quality: 88));
  }

  Future<String?> uploadToExternalServer(Uint8List bytes, String filename) async {
    try {
      final uri = Uri.parse('https://shatarachess.com/profile_Image/upload.php');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(http.MultipartFile.fromBytes('file', bytes, filename: filename));
      final response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final jsonResp = json.decode(respStr) as Map<String, dynamic>;
        if (jsonResp['success'] == true && jsonResp['url'] is String) {
          return jsonResp['url'] as String;
        }
      }
    } catch (e) {
      debugPrint('Upload error: $e');
    }
    return null;
  }

  Future<void> saveChanges() async {
    if (isSaving) return;
    final pass = passwordController.text.trim();
    final pass2 = confirmPasswordController.text.trim();

    if (pass.isNotEmpty && pass != pass2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمتا المرور غير متطابقتين')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      String profileUrl = widget.user.profileImageUrl;
      String bannerUrl = widget.user.bannerImageUrl;
      if (profileImageBytes != null) {
        profileUrl = await uploadToExternalServer(profileImageBytes!, 'profile_${widget.user.uid}.jpg') ?? profileUrl;
      }
      if (bannerImageBytes != null) {
        bannerUrl = await uploadToExternalServer(bannerImageBytes!, 'banner_${widget.user.uid}.jpg') ?? bannerUrl;
      }

      await FirebaseFirestore.instance.collection('users').doc(widget.user.uid).update({
        'name': nameController.text.trim(),
        'username': usernameController.text.trim(),
        'bio': bioController.text.trim(),
        'password': pass,
        'level': selectedLevel,
        'profileImageUrl': profileUrl,
        'bannerImageUrl': bannerUrl,
      });

      if (pass.isNotEmpty) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) await user.updatePassword(pass);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ التعديلات بنجاح')),
      );
      Navigator.pop(context);
    } catch (e) {
      debugPrint('Save error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء الحفظ: $e')),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  // ✅ دالة الصورة في أعلى الشاشة للكمبيوتر
  Widget _DesktopTopImage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Image.asset(
          'assets/test.png',
          height: 80,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // ✅ دالة الصورة + الشريط الأحمر للجوال
  Widget _MobileTopNotice() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Image.asset(
            'assets/test.png',
            height: 60,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          color: Colors.red,
          child: const Center(
            child: Text(
              'في الوقت الحالي شطارة تعمل بشكل أفضل على الكمبيوتر',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('خطأ: ${snapshot.error}')));
        }
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: Text('لم يتم العثور على المستخدم')));
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

                    // ✅ الصورة في الأعلى حسب الجهاز
                    if (isMobile) _MobileTopNotice() else _DesktopTopImage(),

                    const SizedBox(height: 20),

                    Expanded(
                      child: isMobile
                          ? SingleChildScrollView(child: _buildEditorPanel(user))
                          : Center(
                        child: SingleChildScrollView(
                          child: _buildEditorPanel(user),
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

  Widget _buildEditorPanel(UserModel user) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 3.2,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFA39E9E),
                        image: DecorationImage(
                          image: bannerImageBytes != null
                              ? MemoryImage(bannerImageBytes!)
                              : (user.bannerImageUrl.isNotEmpty
                              ? NetworkImage(user.bannerImageUrl)
                              : const AssetImage('assets/default_banner.png')) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: ElevatedButton.icon(
                        onPressed: () => pickImage(false),
                        icon: const Icon(Icons.photo),
                        label: const Text('تغيير الغلاف'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundImage: profileImageBytes != null
                        ? MemoryImage(profileImageBytes!)
                        : (user.profileImageUrl.isNotEmpty
                        ? NetworkImage(user.profileImageUrl)
                        : const AssetImage('assets/default_profile.png')) as ImageProvider,
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => pickImage(true),
                    icon: const Icon(Icons.photo_camera),
                    label: const Text('تغيير الصورة'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _LabeledField(label: 'الاسم', child: TextField(controller: nameController)),
              _LabeledField(label: 'اسم المستخدم', child: TextField(controller: usernameController)),
              _LabeledField(label: 'نبذة', child: TextField(controller: bioController, maxLines: 3)),
              _LabeledField(
                label: 'المستوى',
                child: DropdownButtonFormField<String>(
                  value: selectedLevel,
                  items: levels.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                  onChanged: (v) => setState(() => selectedLevel = v),
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 360,
                  child: ElevatedButton.icon(
                    onPressed: isSaving ? null : saveChanges,
                    icon: isSaving
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.save),
                    label: Text(isSaving ? 'جارٍ الحفظ...' : 'حفظ التعديلات'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAB86B9),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(56),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==== الأدوات الإضافية ====

Widget _buildDrawer(BuildContext context) {
  bool isAnyDrawerHovering = false;
  return Drawer(
    backgroundColor: const Color(0xFFDDDDDC),
    child: ListView(
      children: [
        Image.asset('assets/logon.png', height: 60),
        const Divider(),
        ListTile(title: const Text('الرئيسية'), onTap: () => Navigator.pushNamed(context, '/main')),
      ],
    ),
  );
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
