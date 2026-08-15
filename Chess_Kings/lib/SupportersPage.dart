import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'FeedScreen.dart';
import 'MainHome.dart';


class SupportersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF7FF),
      body: SingleChildScrollView(
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
                  // تعديل لتوزيع العناصر
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
                        // تعديل الهوامش
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
                              "الحالية ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30, // تقليل حجم الخط
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 15),
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
                              "الشركات",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30, // تقليل حجم الخط
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(35.0), // تقليل الهوامش
                          child: Text(
                            "تعتبر الشراكات ركيزة أساسية لتطوير لعبة شطارة. نسعى دائما للتعاون مع مؤسسات وأفراد لتحقيق أهدافنا المشتركة",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            // ضبط حجم النص
                            textAlign: TextAlign.center, // محاذاة النص
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8,8,75,8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'العمل على شراكات جديدة',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10), // مسافة بين العنوان والنقاط
                    BulletPoint('يجري حاليا العمل على بناء شراكات جديدة مع مؤسسات تعليمية، شركات تقنية، ومراكز ابتكار لتعزيز تجربة اللاعبين وتوسيع نطاق اللعبة عالميا'),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8,8,75,8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'أهداف الشراكات ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10), // مسافة بين العنوان والنقاط
                    BulletPoint('تطوير ميزات جديدة ومبتكرة داخل اللعبة'),
                    BulletPoint('تنظيم بطولات شطرنج عالمية بالتعاون مع شركاء'),
                    BulletPoint('تعزيز التجربة التعليمية والابتكارية في اللعبة'),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8,8,75,8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'شراكات قيد المناقشة',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10), // مسافة بين العنوان والنقاط
                    BulletPoint('التعاون مع شركات تقنية لتطوير الذكاء الاصطناعي في اللعبة'),
                    BulletPoint('العمل مع الجامعات الإدخال شطارة كأداة تعليمية تعزز التفكير الاستراتيجي'),
                    BulletPoint('التعاون مع مراكز الذكاء الاصطناعي لدراسة وتحليل سلوك اللاعبين'),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8,8,75,8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'فوائد التعاون',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10), // مسافة بين العنوان والنقاط
                    BulletPoint('الوصول إلى جمهور واسع من محبي الألعاب والشطرنج'),
                    BulletPoint('التميز في سوق الألعاب الرقمية من خلال شراكة مع لعبة مبتكرة'),
                    BulletPoint('فرصة للترويج لمنتجات أو خدمات عبر مجتمع شطارة'),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8,8,75,8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'وسائل التواصل',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10), // مسافة بين العنوان والنقاط
                    BulletPoint('للاستفسارات حول الشراكات، يرجى التواصل معنا عبر البريد الإلكتروني partnerships@shatara.com '),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.all(35.0), // استخدام Padding موحد
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8, // 70% من عرض الشاشة
                  decoration: BoxDecoration(
                    color: Color(0xFFf0e6d1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // استخدام MainAxisSize.min لتقليل المساحة المستخدمة
                    children: [
                      SizedBox(height: 25),
                      Container(
                        child: Text(
                          'دعوة لشركات المستقبلية',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: MediaQuery.of(context).size.width < 600 ? 25 : 30,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Text(
                          ' نحن في شطارة نبحث دائما عن شركاء يشاركوننا رؤيتنا وطموحنا. إذا كنت ترغب في أن تكون جزءًا من هذه الرحلة، نرحب بك للتواصل معنا ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width < 600 ? 19 : 15
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0), // استخدام Padding موحد
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8, // 70% من عرض الشاشة
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // استخدام MainAxisSize.min لتقليل المساحة المستخدمة
                    children: [
                      Container(
                        child: Text(
                          'رسالة تشجيعية',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: MediaQuery.of(context).size.width < 600 ? 25 : 30,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Text(
                          ' نحن نؤمن بأن النجاح يتحقق بالعمل الجماعي. دعمكم مهما كان حجمه يلعب دورًا كبيرًا في تحقيق رؤيتنا المستقبلية ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width < 600 ? 19 : 15
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 45,),
                    ],
                  ),
                ),
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
          )
      ),
    );
  }

  Widget BulletPoint(String text) {
    return Row(
      children: [
        Expanded(child: Text(text, style: TextStyle(fontSize: 20,color: Colors.black54), textAlign: TextAlign.right,)),
        SizedBox(width: 8),
        Text('• ', style: TextStyle(fontSize: 25,color: Colors.black,)), // الرمز النقطي
      ],
    );
  }

}
