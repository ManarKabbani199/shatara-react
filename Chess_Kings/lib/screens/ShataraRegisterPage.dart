import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../global/common/toast.dart';
import '../models/UserModel.dart';
import '../shared_data.dart' as shared;
import '../utils/storage.dart';
import 'HomePage.dart';
import 'ShataraLoginScreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShataraRegisterPage extends StatefulWidget {
  const ShataraRegisterPage({Key? key}) : super(key: key);

  @override
  _ShataraRegisterPageState createState() => _ShataraRegisterPageState();
}

class _ShataraRegisterPageState extends State<ShataraRegisterPage> {
  String? selectedLevel;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController UsernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController_l = TextEditingController();
  final TextEditingController passwordController_l = TextEditingController();
  String? selectedCountryCode = '+966';
  bool rememberMe = false;
  bool _obscureText = true;

  RegExp nameExp = RegExp(r'^[a-zA-Zا-ي\s]*$');
  RegExp passExp =
  RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  bool isSigningUp = false;

  @override
  void dispose() {
    nameController.dispose();
    UsernameController.dispose();
    phoneController.dispose();
    emailController_l.dispose();
    passwordController_l.dispose();
    super.dispose();
  }

  final List<String> items = ['مبتدئ', 'متوسط', 'متقدم'];

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Stack(
        children: [
          // الخلفية
          Positioned.fill(
            child: Image.asset(
              'assets/looog.png',
              fit: BoxFit.cover,
            ),
          ),

          /// 🔥 أعلى اليسار: textn + زر العودة




          // المحتوى في المنتصف تماماً
          SingleChildScrollView(
            child: Align(
              alignment: Alignment.centerRight, // 👈 أقصى اليمين
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 40,
                  left: 20,
                  top: 120,
                  bottom: 40,
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    width: isMobile ? 360 : 500,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.45), // 👈 خلفية بيضاء شفافة
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center, // 👈 كل العناصر يمين
                      children: [
                        /// الشعار
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/logon.png',
                            width: 200,
                            height: 100,
                          ),
                        ),
                        const SizedBox(height: 15),

                        Text(
                          'عضو جديد في شطارة',
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: isMobile ? 18 : 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF6B4E45),
                          ),
                        ),
                        const SizedBox(height: 10),

                        Text(
                          'مرحبًا بك! يمكنك الانضمام إلينا عن طريق إنشاء حساب جديد',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Alexandria',
                            color: const Color(0xFF6B4E45),
                            fontSize: isMobile ? 12 : 14,
                          ),
                        ),
                        const SizedBox(height: 25),

                        _buildTextField(
                          controller: nameController,
                          icon: Icons.person,
                          label: 'الاسم الكامل',
                        ),
                        const SizedBox(height: 15),

                        _buildTextField(
                          controller: UsernameController,
                          icon: Icons.abc,
                          label: 'اسم المستخدم',
                        ),
                        const SizedBox(height: 15),

                        _buildTextField(
                          controller: emailController_l,
                          icon: Icons.email_outlined,
                          label: 'البريد الإلكتروني',
                        ),
                        const SizedBox(height: 15),

                        /// الهاتف + كود الدولة
                        Row(
                          children: [
                            Container(
                              width: 90,
                              height: 55,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: CountryCodePicker(
                                onChanged: (code) {
                                  setState(() {
                                    selectedCountryCode = code.dialCode;
                                  });
                                },
                                initialSelection: 'SA',
                                favorite: const ['+966', 'SA'],
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildTextField(
                                controller: phoneController,
                                icon: Icons.phone,
                                label: 'رقم الهاتف',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        _buildTextField(
                          controller: passwordController_l,
                          icon: Icons.lock_outline,
                          label: 'كلمة المرور',
                          obscureText: _obscureText,
                          suffix: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                        const SizedBox(height: 15),

                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: DropdownButtonFormField<String>(
                            value: selectedLevel,
                            items: items
                                .map(
                                  (item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(fontFamily: 'Alexandria'),
                                ),
                              ),
                            )
                                .toList(),
                            onChanged: (value) {
                              setState(() => selectedLevel = value);
                            },
                            decoration: const InputDecoration(
                              labelText: 'اختر مستواك',
                              prefixIcon: Icon(Icons.star_border),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        /// زر التسجيل
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _signUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFAB86B9),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            child: const Text(
                              'إنشاء حساب جديد',
                              style: TextStyle(
                                fontFamily: 'Alexandria',
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        /// تسجيل دخول
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'لديك حساب؟',
                              style: TextStyle(
                                fontFamily: 'Alexandria',
                                color: Color(0xFF878787),
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ShataraLoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'سجل دخول',
                                style: TextStyle(
                                  fontFamily: 'Alexandria',
                                  color: Color(0xFF6B4E45),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),


                          ],
                        ),
                        const SizedBox(height: 20),

                        Center(
                          child: const Text(
                            '© جميع الحقوق محفوظة شطارة 2025',
                            style: TextStyle(
                              fontFamily: 'Alexandria',
                              fontSize: 12,
                              color: Color(0xFF6B4E45),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // زر العودة
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const Home()),
                        );
                      },
                      borderRadius: BorderRadius.circular(60),
                      child: Image.asset(
                        'assets/catBtn.png',
                        width: 100,
                      ),
                    ),
                  ),

                  const SizedBox(width: 15), // 👈 مسافة بينهم

                  // صورة النص
                  Image.asset(
                    'assets/textn.png',
                    width: 125,
                  ),
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }

  // عنصر إدخال جاهز
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          suffixIcon: suffix,
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }

// 🔹 دالة توليد ShataID متزايد
  Future<int> getNextShataID() async {
    final counterRef = FirebaseFirestore.instance.collection('counters').doc('shataID');

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterRef);

      if (!snapshot.exists) {
        transaction.set(counterRef, {'value': 10001});
        return 10001;
      }

      int newValue = (snapshot['value'] as int) + 1;
      transaction.update(counterRef, {'value': newValue});
      return newValue;
    });
  }

