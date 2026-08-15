import 'package:Chess_Cleverness/screens/Admin/AdminDashboardScreen.dart';
import 'package:Chess_Cleverness/screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../global/common/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'MainHome.dart';
import 'models/UserModel.dart';
import 'shared_data.dart' as shared;




class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? selectedLevel;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController_l = TextEditingController();
  final TextEditingController passwordController_l = TextEditingController();
  String? selectedCountryCode = '+966'; // رمز الدولة الافتراضي (مثل السعودية)
  bool rememberMe = false;




  RegExp nameExp    = RegExp(r'^[a-zA-Zا-ي\s]*$');
  RegExp passExp    = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  bool isSigningUp  = false;
  bool _obscureText = true;


  late Timer _timer;
  Duration _duration = Duration();
  final String countdownKey = "countdown";
  List<UserModel> itemsU = [];



  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }




  _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      emailController_l.text = savedEmail;
      passwordController.text = savedPassword;
      rememberMe = true;
    }
  }



  final List<String> items = [
    'مبتدئ',
    'متوسط',
    'متقدم',
  ];

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailController_l.dispose();
    passwordController_l.dispose();
    _timer.cancel();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'شطرنج شطاره',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView( // إضافة SingleChildScrollView هنا
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/bgcc.png'), // مسار الصورة
                  ),
                ),
                padding: EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 50,),
                      Wrap(
                        alignment: WrapAlignment.center, // لتوسيط النصوص
                        spacing: 5, // المسافة بين العناصر
                        children: [
                          SelectableText(
                            'من شطاره',
                            style: TextStyle(fontFamily: 'Schyler', color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold), // تقليل حجم الخط قليلاً
                          ),
                          SelectableText(
                            'للانضمام إلى',
                            style: TextStyle(fontFamily: 'Schyler', color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold), // تقليل حجم الخط قليلاً
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0), // محاذاة 50 من الجانبين
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // يمكنك ضبطها إلى CrossAxisAlignment.end لمحاذاة العناصر مع اليمين
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end, // محاذاة المحتوى مع اليمين
                              children: [
                                SelectableText('الاسم الكامل', textAlign: TextAlign.right), // نص فوق العنصر
                                TextField(
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.abc),
                                  ),
                                  controller: nameController,
                                  textInputAction: TextInputAction.next,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            Row(
                              children: [
                                // قائمة الدول مع الأعلام
                                SizedBox(
                                  height: 75, // تحديد الارتفاع المطلوب
                                  child: CountryCodePicker(
                                    onChanged: (CountryCode code) {
                                      setState(() {
                                        selectedCountryCode = code.dialCode;
                                      });
                                    },
                                    initialSelection: 'SA', // الدولة الافتراضية (السعودية)
                                    favorite: ['+966', 'SA'], // الدول المفضلة
                                    showCountryOnly: false,
                                    showOnlyCountryWhenClosed: false,
                                    alignLeft: false,
                                  ),
                                ),
                                SizedBox(width: 8), // مسافة صغيرة بين القائمة وحقل الإدخال
                                // حقل إدخال رقم الهاتف
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SelectableText(
                                        'رقم الهاتف',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(fontFamily: 'Schyler', fontSize: 14, ),
                                      ),
                                      TextField(
                                        controller: phoneController,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.phone),
                                        ),
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly // السماح فقط بالأرقام
                                        ],
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SelectableText('البريد الإلكتروني', textAlign: TextAlign.right),
                                TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.done,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SelectableText('كلمة السر', textAlign: TextAlign.right),
                                TextField(
                                  controller: passwordController_l,
                                  textInputAction: TextInputAction.done,
                                  obscureText: _obscureText, // Use the obscureText property
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureText ? Icons.visibility_off : Icons.visibility ,
                                      ),
                                      onPressed: _togglePasswordVisibility, // Toggle function
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SelectableText('اختر مستواك', textAlign: TextAlign.right),
                                DropdownButtonFormField<String>(
                                  value: selectedLevel,
                                  items:items.map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: SelectableText(item),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedLevel = newValue; // تحديث الحالة بالقيمة المحددة
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF472F6B),
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              onPressed: () {

                                _signUp();

                              },
                              child: SelectableText('انضم الينا', style: TextStyle(color: Colors.white,
                                fontFamily: 'Schyler',)),
                            ),
                            SizedBox(height: 25),
                            Container(
                              alignment: Alignment.centerRight,
                              child: SelectableText(
                                "إذا كنت تمتلك بيانات تسجيل الدخول، يمكنك استخدامها للدخول مباشرة",
                                style: TextStyle(fontFamily: 'Schyler', color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SelectableText('الأيميل', textAlign: TextAlign.right),
                                TextField(
                                  controller: emailController_l,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                  textInputAction: TextInputAction.next,
                                  obscureText: false,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SelectableText('كلمة السر', textAlign: TextAlign.right),
                                TextField(
                                  controller: passwordController,
                                  textInputAction: TextInputAction.done,
                                  obscureText: _obscureText, // Use the obscureText property
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureText ? Icons.visibility_off : Icons.visibility ,
                                      ),
                                      onPressed: _togglePasswordVisibility, // Toggle function
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: rememberMe,

                                  onChanged: (value) {
                                    setState(() {
                                      rememberMe = value!;
                                    });
                                  },
                                ),
                                SelectableText('تذكرني'),
                              ],
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:Color(0xFF311B10),
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              onPressed: () {
                                _signin();
                              },
                              child: SelectableText('تسجيل الدخول', style: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(height: 25,),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:  Color(0xFF007A6C),
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              onPressed: () async {
                                signInWithGoogle();
                              },

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.google, // أيقونة Google
                                    color: Colors.white, // لون الأيقونة
                                    size: 24.0, // حجم الأيقونة
                                  ),// مساحة بين الأيقونة والنص
                                  SizedBox(width: 15),
                                  // استخدم أيقونة Google من font_awesome_flutter
                                  SelectableText(
                                    ' Google سجل الدخول بأستخدام   ',
                                    style: TextStyle(color: Colors.white, fontFamily: 'Schyler',),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),

                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0), // استخدام Padding موحد
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFf0e6d1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // استخدام MainAxisSize.min لتقليل المساحة المستخدمة
                    children: [
                      SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            SelectableText(
                              'حيث يلتقي التقليد مع الابتكار',
                              style: TextStyle(
                                fontFamily: 'Schyler',
                                color: Colors.black,
                                fontSize: MediaQuery.of(context).size.width < 600 ? 14 : 18, // تقليل حجم الخط أكثر
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(width: 5),
                            SelectableText(
                              'شطاره',
                              style: TextStyle(
                                fontFamily: 'Schyler',
                                color: Color(0xFF472F6B),
                                fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // توزيع المساحة بشكل متساوي
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFf0e6d1),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage('assets/bg_con.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Center(
                                child: SelectableText(
                                  'نحترم إرث الشطرنج التقليدي ونعتبره الأساس الذي تنطلق منه أفكارنا',
                                  style: TextStyle(
                                    fontFamily: 'Schyler',
                                    color: Colors.black,
                                    fontSize: MediaQuery.of(context).size.width < 600 ? 14 : 16, // حجم الخط متغير حسب العرض
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5), // مسافة بين العناصر
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(color: Color(0xFFf0e6d1),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage('assets/bg_con.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Center(
                                child: SelectableText(
                                  'شطارة تقدم لك تجربة جديدة، لكنها تحتفظ بروح اللعبة التي عُرفت عبر الأجيال',
                                  style: TextStyle(
                                    fontFamily: 'Schyler',
                                    color: Colors.black,
                                    fontSize: MediaQuery.of(context).size.width < 600 ? 14 : 16, // حجم الخط متغير حسب العرض
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5), // مسافة بين العناصر
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFf0e6d1),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage('assets/bg_con.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Center(
                                child: SelectableText(
                                  ' نؤمن بأن الإبداع والتطوير يمكن أن يتعايشا مع القواعد التقليدية، وهذا ما نسعى لتقديمه في هذه النسخة.',
                                  style: TextStyle(
                                    fontFamily: 'Schyler',
                                    color: Colors.black,
                                    fontSize: MediaQuery.of(context).size.width < 600 ? 14 : 16, // حجم الخط متغير حسب العرض
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 45,),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15,),
              SelectableText(
                'حقوق النشر @ شطارة 2025',
                textAlign: TextAlign.center, // محاذاة النص في المنتصف
                style: TextStyle(fontFamily: 'Schyler', color: Colors.black, fontWeight: FontWeight.bold,fontSize: 13),
              ),
              Container(
                color: Color(0xFFFDFFFF), // لون الخلفية
                padding: EdgeInsets.all(10.0), // تقليل الحواف
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // توزيع العناصر بالتساوي
                  crossAxisAlignment: CrossAxisAlignment.center, // محاذاة العناصر عموديًا في المنتصف
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.twitter, size: 20), // أيقونة انستغرام مع حجم أصغر
                          onPressed: () async {
                            const url = 'https://x.com/shatarachess?s=21';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'حدث خطأ الحساب غير موجود';
                            }
                          },
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.instagram, size: 20), // أيقونة انستغرام مع حجم أصغر
                          onPressed: () async {
                            const url = 'https://www.instagram.com/shatarachess?igsh=MXBqd3h4MzRzZHF4dw%3D%3D';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'حدث خطأ الحساب غير موجود';
                            }
                          },
                        ),
                        SizedBox(width: 10), // إضافة مساحة بين الأيقونات
                        IconButton(
                          icon: Icon(Icons.facebook, color: Colors.blue, size: 20), // أيقونة فيسبوك مع حجم أصغر
                          onPressed: () async {
                            const url = 'https://www.facebook.com/share/1V1GmmnXMn/?mibextid=wwXIfr';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'حدث خطأ الحساب غير موجود';
                            }
                          },
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/iccca.png', // تأكد من وضع المسار الصحيح للصورة
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15,),
              Container(
                width: double.infinity, // يأخذ كامل عرض الشاشة// يمكنك تعديل الارتفاع حسب الحاجة
                child: Image.asset(
                  'assets/btm.png', // تأكد من وضع المسار الصحيح للصورة
                  fit: BoxFit.cover, // يمكنك استخدام BoxFit.fill أو BoxFit.contain حسب الحاجة
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });


    String username = nameController.text;
    String email = emailController.text;
    String phone = '${selectedCountryCode}${phoneController.text}';
    String password =passwordController_l.text;
    String level;
    if (!(nameExp.hasMatch(username))) {
      showToast(message: 'فقط يسمح لك بأدخال الحروف');
    } else if (phone.length<7) {
      showToast(
          message:
          'ادخل رقم هاتف صحيح');
    } else if (!(EmailValidator.validate(email))) {
      showToast(message: "الايميل خاطئ");
    }else if (!(passExp.hasMatch(password))) {
      showToast(message: 'كلمة السر يجب أن تحتوي أحرف صغيرة و كبيره و يجب أن تحتوي أرقام');
    } else if (selectedLevel == null) {
      showToast(message:'لم يتم اختيار أي مستوى');
    }
    else {
      level=selectedLevel!;
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController_l.text.trim());
      String uid = userCredential.user!.uid;
      final shataID = await getNextShataID();
      UserModel newUser = UserModel(
        uid: uid,
        username: username.toString(),
        email: email,
        login: "1",
        play_computer: "0",
        wins: "0",
        phone_number: phone,
        level: level,
        password: password,
        name: username.toString(),
        bio: '',
        profileImageUrl: '',
        bannerImageUrl: '',
        followers: [],
        following: [],
        isBanned: false,
        online: false,
        WChessId: 0,
        ShataID: shataID,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(newUser.toMap());
      if(uid.isEmpty)
      {
        nameController.text=" ";
        emailController.text=" ";
        phoneController.text=" ";
        passwordController_l.text=" ";
        showToast(message:'الأيميل مستخدم أستخدم أيميل أخر');
      }
      else
      {
        nameController.text=" ";
        emailController.text=" ";
        phoneController.text=" ";
        passwordController_l.text=" ";
        showToast(message: "شكراً لأنضمامك إلى اسرة شطرنج شطاره");
      }

      setState(() {
        isSigningUp = false;
      });

    }
  }

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
  void _signin() async {
    String email = emailController_l.text.trim();
    String password = passwordController.text.trim();

    try {
      // تسجيل الدخول عبر Firebase
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      // "تذكرني"
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (rememberMe) {
        await prefs.setString('email', email);
        await prefs.setString('password', password);
      } else {
        await prefs.remove('email');
        await prefs.remove('password');
      }

      // التحقق هل هو مدير
      final adminSnapshot = await FirebaseFirestore.instance
          .collection('admins')
          .where('email', isEqualTo: email)
          .get();

      if (adminSnapshot.docs.isNotEmpty) {
        final adminData = adminSnapshot.docs.first.data();
        final adminPassword = adminData['password'] ?? '';

        if (password == adminPassword) {
          // نجاح تسجيل دخول مدير
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboardScreen(adminName: adminData['name']),),
          //    MaterialPageRoute(builder: (context) => AdminDashboardStore()),
          );
          return;
        }
      }

      // إذا لم يكن مدير → نكمل كمستخدم
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      UserModel user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      shared.id_user = uid;

      if (user.isBanned) {
        showToast(message: 'لقد تم حظرك من استخدام التطبيق');
        return;
      }

      await updateUserLogin();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainHome()),
      );

    } on FirebaseAuthException {
      showToast(message: 'بيانات الدخول غير صحيحة');
    } catch (e) {
      showToast(message: 'حدث خطأ: $e');
    }
  }

  void signInWithGoogle() async {
    try {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      final FirebaseAuth _auth = FirebaseAuth.instance;
      UserCredential userCredential = await _auth.signInWithPopup(authProvider);

      String uid = userCredential.user!.uid;
      String? email = userCredential.user?.email;
      String? username = userCredential.user?.displayName;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      // إذا المستخدم موجود بالفعل
      if (userDoc.exists) {
        // تحويل البيانات إلى UserModel
        UserModel existingUser = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

        // تخزين UID في shared
        shared.id_user = uid;
        await updateUserLogin();
        await updateUserLogin();
        // الذهاب إلى MainHome
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainHome()),
        );
      } else {
        final shataID = await getNextShataID();
        // المستخدم غير موجود - نضيفه
        UserModel newUser = UserModel(
          uid: uid,
          username: username ?? '',
          email: email ?? '',
          login: "1",
          play_computer: "0",
          wins: "0",
          phone_number: "",
          level: "مبتدئ",
          password: "",
          name: username ?? '',
          bio: '',
          profileImageUrl: '',
          bannerImageUrl: '',
          followers: [],
          following: [],
          isBanned: false,
          online: false,
          WChessId: 0,
          ShataID: shataID,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set(newUser.toMap());

        shared.id_user = uid;

        // الذهاب إلى MainHome
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainHome()),
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



  Widget _buildTimeContainer(String time, String label) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3), // تغير موضع الظل
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SelectableText(
            time,
            style: TextStyle(fontFamily: 'Schyler', fontSize: 12),
          ),
          SizedBox(height: 5), // مسافة بين الرقم والتسمية
          SelectableText(
            label,
            style: TextStyle(fontFamily: 'Schyler', fontSize: 19, color: Colors.black87,fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }


  Widget _buildSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SelectableText(
        ':',
        style: TextStyle(fontFamily: 'Schyler', fontSize: 30),
      ),
    );
  }
}



