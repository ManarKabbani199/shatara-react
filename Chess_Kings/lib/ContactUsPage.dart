import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'FeedScreen.dart';
import 'MainHome.dart';
import 'global/common/toast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:emailjs/emailjs.dart' as emailjs;


class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainHome()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                      child: Icon(
                        Icons.settings,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Image.asset(
                      'assets/ic.png',
                      fit: BoxFit.cover,
                      height: 50,
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
                          MaterialPageRoute(builder: (context) => FeedScreen()),
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
            SizedBox(height: 35),
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 11.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 5),
                          Text(
                            "شطارة",
                            style: TextStyle(
                              color: Color(0xFF472F6B),
                              fontSize: 35, // تقليل حجم الخط
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "اتصل ب",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30, // تقليل حجم الخط
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'الأسم',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                          textAlign: TextAlign.right, // محاذاة النص إلى اليمين
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextField(
                            controller: _nameController,
                            textAlign: TextAlign.right, // محاذاة الكتابة إلى اليمين
                            decoration: InputDecoration(
                              labelText: 'الاسم بالكامل',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          'بريدك الألكتروني',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                          textAlign: TextAlign.right, // محاذاة النص إلى اليمين
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextField(
                            controller: _emailController,
                            textAlign: TextAlign.right, // محاذاة الكتابة إلى اليمين
                            decoration: InputDecoration(
                              labelText: 'بريدك الإلكتروني',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          'رسالتك',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                          textAlign: TextAlign.right, // تغيير إلى اليمين
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextField(
                            controller: _messageController,
                            textAlign: TextAlign.right, // محاذاة الكتابة إلى اليمين
                            decoration: InputDecoration(
                              labelText: 'ماهو استفسارك عن شطارة لكي نستطيع مساعدتك؟',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 4, // يسمح بإدخال نص متعدد الأسطر
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9, // عرض الزر 80% من عرض الشاشة
                        height: 45, // ارتفاع الزر 75
                        child: ElevatedButton(
                          onPressed: () {
                            sendEmail();
                            print("تم الضغط على زر الإرسال");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF472F6B), // لون الزر
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // حواف دائرية
                            ),
                            shadowColor: Colors.black.withOpacity(0.2), // لون الظل
                            elevation: 5, // مقدار الظل
                          ),
                          child: Text(
                            'إرسال',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15,),
            Text(
              'حقوق النشر @ شطارة 2025',
              textAlign: TextAlign.center, // محاذاة النص في المنتصف
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 13),
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
    );
  }
  Future<void> sendEmail() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String message = _messageController.text;

    RegExp nameExp    = RegExp(r'^[a-zA-Zا-ي\s]*$');
    if (!(nameExp.hasMatch(name))) {
      showToast(message: 'فقط يسمح لك بأدخال الحروف');
    } else if (!(EmailValidator.validate(email))) {
      showToast(message: "الايميل خاطئ");
    } else if (message.length<25) {
      showToast(message: 'ادخل نص الرسالة');
    } else {
      try{
      await emailjs.send(
        'service_rripnu8',
        'template_zo2afse',
        {
          'from_name': 'Manar',
          'from_email': 'Manar@hotmail.com', // بريد المرسل
          'message': "From: $name \n  Email: $email  \n  $message",
        },
        const emailjs.Options(
            publicKey: 'ccHs5ndU-FROXidlm',
            privateKey: '22KQa7mGhjWfYX05iUJv',
            limitRate: const emailjs.LimitRate(
              id: 'app',
              throttle: 10000,
            )),
      );
      showToast(message:'تم أرسال الأيميل بنجاح');
    } catch (error) {
    if (error is emailjs.EmailJSResponseStatus) {
      showToast(message:'حدث خطأ حاول مره أخرى');
    }
    }

    }
  }

  String encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
