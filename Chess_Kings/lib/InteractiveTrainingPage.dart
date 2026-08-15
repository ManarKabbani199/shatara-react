import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'FeedScreen.dart';
import 'MainHome.dart';


class InteractiveTrainingPage extends StatelessWidget {
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
                            SizedBox(height: 15),
                            Text(
                              "التطوير",
                              style: TextStyle(
                                color: Color(0xFF472F6B),
                                fontSize: 35, // تقليل حجم الخط
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              "الصفحه قيد ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30, // تقليل حجم الخط
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 55),

                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity, // يأخذ كامل عرض الشاشة// يمكنك تعديل الارتفاع حسب الحاجة
                child: Image.asset(
                  'assets/second_banner.jpg', // تأكد من وضع المسار الصحيح للصورة
                  width: 550,
                  height: 450,// يمكنك استخدام BoxFit.fill أو BoxFit.contain حسب الحاجة
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
                            Text(
                              'شطاره',
                              style: TextStyle(
                                color: Color(0xFF472F6B),
                                fontSize: MediaQuery.of(context).size.width < 600 ? 35 : 40,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(width: 8), // إضافة مساحة بين النصين
                            Text(
                              'من وراء ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'هدفنا هو جلب الشطرنج معك إلى كل مكان بتصميم عصري وسهل الاستخدام لتجربة لعب مختلفة و ممتعة ',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
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
          )),
    );
  }

}
