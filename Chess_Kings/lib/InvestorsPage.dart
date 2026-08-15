import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'FeedScreen.dart';
import 'MainHome.dart';

class InvestorsPage  extends StatelessWidget {
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
              SizedBox(height:35),


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
                            SizedBox(height: 15), // يمكنك إزالة هذا الـ SizedBox إذا لم يكن ضروريًا
                            Flexible(
                              child: SelectableText(
                                "  فرصة فريدة لنمو مستدام –",
                                style: TextStyle(
                                  color: Color(0xFF472F6B),
                                  fontSize: 25, // ضبط حجم الخط بناءً على عرض الشاشة
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Schyler',
                                ),
                                textAlign: TextAlign.center, // توسيط النص
                              ),
                            ),
                            SizedBox(width: 5),
                            Flexible(
                              child: SelectableText(
                                "الاستثمار في شطرنج شطارة",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25, // ضبط حجم الخط بناءً على عرض الشاشة
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Schyler',
                                ),
                                textAlign: TextAlign.center, // توسيط النص
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.all(35.0), // تقليل الهوامش
                          child: Center(
                            child: SelectableText(
                              " إذا كنت تبحث عن فرصة استثمارية مبتكرة في عالم الألعاب والرياضات الذهنية، فإن شطرنج شطارة يقدم لك خيارات استثمارية متنوعة تحقق لك عوائد مستدامة ",
                              style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold,fontFamily: 'Schyler',),
                              // ضبط حجم النص
                              textAlign: TextAlign.center, // محاذاة النص
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),


              SizedBox(height: 15,),
              Center(
                child: SelectableText(
                  " لماذا الأستثمار في شطاره ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30, // تقليل حجم الخط
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Schyler',
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: buildContainer(context, 'ابتكار سعودي مسجّل في هيئة الملكية الفكرية، معترف به كمنتج استراتيجي', FontAwesomeIcons.lightbulb),
                        ),
                        Flexible(
                          child: buildContainer(context, ' نموذج أعمال متكامل يشمل المنتجات الرقمية والمادية والبطولات ', Icons.photo),
                        ),
                        Flexible(
                          child: buildContainer(context,  ' قاعدة جماهيرية متزايدة من لاعبي الشطرنج التقليديين والمهتمين بالابتكار',  Icons.people),
                        ),
                        Flexible(
                          child: buildContainer(context,  '  فرص استثمار متعددة تناسب مختلف القطاعات، من التجزئة إلى الرياضات الإلكترونية', Icons.account_balance),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 35,),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9, // عرض الحاوية الرئيسية بنسبة 90% من عرض الشاشة
                  color: Colors.grey[300], // لون الخلفية للحاوية الرئيسية
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround, // توزيع الحاويتين
                    children: [
                      // الحاوية الأولى
                      Container(
                        //height: 400,
                        width: MediaQuery.of(context).size.width * 0.55, // عرض الحاوية الأولى
                        color: Colors.white, // لون الخلفية للحاوية الأولى
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end, // محاذاة التعدادات لليمين
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: SelectableText(
                                      'سواء كنت مستثمرًا فرديًا، أو رائد أعمال، أو شركة مهتمة بالتوسع في قطاع الألعاب، فإن شطارة توفر لك بيئة استثمارية مرنة تحقق أهدافك المالية والتجارية ',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'Schyler',),
                                      textAlign: TextAlign.right, // محاذاة النص لليمين
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Image.asset('assets/icon.png'), // الأيقونة
                              ],
                            ),
                            SizedBox(height: 10), // مسافة بين التعدادات
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: SelectableText(
                                      'info@shatarachess.comللتواصل والاستفسار عن فرص الاستثمار، يمكنك التواصل معنا عبر  البريد الإلكتروني',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'Schyler',),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Image.asset('assets/icon.png'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // الحاوية الثانية
                      Container(
                        //height: 400,
                        width: MediaQuery.of(context).size.width * 0.35, // عرض الحاوية الثانية
                        color: Colors.white, // لون الخلفية للحاوية الثانية
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SelectableText(
                              'كيف يمكنك الاستثمار مع',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                fontFamily: 'Schyler',
                              ),
                            ),
                            SizedBox(width: 5),
                            SelectableText(
                              'شطارة',
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Schyler',
                                fontSize: 35,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              ),
              SizedBox(height: 35,),

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SelectableText(
                      "سبل الاستثمار المتاحة",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 35, // ضبط حجم الخط بناءً على عرض الشاشة
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 5), // تقليل المسافة بين العنوان والشرح
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: buildContainern(context,  'الاستثمار في المنتجات (المادي أو الرقمي)',  FontAwesomeIcons.coins,'فرصة توزيع وبيع رقعة شطرنج شطارة والملحقات الحصرية','الدخول في شراكة كـ تاجر تجزئة لبيع المنتج في الأسواق والمتاجر الإلكترونية','دعم تطوير المنتجات الرقمية والتطبيقات الذكية الخاصة باللعبة'),
                        ),
                        Flexible(
                          child: buildContainern(context, ' الاستثمار في المبيعات والتسويق ',     FontAwesomeIcons.chartLine,'دعم عمليات التسويق لزيادة انتشار اللعبة عالميًا','المساهمة في الترويج والتوزيع محليًا ودوليًا','بناء شراكات مع متاجر الألعاب وشركات التجارة الإلكترونية'),
                        ),
                        Flexible(
                          child: buildContainern(context, 'الاستثمار في البطولات والمنافسات',    FontAwesomeIcons.trophy ,'رعاية بطولات شطرنج شطارة والحصول على حقوق الرعاية والإعلان','دعم الجوائز والمكافآت لجذب اللاعبين المحترفين','الاستثمار في إنشاء دوري رسمي للعبة وجذب الرعاة الإعلاميين'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25,),


              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9, // عرض الحاوية الرئيسية بنسبة 90% من عرض الشاشة
                  color: Colors.grey[300], // لون الخلفية للحاوية الرئيسية
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround, // توزيع الحاويتين
                    children: [
                      // الحاوية الثانية
                      Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width * 0.35, // عرض الحاوية الثانية
                        color: Colors.white, // لون الخلفية للحاوية الثانية
                        child: Image.asset('assets/logo_s.png'),
                      ),
                      // الحاوية الأولى
                      Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width * 0.55, // عرض الحاوية الأولى
                        color: Colors.white, // لون الخلفية للحاوية الأولى
                        child: Padding(
                          padding: const EdgeInsets.all(35.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end, // محاذاة التعدادات لليمين
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: SelectableText(
                                      'تواصل معنا ',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25,fontFamily: 'Schyler',),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: SelectableText(
                                      'invest@shatara.com',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'Schyler',),
                                      textAlign: TextAlign.right, // محاذاة النص لليمين
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.mail_outline)
                                ],
                              ),
                              SizedBox(height: 10), // مسافة بين التعدادات
                              Row(
                                children: [
                                  Expanded(
                                    child: SelectableText(
                                      '4567 123 55 966+ ',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'Schyler',),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.phone),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: SelectableText(
                                      'www.shatara.com',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'Schyler',),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Image.asset('assets/icon_web.png'),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
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
          )),
    );
  }
  Widget buildContainer(BuildContext context, String title,  IconData icon_url) {
    return Container(
      width: 350,
      margin: EdgeInsets.symmetric(horizontal: 5.0), // إضافة هوامش للحاوية
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
              icon_url,
              size: 65,
              color: Colors.deepPurple
          ),
          SizedBox(height: 15),
          SelectableText(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: 'Schyler',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }


  Widget buildContainern(BuildContext context, String title, IconData icon_url, String txt1, String txt2,String txt3) {
    return Container(
      width: 350,
      margin: EdgeInsets.symmetric(horizontal: 5.0), // إضافة هوامش للحاوية
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
              icon_url,
              size: 65,
              color: Colors.deepPurple
          ),
          SizedBox(height: 15),
          SelectableText(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: 'Schyler',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10), // مسافة بين العنوان والتعدادات
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // توسيط العناصر عموديًا
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // توسيط العناصر أفقيًا
                children: [
                  Expanded(child: SelectableText(txt1, textAlign: TextAlign.center)), // توسيط النص
                  Icon(Icons.star, color: Colors.deepPurple),
                ],
              ),
              SizedBox(height: 10), // مسافة بين التعدادات
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // توسيط العناصر أفقيًا
                children: [
                  Expanded(child: SelectableText(txt2, textAlign: TextAlign.center,)), // توسيط النص
                  Icon(Icons.star, color: Colors.deepPurple),
                ],
              ),
              SizedBox(height: 10), // مسافة بين التعدادات
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // توسيط العناصر أفقيًا
                children: [
                  Expanded(child: SelectableText(txt3, textAlign: TextAlign.center)), // توسيط النص
                  Icon(Icons.star, color: Colors.deepPurple),
                ],
              ),
            ],
          )


        ],
      ),
    );
  }


}
