import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'FeedScreen.dart';
import 'MainHome.dart';


class PrivacyPolicyPage extends StatelessWidget {
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
              SizedBox(height: 5),
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
                                "  شطرنج شطارة –",
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
                                " سياسة الخصوصية ",
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
                          padding: const EdgeInsets.all(15.0), // تقليل الهوامش
                          child: Center(
                            child: SelectableText(
                              " مرحبًا بك في شطرنج شطارة، حيث نحرص على حماية بياناتك وخصوصيتك عند استخدام منصتنا. نحن نلتزم بتوفير بيئة آمنة تضمن لك تجربة سلسة دون المساس بسرية معلوماتك الشخصية باستخدامك لمنصة شطرنج شطارة، فإنك توافق على سياسة الخصوصية هذه. إذا كنت لا توافق على أي من بنودها، يُرجى التوقف عن استخدام المنصة",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Schyler',
                              ),
                              textAlign: TextAlign.center, // محاذاة النص
                              maxLines: 2, // تحديد الحد الأقصى لعدد الأسطر
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8,8,75,8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SelectableText(
                      'المعلومات التي تقدمها لنا مباشرة',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10), // مسافة بين العنوان والنقاط
                    BulletPoint(' معلومات الحساب: مثل اسم المستخدم، البريد الإلكتروني، كلمة المرور، والصورة الشخصية'),
                    BulletPoint('معلومات الملف الشخصي: مثل الدولة، العمر، التفضيلات، والتصنيفات في اللعبة'),
                    BulletPoint(' المحتوى الذي تشاركه: مثل المنشورات، التعليقات، الرسائل الخاصة، وتحليلات المباريات'),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8,8,75,8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SelectableText(
                      'المعلومات التي يتم جمعها تلقائيًا',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10), // مسافة بين العنوان والنقاط
                    BulletPoint('بيانات الاستخدام: مثل سجل المباريات، الوقت المستغرق في اللعب، التفاعلات مع المستخدمين الآخرين'),
                    BulletPoint(' معلومات الجهاز: نوع الجهاز، نظام التشغيل، عنوان IP، المتصفح المستخدم'),
                    BulletPoint('ملفات تعريف الارتباط (Cookies): تُستخدم لتحسين تجربة المستخدم، تخزين تفضيلاتك، وتحليل الأداء'),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8,8,75,8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SelectableText(
                      'كيف نستخدم معلوماتك',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10),
                    SelectableText(
                      'نحن نستخدم بياناتك فقط لتحسين تجربتك وضمان أمان المنصة، ومن ذلك',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10),// مسافة بين العنوان والنقاط
                    BulletPoint('تحسين تجربة اللعب وتحليل أسلوب اللعب لمساعدتك على التطور'),
                    BulletPoint('إدارة البطولات وتصنيف اللاعبين لتوفير منافسات عادلة'),
                    BulletPoint(' إرسال الإشعارات والتحديثات المهمة حول البطولات والمستجدات في شطرنج شطارة'),
                    BulletPoint('تحليل البيانات لفهم تفاعل المستخدمين وتحسين الخدمات'),
                    BulletPoint('حماية أمان المنصة ومنع الغش أو أي نشاط غير قانوني'),
                    BulletPoint(' دعم وتطوير شبكة تواصل شطارة وتخصيص المحتوى لك بناءً على اهتماماتك'),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8,8,75,8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SelectableText(
                      'من يمكنه الوصول إلى معلوماتك؟',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10),
                    SelectableText(
                      'نحن لا نبيع أو نشارك بياناتك الشخصية مع أي جهة خارجية إلا في الحالات التالية',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10), /// مسافة بين العنوان والنقاط
                    BulletPoint(' إذا كان ذلك مطلوبًا قانونيًا – في حال طلب الجهات الحكومية أو القضائية ذلك بموجب القوانين المحلية'),
                    BulletPoint('لحماية أمان المستخدمين والمنصة – إذا اكتشفنا أي نشاط مشبوه أو احتيالي'),
                    BulletPoint(' لتقديم الخدمات عبر شركاء موثوقين – مثل مقدمي خدمات الدفع أو تحليلات الأداء، مع ضمان التزامهم بسياسات الخصوصية الصارمة'),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8,8,75,8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SelectableText(
                      ' حقوقك في التحكم ببياناتك',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10),
                    SelectableText(
                      'يمكنك في أي وقت',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10), // مسافة بين العنوان والنقاط
                    BulletPoint('الوصول إلى بياناتك والاطلاع على المعلومات التي جمعناها عنك'),
                    BulletPoint('تعديل أو تحديث معلوماتك الشخصية من خلال إعدادات الحساب'),
                    BulletPoint('طلب حذف حسابك وبياناتك نهائيًا إذا لم تعد ترغب في استخدام المنصة'),
                    BulletPoint(' إدارة إشعارات البريد الإلكتروني والإعلانات من خلال إعدادات الخصوصية'),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8,8,75,8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SelectableText(
                      'حماية بياناتك وأمان المعلومات',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10), // مسافة بين العنوان والنقاط
                    SizedBox(height: 10),
                    SelectableText(
                      ' نحن نتخذ إجراءات أمنية مشددة لحماية بيانات المستخدمين، بما في ذلك',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    BulletPoint('تشفير البيانات الحساسة لضمان عدم تسريبها'),
                    BulletPoint('تحديثات أمان دورية لحماية النظام من أي تهديدات'),
                    BulletPoint(' مراقبة النشاطات المشبوهة واتخاذ الإجراءات اللازمة فورًا'),
                    BulletPoint('ومع ذلك، نذكّرك بأن أمان بياناتك يعتمد أيضًا على حمايتك لمعلومات تسجيل الدخول الخاصة بك، لذا لا تشارك كلمة مرورك مع أي شخص آخر'),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8,8,75,8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SelectableText(
                      'ملفات تعريف الارتباط (Cookies)  وتقنيات التتبع',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10), // مسافة بين العنوان والنقاط
                    SelectableText(
                      'نحن نستخدم ملفات تعريف الارتباط (Cookies) لتحسين تجربتك في شطرنج شطارة، عبر',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10), // مسافة بين العنوان والنقاط
                    BulletPoint(' تذكر تفضيلاتك وإعداداتك الشخصية'),
                    BulletPoint('تحليل الأداء وتقديم محتوى مخصص لك'),
                    BulletPoint('تحسين سرعة وأداء الموقع والتطبيق'),
                    BulletPoint('يمكنك إدارة أو تعطيل ملفات تعريف الارتباط من إعدادات المتصفح، ولكن قد يؤثر ذلك على بعض وظائف المنصة'),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8,8,75,8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SelectableText(
                      'التواصل والدعم',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10), // مسافة بين العنوان والنقاط
                    BulletPoint('     info@shatarachess.comإذا كانت لديك أي استفسارات حول شروط الاستخدام أو واجهت أي مشكلة في المنصة، يمكنك التواصل معنا عبر البريد الإلكتروني '),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8,8,8,8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SelectableText(
                      ' التعديلات على سياسة الخصوصية',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10), // مسافة بين العنوان والنقاط
                    SelectableText(
                      'قد نقوم بتحديث هذه السياسة من وقت لآخر، وسيتم إعلام المستخدمين بأي تغييرات جوهرية عبر البريد الإلكتروني أو الإشعارات داخل المنصة',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
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

  Widget BulletPoint(String text) {
    return Row(
      children: [
        Expanded(child: SelectableText(text, style: TextStyle(fontSize: 20,color: Colors.black54,fontFamily: 'Schyler',), textAlign: TextAlign.right,)),
        SizedBox(width: 8),
        SelectableText('• ', style: TextStyle(fontSize: 25,color: Colors.black,fontFamily: 'Schyler',)), // الرمز النقطي
      ],
    );
  }

}