//
// 🔹 دالة التسجيل العادي بالبريد
//
  void _signUp() async {
    setState(() => isSigningUp = true);

    try {
      final name = nameController.text.trim();
      final username = UsernameController.text.trim();
      final email = emailController_l.text.trim();
      final phone = '${selectedCountryCode}${phoneController.text.trim()}';
      final password = passwordController_l.text;
      final level = selectedLevel;

      // ✅ التحققات
      if (!nameExp.hasMatch(username)) {
        showToast(message: 'فقط يسمح لك بأدخال الحروف');
        return;
      }
      if (name.length < 4) {
        showToast(message: 'ادخل اسمك');
        return;
      }
      if (phone.length < 7) {
        showToast(message: 'ادخل رقم هاتف صحيح');
        return;
      }
      if (!EmailValidator.validate(email)) {
        showToast(message: "الايميل خاطئ");
        return;
      }
      if (!passExp.hasMatch(password)) {
        showToast(message: 'كلمة السر يجب أن تحتوي أحرف صغيرة وكبيرة ويجب أن تحتوي أرقام');
        return;
      }
      if (level == null) {
        showToast(message: 'لم يتم اختيار أي مستوى');
        return;
      }

      // ✅ إنشاء حساب جديد
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final uid = userCredential.user!.uid;
      await userCredential.user!.updateDisplayName(username);

      // ✅ احصل على ShataID جديد
      final shataID = await getNextShataID();

      // ✅ إنشاء نموذج المستخدم
      final newUser = UserModel(
        uid: uid,
        email: email,
        login: "1",
        play_computer: "0",
        wins: "0",
        phone_number: phone,
        level: level,
        password: '',
        username: username,
        name: name,
        bio: '',
        profileImageUrl: '',
        bannerImageUrl: '',
        followers: const [],
        following: const [],
        isBanned: false,
        online: false,
        WChessId: 0,
        ShataID: shataID,
      );

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        ...newUser.toMap()..remove('password'),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await saveUid(uid);
      shared.id_user = uid;

      nameController.clear();
      UsernameController.clear();
      emailController_l.clear();
      phoneController.clear();
      passwordController_l.clear();

      showToast(message: "شكراً لانضمامك إلى أسرة شطرنج شطاره");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ShataraLoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'البريد مستخدم بالفعل. جرّب بريد آخر.');
      } else if (e.code == 'weak-password') {
        showToast(message: 'كلمة المرور ضعيفة.');
      } else if (e.code == 'invalid-email') {
        showToast(message: 'صيغة البريد غير صحيحة.');
      } else {
        showToast(message: 'حدث خطأ أثناء إنشاء الحساب: ${e.message}');
      }
    } catch (e) {
      showToast(message: 'حدث خطأ غير متوقع: $e');
    } finally {
      if (mounted) setState(() => isSigningUp = false);
    }
  }

//
// 🔹 تسجيل الدخول بواسطة Google
//
  void signInWithGoogle() async {
    try {
      final authProvider = GoogleAuthProvider();
      final FirebaseAuth _auth = FirebaseAuth.instance;

      UserCredential userCredential = await _auth.signInWithPopup(authProvider);

      final uid = userCredential.user!.uid;
      final email = userCredential.user?.email ?? '';
      final username = userCredential.user?.displayName ?? '';
      final photoURL = userCredential.user?.photoURL ?? '';

      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final userDoc = await docRef.get();

      if (userDoc.exists) {
        // ✅ المستخدم موجود
        await docRef.update({'online': true});
        shared.id_user = uid;
        await updateUserLogin();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        // ✅ مستخدم جديد
        final shataID = await getNextShataID();

        final newUser = UserModel(
          uid: uid,
          username: username,
          email: email,
          login: "1",
          play_computer: "0",
          wins: "0",
          phone_number: "",
          level: "مبتدئ",
          password: "",
          name: username,
          bio: '',
          profileImageUrl: photoURL,
          bannerImageUrl: '',
          followers: const [],
          following: const [],
          isBanned: false,
          online: true,
          WChessId: 0,
          ShataID: shataID,
        );

        await docRef.set({
          ...newUser.toMap()..remove('password'),
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        shared.id_user = uid;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    } catch (e) {
      print("Error signing in with Google: $e");
      showToast(message: "فشل تسجيل الدخول باستخدام Google");
    }
  }



  Future<void> updateUserLogin() async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

    final doc = await userDocRef.get();

    if (doc.exists) {
      final data = doc.data()!;
      final currentLoginCount = int.tryParse(data['login'] ?? '0') ?? 0;
      await userDocRef.update({
        'login': (currentLoginCount + 1).toString(),
      });

    }
  }
}

