import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'FeedScreen.dart';
import 'MainHome.dart';


class CopyrightPage extends StatelessWidget {
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
                                " حقوق النشر ",
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
                              " مرحبًا بك في شطرنج شطارة، حيث نحرص على حماية حقوق الملكية الفكرية وضمان بيئة آمنة تحترم إبداعات الجميع. هذه السياسة توضح حقوق النشر المتعلقة بالمحتوى الموجود على المنصة، وكيفية استخدامه، والحقوق التي يتمتع بها المستخدمون ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Schyler',
                              ),
                              textAlign: TextAlign.center, // محاذاة النص
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
                      'حقوق الملكية الفكرية لشطرنج شطارة',
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
                      ' جميع المحتويات الموجودة على منصة شطرنج شطارة، بما في ذلك',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10),
                    BulletPoint('الشعارات والتصميمات والعلامات التجارية'),
                    BulletPoint('القواعد والابتكارات الخاصة باللعبة'),
                    BulletPoint('المحتوى المكتوب والمرئي والرسوم التوضيحية والمقاطع الصوتية والفيديوهات'),
                    BulletPoint('قاعدة البيانات، والأكواد البرمجية، وواجهة المستخدم'),
                    BulletPoint('كل ما سبق مملوك بالكامل لشركة لغة الآلة، وهي الشركة المطورة لشطرنج شطارة، وهو محمي بموجب قوانين حقوق النشر المحلية والدولية'),
                    BulletPoint('لا يجوز إعادة إنتاج أو نشر أو توزيع أي جزء من المحتوى بدون إذن كتابي مسبق من الإدارة'),
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
                      'حقوق النشر للمحتوى الذي ينشئه المستخدمون',
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
                      'يحتفظ المستخدمون بحقوق ملكية المحتوى الذي ينشرونه على المنصة، مثل المنشورات، التحليلات، التعليقات، والمشاركات في شبكة تواصل شطارة',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10), // مسافة بين العنوان والنقاط
                    SelectableText(
                      'يمنح المستخدم إدارة شطرنج شطارة ترخيصًا غير حصري لاستخدام المحتوى المنشور للأغراض التالية',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10),
                    BulletPoint('تحسين تجربة المستخدم وعرض أفضل المشاركات'),
                    BulletPoint(' الترويج والتسويق للمحتوى الجيد داخل وخارج المنصة'),
                    BulletPoint('تطوير وتحليل البيانات لفهم وتحسين تجربة اللاعبين'),
                    BulletPoint('يحق لشطرنج شطارة إزالة أو تعديل أي محتوى ينتهك القوانين أو لا يتوافق مع سياسات الاستخدام'),
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
                      'استخدام المحتوى من قِبل المستخدمين',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10),
                    SizedBox(height: 10),// مسافة بين العنوان والنقاط
                    BulletPoint('يُسمح للمستخدمين بالاطلاع على محتوى المنصة واستخدامه للاستخدام الشخصي والتعليمي فقط'),
                    BulletPoint(' يُحظر تمامًا إعادة نشر، تعديل، أو استغلال أي محتوى تجاريًا دون إذن رسمي'),
                    BulletPoint('يجب عند مشاركة أي محتوى من المنصة ذكر المصدر بوضوح مع رابط للمنصة الأصلية'),
                    SizedBox(height: 10),
                    SelectableText(
                      'الاستخدام المسموح به',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10),// مسافة بين العنوان والنقاط
                    BulletPoint('نشر ومشاركة المحتوى التعليمي والتكتيكي مع الإشارة إلى المصدر'),
                    BulletPoint('تحليل مباريات شطرنج شطارة ومناقشتها في المدونات والمنصات المختلفة'),
                    BulletPoint(' استخدام المحتوى الشخصي الذي أنشأه اللاعب لمشاركته في شبكته الخاصة'),
                    SizedBox(height: 10),
                    SelectableText(
                      'الاستخدام غير المسموح به',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10),// مسافة بين العنوان والنقاط
                    BulletPoint(' إعادة نشر أي محتوى خاص باللعبة أو المنصة دون إذن'),
                    BulletPoint('تحميل أو تعديل الأكواد البرمجية أو قواعد اللعبة أو تصاميم المنصة'),
                    BulletPoint(' استخدام العلامات التجارية لشطرنج شطارة في أي منتج أو خدمة بدون تصريح رسمي'),
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
                      ' الإبلاغ عن انتهاك حقوق النشر',
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
                      'ذا كنت تعتقد أن هناك محتوى منشورًا على شطرنج شطارة ينتهك حقوق النشر الخاصة بك، يمكنك تقديم بلاغ رسمي عبر البريد الإلكترونيinfo@shatarachess.com',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Schyler',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10), /// مسافة بين العنوان والنقاط
                    BulletPoint('تفاصيل المحتوى المنتهك (الرابط والصورة إن أمكن)'),
                    BulletPoint(' دليل على ملكيتك لهذا المحتوى (مثل شهادة تسجيل حقوق النشر)'),
                    BulletPoint('معلومات الاتصال الخاصة بك للتواصل بشأن البلاغ'),
                    SizedBox(height: 10),
                    SelectableText(
                      'بعد استلام البلاغ، سنقوم بمراجعته واتخاذ الإجراءات اللازمة وفقًا لسياساتنا القانونية',
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
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8,8,75,8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SelectableText(
                      'التعديلات على سياسة حقوق النشر',
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
                      'تحتفظ إدارة شطرنج شطارة بالحق في تعديل هذه السياسة حسب الحاجة لضمان حماية الحقوق الفكرية لجميع المستخدمين. سيتم إعلام المستخدمين بأي تغييرات جوهرية عبر البريد الإلكتروني أو إشعارات المنصة',
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
