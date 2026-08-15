import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../Widget/HomePage/BottomNavbar.dart';
import '../Widget/HomePage/ContactSection.dart';
import '../Widget/HomePage/CustomNavbar.dart';
import '../Widget/HomePage/FooterCopyright.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Widget/NewHome/CustomNewHome.dart';
import '../Widget/NewHome/FooterNewHome.dart';
import '../Widget/TermsAndConditionsPage/TermsWidget.dart';
import '../Widget/TermsAndConditionsPage/UsageWidget.dart';
import '../Widget/TermsAndConditionsPage/btnTerm.dart';
import 'package:url_launcher/url_launcher.dart';


/// --------------------------
/// تتبع زيارة مرّة واحدة لكل جلسة
/// --------------------------
class VisitorTracker {
  static bool _visited = false;

  static Future<void> registerOncePerSession() async {
    if (_visited) return;
    _visited = true;
    try {
      await FirebaseFirestore.instance.collection('visitors').add({
        'at': FieldValue.serverTimestamp(),
        'platform': kIsWeb ? 'web' : 'mobile',
        'uid': FirebaseAuth.instance.currentUser?.uid,
        'source': 'terms',
      });
    } catch (e) {
      // ignore: avoid_print
      print('Visitor log failed: $e');
    }
  }
}

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  bool isAnyDrawerHovering = false;

  @override
  void initState() {
    super.initState();
    VisitorTracker.registerOncePerSession();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 600;

    // ارتفاعات مريحة
    final double navbarHeight = isMobile ? 56 : 72;
    final double logoHeight = isMobile ? 30 : 45;

    return Scaffold(
      endDrawer: isMobile ? _buildDrawer(context) : null,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/back_tweets.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ================== الهيدر ==================
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 24,
                  vertical: isMobile ? 6 : 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Navbar يأخذ عرض الشاشة كامل -> لن ينضغط
                    SizedBox(
                      height: navbarHeight,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: double.infinity, // المفتاح لعدم الانضغاط
                          child: const CustomNewHome(),
                        ),
                      ),
                    ),
                    SizedBox(height: isMobile ? 6 : 10),
                    // الصورة في الوسط أعلى المحتوى

                    // ================== تنبيه الجوال تحت صورة Test ==================
                    if (isMobile) ...[
                      const SizedBox(height: 8),
                      // خط أحمر عريض بعرض الشاشة
                      Container(width: double.infinity, height: 4, color: Color(0xFFB71C1C)),
                      const SizedBox(height: 6),
                      // نص التحذير باللون الأحمر وبخط واضح
                      Center(
                        child: Text(
                          'في الوقت الحالي شطارة تعمل بشكل أفضل على الكمبيوتر',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Alexandria',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFB71C1C),
                            // يمكن إضافة سطر تحته إذا رغبت:
                            // decoration: TextDecoration.underline,
                            // decorationColor: Color(0xFFB71C1C),
                            // decorationThickness: 2.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ================== المحتوى ==================
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      const btnTerm(),
                      const SizedBox(height: 12),

                      // ====== البلوكات ======
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 7, 16, 7),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TermsWidget(
                            iconImage: const AssetImage('assets/onei.png'),
                            titleText: 'قبول الشروط والأحكام',
                            firstLineText:
                            'باستخدام هذا الموقع الإلكتروني والخدمات المقدمة من خلاله، فإنك توافق على الالتزام بهذه الشروط والأحكام. إذا كنت لا توافق على أي من هذه الشروط، يرجى عدم استخدام موقعنا.',
                            secondSectionText:
                            'ملاحظة مهمة: تطبق هذه الشروط على جميع المستخدمين والزوار لهذا الموقع، بما في ذلك المستخدمون الذين يساهمون بالمحتوى أو المعلومات أو الخدمات الأخرى على الموقع.',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 7, 16, 7),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: UsageWidget(
                            title: 'حقوق الملكية الفكرية',
                            description: 'نحن ملتزمون بحماية خصوصيتك. تصف سياسة الخصوصية الخاصة بنا كيفية جمع واستخدام وحماية المعلومات الشخصية التي تقدمها لنا. عند استخدام موقعنا، قد نجمع معلومات معينة تلقائياً، مثل:',
                            iconPath: 'assets/towi.png',
                            bullets: const [
                              'عنوان IP الخاص بك',
                              'نوع المتصفح ونظام التشغيل',
                              'الصفحات التي تزورها على موقعنا',
                              'الوقت والتاريخ الذي تصل فيه إلى موقعنا',
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 7, 16, 7),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TermsWidget(
                            iconImage: const AssetImage('assets/fivei.png'),
                            titleText: 'إخلاء المسؤولية',
                            firstLineText: '',
                            secondSectionText:
                            'تحذير: قد تحتوي المعلومات إلى أخطاء تقنية أو مطبعية. نحتفظ بالحق في إجراء تحسينات أو تغييرات على المحتوى في أي وقت دون إشعار مسبق.',
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 7, 16, 7),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TermsWidget(
                            iconImage: const AssetImage('assets/sixi.png'),
                            titleText: 'التعديلات على الشروط',
                            firstLineText:
                            'نحتفظ بالحق في تعديل هذه الشروط والأحكام في أي وقت دون إشعار مسبق. ستصبح التعديلات سارية فور نشرها على هذا الموقع.',
                            secondSectionText:
                            'يُنصح بمراجعة هذه الصفحة بانتظام للاطلاع على أي تغييرات. استمرارك في استخدام الموقع بعد نشر التعديلات يعني موافقتك على الشروط المحدثة.',
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      FooterNewHome(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    return Drawer(
      backgroundColor: const Color(0xFFDDDDDC),

      // ✅ حواف حادة (كما عندك)
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.zero,
          bottomLeft: Radius.zero,
        ),
      ),

      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/new_home');
              },
              child: Image.asset(
                'assets/logon.png',
                height: 60,
              ),
            ),
            const Divider(),

            _HoverDrawerItem(
              label: 'متجر شطارة',
              route: '/noop',
              onTapOverride: () => _openUrl(_storeUrl),
            ),
            _HoverDrawerItem(
              label: 'نادي شطارة',
              route: '/noop',
              onTapOverride: () => _openUrl(_nadiUrl),
            ),
            _HoverDrawerItem(
              label: 'دليل شطارة',
              route: '/noop',
              onTapOverride: () => _openUrl(_guidePdfUrl),
            ),

            isLoggedIn
                ? _HoverDrawerItem(
              label: 'تسجيل الخروج',
              route: '/new_home',
              isAlwaysActive: true,
              onTapOverride: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/main');
                }
              },
            )
                : _HoverDrawerItem(
              label: 'تسجيل الدخول',
              route: '/ShataraLoginScreen',
              isAlwaysActive: true,
            ),
          ],
        ),
      ),
    );
  }

  static const String _storeUrl = 'https://shatarachess.com/';
  static const String _guidePdfUrl = 'https://shatara.sa/shatraBooks.pdf';
  static const String _nadiUrl = 'https://hawi.gov.sa/club/club-details/hxsdFo0dsfyUZLqg2bY0ljSyu3yBXW3UvxMl3Jk3P466Por21Ldno4TUsJotNQHdQsw9PqBv40E';


  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(
      uri,
      mode: LaunchMode.platformDefault,
      webOnlyWindowName: '_blank',
    );
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذّر فتح الرابط')),
      );
    }
  }


}

