import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'FeedScreen.dart';
import 'MainHome.dart';


class TermsPage extends StatelessWidget {
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
                              " شبكة شطرنج شطارة–",
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
                              "شروط الاستخدام",
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
                            " مرحبًا بك في شطرنج شطارة، حيث نوفر لك تجربة فريدة تجمع بين المنافسة الفكرية والتفاعل الاجتماعي في بيئة منظمة وآمنة. قبل استخدام منصتنا، يرجى قراءة شروط الاستخدام بعناية لضمان تجربة سلسة وعادلة لجميع المستخدمين ",
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
            SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.fromLTRB(8,8,75,8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SelectableText(
                    'الموافقة على الشروط',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Schyler',
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 10), // مسافة بين العنوان والنقاط
                  BulletPoint('باستخدامك لمنصة شطرنج شطارة، فإنك توافق على الالتزام بجميع الأحكام والسياسات المذكورة هنا'),
                  BulletPoint('في حال عدم موافقتك على أي من هذه الشروط، نرجو منك عدم استخدام المنصة'),
                  BulletPoint('تحتفظ إدارة شطرنج شطارة بالحق في تحديث هذه الشروط في أي وقت، وسيتم إعلام المستخدمين بأي تغييرات جوهرية'),
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
                    'حساب المستخدم وبيانات التسجيل',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Schyler',
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 10), // مسافة بين العنوان والنقاط
                  BulletPoint('يجب أن يكون المستخدم فوق 13 عامًا لإنشاء حساب في شطرنج شطارة'),
                  BulletPoint('يتحمل المستخدم مسؤولية سرية بيانات تسجيل الدخول الخاصة به، وأي استخدام غير مصرح به لحسابه'),
                  BulletPoint(' لا يُسمح بمشاركة الحسابات بين عدة أشخاص أو استخدام الحسابات الوهمية'),
                  BulletPoint('لإدارة شطرنج شطارة الحق في تعليق أو حذف أي حساب يخالف السياسات'),
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
                    'السلوك العام والمحتوى المسموح به',
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
                    'لضمان بيئة إيجابية، يُمنع تمامًا',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Schyler',
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 10),// مسافة بين العنوان والنقاط
                  BulletPoint('نشر أي محتوى غير قانوني، عنصري، مسيء، أو يحرض على العنف والكراهية'),
                  BulletPoint(' الإساءة أو التنمر على اللاعبين الآخرين أو استخدام لغة غير لائقة'),
                  BulletPoint(' نشر معلومات مضللة أو محتوى ينتهك حقوق الملكية الفكرية للآخرين'),
                  BulletPoint(' استغلال المنصة لأغراض تجارية غير مصرح بها'),
                  BulletPoint('  يُسمح بنشر وتحليل المباريات، مشاركة الاستراتيجيات، والنقاشات الهادفة حول الشطرنج أو المواضيع العامة بما يتوافق مع القوانين والسياسات'),
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
                    'القوانين الخاصة باللعب والبطولات',
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
                    'لضمان عدالة المنافسة في شطرنج شطارة',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Schyler',
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 10), /// مسافة بين العنوان والنقاط
                  BulletPoint('يُحظر الغش بأي شكل، مثل استخدام برامج مساعدة دون تصريح'),
                  BulletPoint('يتم اتخاذ إجراءات صارمة ضد الغشاشين، تشمل إيقاف الحساب نهائيًا وحذف نتائجه في البطولات'),
                  BulletPoint('القرارات التحكيمية في البطولات نهائية وغير قابلة للاستئناف، ويتم تطبيق القوانين الرسمية لشطرنج شطارة'),
                  BulletPoint('يحق للإدارة إلغاء أي مباراة أو بطولة في حال تم اكتشاف أي نشاط غير قانوني أو احتيالي'),
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
                    'الملكية الفكرية وحقوق الاستخدام',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Schyler',
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 10), // مسافة بين العنوان والنقاط
                  BulletPoint(' جميع الحقوق الفكرية لشطرنج شطارة، بما في ذلك التصاميم، القواعد، والنظام الرقمي، مملوكة بالكامل لشركة لغة الآلة'),
                  BulletPoint(' لا يجوز استخدام أو استنساخ أي جزء من المنصة، اللعبة، أو البطولات دون إذن رسمي من الإدارة'),
                  BulletPoint('  جميع المشاركات والمحتويات التي يضيفها المستخدمون تظل ملكًا لهم، لكن يحق للمنصة استخدامها في الترويج والتسويق بما لا ينتهك الخصوصية '),
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
                    'الخصوصية وأمان البيانات',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Schyler',
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 10), // مسافة بين العنوان والنقاط
                  BulletPoint('نلتزم بحماية بيانات المستخدمين وعدم مشاركتها مع أي طرف ثالث بدون موافقة صريحة'),
                  BulletPoint('قد نقوم بجمع بيانات مثل الإحصائيات، أوقات اللعب، التفضيلات، وسجل التحديات لتحسين تجربة المستخدم'),
                  BulletPoint('لمزيد من التفاصيل حول كيفية حماية بياناتك، يمكنك الاطلاع على سياسة الخصوصية الخاصة بنا'),
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
                    'إنهاء الخدمة أو تعليق الحسابات',
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
                    'تحتفظ إدارة شطرنج شطارة بالحق في تعليق أو حذف أي حساب في الحالات التالية',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Schyler',
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 10), // مسافة بين العنوان والنقاط
                  BulletPoint('انتهاك القواعد والشروط المذكورة أعلاه'),
                  BulletPoint(' الغش أو محاولة التلاعب بنتائج المباريات والبطولات'),
                  BulletPoint('نشر محتوى غير لائق أو الإخلال بقوانين المجتمع'),
                  BulletPoint(' إساءة استخدام المنصة لأغراض غير قانونية أو ضارة'),
                  BulletPoint('في حال تعرض حسابك للحظر، يمكنك التواصل مع الدعم الفني لمراجعة حالتك'),
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
