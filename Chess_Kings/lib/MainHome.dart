import 'package:Chess_Cleverness/screens/Admin/AdminDashboardScreen.dart';
import 'package:Chess_Cleverness/screens/Tweet/create_tweet_screen.dart';
import 'package:Chess_Cleverness/screens/Tweet/followers_screen.dart';
import 'package:Chess_Cleverness/screens/Tweet/profile_screen.dart';
import 'package:Chess_Cleverness/screens/Tweet/tweets_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'FeedScreen.dart';
import 'ContactUsPage.dart';
import 'CopyrightPage.dart';
import 'PartnershipsPage.dart';
import 'PrivacyPolicyPage.dart';
import 'ShataraRulesPage.dart';
import 'screens/AboutPage.dart';
import 'InvestorsPage.dart';
import 'SignUpPage.dart';
import 'SupportersPage.dart';
import 'TermsPage.dart';
import 'UsersProfilePage.dart';
import 'TournamentsPage.dart';
import 'LessonsPage.dart';
import 'InteractiveTrainingPage.dart';
import 'AIToolsPage.dart';
import 'VideoPage.dart';
import 'AdvancedStrategiesPage.dart';
import 'Widget/TweetsPage/AllTweetsScreen.dart';
import 'main.dart';
import 'shared_data.dart' as shared;







class MainHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'شطرنج شطاره',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedLevel;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController_l = TextEditingController();
  final TextEditingController passwordController_l = TextEditingController();
  String? selectedCountryCode = '+966'; // رمز الدولة الافتراضي (مثل السعودية)

  RegExp nameExp    = RegExp(r'^[a-zA-Zا-ي\s]*$');
  RegExp passExp    = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  bool isSigningUp  = false;
  bool _obscureText = true;


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
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView( // إضافة SingleChildScrollView هنا
          child: Column(
            children: [
              Container(
                height: 75,
                decoration: BoxDecoration(
                  color: Color(0xFFFDFFFF),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // تعديل لتوزيع العناصر
                  children: [
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16), // تعديل المسافة
                        child: Icon(
                          Icons.menu,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),



                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16), // تعديل المسافة
                      child: Image.asset(
                        'assets/ic.png', // تأكد من وضع المسار الصحيح للصورة
                        fit: BoxFit.cover, // يمكنك استخدام BoxFit.fill أو BoxFit.contain حسب الحاجة
                        height: 50, // تحديد ارتفاع الصورة
                      ),
                    ),
                  ],
                ),

              ),
              Container(
                height: 75,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(width: 25,),
                      MenuItem(
                        title: "شبكة التواصل",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TweetsScreen()),
                          );
                        },
                      ),
                      MenuItem(
                        title: "المتجر",
                        onTap: () {
                          // إضافة منطق الانتقال إلى صفحة المتجر هنا
                        },
                      ),
                      MenuItem(
                        title: "العب الآن",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainHome()),
                          );
                        },
                      ),
                      MenuItem(
                        title: "الرئيسية",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainHome()),
                          );
                        },
                      ),
                      SizedBox(width: 25,),
                    ],
                  ),
                ),

              ),
              const SizedBox(height: 35),
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // السماح للنمو العمودي فقط
                      children: [
                        SelectableText(
                          " مرحبا بكم في شطرنج",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25, // تقليل حجم الخط
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Schyler',
                          ),
                        ),
                        SizedBox(height: 10,),
                        SelectableText(
                          "شطارة",
                          style: TextStyle(
                            color: Color(0xFF472F6B),
                            fontSize: 45, // تقليل حجم الخط
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Schyler',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                // الصف الأول
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: buildContainer(context, 'assets/l_con.png', 'العب مع الذكاء', 'واجه الذكاء الاصطناعي بمستويات صعوبة مختلفة تناسب جميع اللاعبين', _funChessPage, 'ألعب مع الذكاء '),
                    ),
                    Flexible(
                      child: buildContainer(context, 'assets/c_con.png', 'مباريات تنافسية', 'خض تجربة تنافسية ضد لاعبين محترفين', _funChessPage, 'خض المنافسة الآن'),
                    ),
                    Flexible(
                      child: buildContainer(context, 'assets/n_con.png', 'تحدَّ أصدقائك', 'اختبر مهاراتك في الشطرنج بمواجهة أصدقائك في مباريات مشوقة وممتعة.', _funFeedScreen, 'ابدأ التحدي الآن'),
                    ),
                  ],
                ),
                SizedBox(height: 25), // مساحة بين الصفين
                // الصف الثاني
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: buildContainer(context, 'assets/f_con.png', 'تعلم واستمتع', 'طور مهاراتك في الشطرنج من خلال دروس متقدمة ونصائح عملية مقدمة من خبراء', _funChessPage, 'ابدأ التعلم الآن'),
                    ),
                    Flexible(
                      child: buildContainer(context, 'assets/s_con.png', 'سوق شطارة', 'اكتشف مجموعة مميزة من منتجات شطارة وملحقات الشطرنج!', _funChessPage, 'ابدأ التسوق الآن'),
                    ),
                    Flexible(
                      child: buildContainer(context, 'assets/m_con.png', 'تواصل وشارك', 'تواصل مع لاعبين من أنحاء العالم وشارك تجربتك الفريدة مع شطارة',
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TweetsScreen()),
                          );
                        },
                        'تواصل مع الآخرين',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
              SizedBox(height: 25,),
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
                      SizedBox(height: 5),
                      Image.asset(
                        'assets/logo_s.png', // تأكد من وضع المسار الصحيح للصورة
                        fit: BoxFit.cover, // يمكنك استخدام BoxFit.fill أو BoxFit.contain حسب الحاجة
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // لتوسيع العناصر في المنتصف أفقياً
                          crossAxisAlignment: CrossAxisAlignment.center, // لتوسيع العناصر في المنتصف عمودياً
                          children: [
                            SelectableText(
                              'شطاره',
                              style: TextStyle(
                                color: Color(0xFF472F6B),
                                fontSize: MediaQuery.of(context).size.width < 600 ? 35 : 40,
                                fontFamily: 'Schyler',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(width: 8), // إضافة مساحة بين النصين
                            SelectableText(
                              'من وراء ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Schyler',
                                fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      SelectableText(
                        'هدفنا هو جلب الشطرنج معك إلى كل مكان بتصميم عصري وسهل الاستخدام لتجربة لعب مختلفة و ممتعة ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Schyler',
                          fontSize: MediaQuery.of(context).size.width < 600 ? 19 : 15
                        ),
                        textAlign: TextAlign.center,
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
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 13,fontFamily: 'Schyler',),
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
        drawer: MainMenu(),
      );

  }





  void _funChessPage() async {
    Navigator.push(
      context, // هنا السياق صالح
      MaterialPageRoute(builder: (context) => MainHome()),
    );
  }

  void _funFeedScreen() async {
    Navigator.push(
      context, // هنا السياق صالح
      MaterialPageRoute(builder: (context) => FeedScreen()),
    );
  }





  Widget buildContainer(BuildContext context, String imageUrl, String title, String description, Function onPressed, String buttonText) {
    return Container(
      width: 350,
      margin: EdgeInsets.symmetric(horizontal: 5.0), // إضافة هوامش للحاوية
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imageUrl,
            height: 80,
          ),
          SizedBox(height: 15),
          SelectableText(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
              fontFamily: 'Schyler',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          SelectableText(
            description,
            style: TextStyle(
              color: Colors.deepPurple,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: 'Schyler',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: ()  => onPressed(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF0E6D1), // لون الزر
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // حواف دائرية
              ),
            ),
            child: Text(buttonText,
              style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}


class MenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  MenuItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 1),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF472F6B),
            ),
            child: const Text(
              'القائمة الرئيسية',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
          ExpansionTile(
            title: const Text('الإعدادات الشخصية'),
            leading: const Icon(Icons.settings),
            children: [
              if (shared.id_user != null && shared.id_user.isNotEmpty) ...[
                ListTile(
                  title: Text('إعدادات الحساب'),
                  leading: const Icon(Icons.edit),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(userId: shared.id_user),
                      ),
                    );
                  },
                ),
              ] else ...[
                ListTile(
                  title: Text('تسجيل الدخول أو إنشاء حساب'),
                  leading: const Icon(Icons.login),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                ),
              ],
            ]
          ),

          ExpansionTile(
            title: const Text('شبكة التواصل'),
            leading: const Icon(Icons.people_alt),
            children:[
              if (shared.id_user != null && shared.id_user.isNotEmpty) ...[
                ListTile(
                  title: Text('عرض جميع المستخدمين'),
                  leading: const Icon(Icons.people_alt),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FollowersScreen(title: 'جميع المستخدمين'),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('إنشاء مشاركة'),
                  leading: const Icon(Icons.create),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateTweetScreen()),
                    );
                  },
                ),
              ],
            ListTile(title: Text('الرئبسيه'),leading: const Icon(Icons.create),onTap: (){
                //showToast(message: shared.id_user);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TweetsScreen(),));
              },),
              ListTile(title: Text('عرض المشاركات'),leading: const Icon(Icons.create),onTap: (){
                //showToast(message: shared.id_user);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllTweetsScreen(),));
              },),
            ],
          ),
          ExpansionTile(
            title: const Text('المتجر'),
            leading: const Icon(Icons.store),
            children: [
              ListTile(title:Text('تسوق'),leading: const Icon(Icons.shopping_cart),onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminDashboardScreen(adminName:shared.username)));
              },),
            ],
          ),
          ExpansionTile(
            title: const Text('عن اللعبة'),
            leading: const Icon(Icons.info),
            children: [
              ListTile(title:Text('شطاره'),leading: const Icon(Icons.star),onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutPage()));
              },),
              ListTile(title: Text('استثمار'),leading: const Icon(Icons.attach_money),onTap:(){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InvestorsPage()));
              },),
            ],
          ),
          ExpansionTile(
            title: const Text('المجتمع'),
            leading: const Icon(Icons.group),
            children:[
              ListTile(title: Text('نقاشات عامة'),leading: const Icon(Icons.chat),onTap:() {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UsersProfilePage()));
              },),
              ListTile(title: Text('بطولات ودعوات'),leading: const Icon(Icons.star),onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TournamentsPage()));
              },),
            ],
          ),

          ExpansionTile(
            title: const Text('المحتوى التعليمي و التدريبي'),
            leading: const Icon(Icons.school),
            children:[
              ListTile(title: Text('استراتجيات شطارة'),leading: const Icon(Icons.games),onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LessonsPage()));
              },),
              ListTile(title: Text('تدريبات تفاعليه'),leading: const Icon(Icons.touch_app),onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InteractiveTrainingPage()));
              },),
              ListTile(title: Text('أدوات بالذكاء الاصطناعي'),leading: const Icon(Icons.computer),onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AIToolsPage()));
              },),
              ListTile(title: Text('شرح القواعد الأساسية'),leading: const Icon(Icons.rule),onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShataraRulesPage()));
              },),
              ListTile(title: Text('استراتيجيات متقدمة'),leading: const Icon(Icons.trending_up),onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdvancedStrategiesPage()));
              },),
              ListTile(title: Text('أمثلة فيديو'),leading: const Icon(Icons.video_library),onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VideoPage()));
              },),
            ],
          ),
          ExpansionTile(
            title: const Text('الشروط و السياسات'),
            leading: const Icon(Icons.support),
            children:[
              ListTile(title: Text('شروط الاستخدام'),leading: const Icon(Icons.rule),onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TermsPage()));
              },),
              ListTile(title: Text('سياسة الخصوصية'),leading: const Icon(Icons.privacy_tip),onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrivacyPolicyPage()));
              },),
              ListTile(title: Text('حقوق النشر'),leading: const Icon(Icons.book),onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CopyrightPage()));
              },),
            ],
          ),
          ExpansionTile(
            title: const Text('الشراكات'),
            leading: const Icon(Icons.business),
            children:[
              ListTile(title: Text(' الشراكات الحاليه'),leading: const Icon(Icons.group),onTap:() {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PartnershipsPage()));
              },),
              ListTile(title: Text('الداعمين'),leading: const Icon(Icons.people),onTap:() {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SupportersPage()));
              },),
            ],
          ),
          ExpansionTile(
            title: const Text('الدعم الفني'),
            leading: const Icon(Icons.support),
            children:[
              ListTile(title: Text('اتصل بنا'),leading: const Icon(Icons.contact_mail),onTap:() {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactUsPage()));
              },),

            ],
          ),
          if (shared.id_user != null && shared.id_user.isNotEmpty) ...[
              ListTile(title: Text('تسجيل الخروج'),leading: const Icon(Icons.logout),onTap:() {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainHome()));
              },),
          ]
            ],
          ),

    );
  }
}