// ✅ عنصر القائمة الجانبية مع تأثير Hover
class _HoverDrawerItem extends StatefulWidget {
  final String label;
  final String route;
  final bool isSpecialActive;
  final bool isAlwaysActive;
  final bool isAnyHovering;
  final Function(bool)? onHoverChanged;
  final VoidCallback? onTapOverride;
  final String? iconPath;

  const _HoverDrawerItem({
    super.key,
    required this.label,
    required this.route,
    this.isSpecialActive = false,
    this.isAlwaysActive = false,
    this.isAnyHovering = false,
    this.onHoverChanged,
    this.onTapOverride,
    this.iconPath,
  });

  @override
  State<_HoverDrawerItem> createState() => _HoverDrawerItemState();
}

class _HoverDrawerItemState extends State<_HoverDrawerItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    if (widget.isAlwaysActive) {
      backgroundColor = const Color(0xFFAB86B9);
      textColor = Colors.white;
    } else if (widget.isSpecialActive) {
      if (widget.isAnyHovering) {
        backgroundColor = Colors.transparent;
        textColor = const Color(0xFF6B4E45);
      } else {
        backgroundColor = const Color(0xFFAB86B9);
        textColor = Colors.white;
      }
    } else {
      if (_isHovering) {
        backgroundColor = const Color(0xFFAB86B9);
        textColor = Colors.white;
      } else {
        backgroundColor = Colors.transparent;
        textColor = const Color(0xFF6B4E45);
      }
    }

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovering = true);
        widget.onHoverChanged?.call(true);
      },
      onExit: (_) {
        setState(() => _isHovering = false);
        widget.onHoverChanged?.call(false);
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          if (widget.onTapOverride != null) {
            widget.onTapOverride!();
          } else {
            final currentRoute = ModalRoute.of(context)?.settings.name;
            if (currentRoute != widget.route) {
              Navigator.pushNamed(context, widget.route);
            }
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.zero,
          ),
          child: Row(
            children: [
              if (widget.iconPath != null) ...[
                Image.asset(widget.iconPath!, width: 18, height: 18),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 15,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
