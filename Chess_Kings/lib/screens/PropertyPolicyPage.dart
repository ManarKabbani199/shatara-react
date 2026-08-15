import 'package:flutter/material.dart';
import '../Widget/HomePage/BottomNavbar.dart';
import '../Widget/HomePage/ContactSection.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../Widget/NewHome/CustomNewHome.dart';
import '../Widget/NewHome/FooterNewHome.dart';
import '../Widget/TermsAndConditionsPage/CommercialUseWidget.dart';
import '../Widget/TermsAndConditionsPage/PropertyPolicybtn.dart';
import '../Widget/TermsAndConditionsPage/TermsWidget.dart';
import '../Widget/TermsAndConditionsPage/UsageWidget.dart';
import 'package:url_launcher/url_launcher.dart';

/// --------------------------
/// تتبع زيارة مرّة واحدة لكل جلسة
/// --------------------------


class PropertyPolicyPage extends StatefulWidget {
  const PropertyPolicyPage({super.key});

  @override
  State<PropertyPolicyPage> createState() => _PropertyPolicyPageState();
}

class _PropertyPolicyPageState extends State<PropertyPolicyPage> {
  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    // 🔧 إعدادات الارتفاعات والمسافات
    const double appBarHeight = 64;
    final double logoTopPadding = isMobile ? 6 : 10; // مسافة بسيطة أسفل الـ AppBar
    final double logoHeight = isMobile ? 64 : 80; // ارتفاع شعار test.png

    // ⛳️ شريط التحذير في الجوال
    const double bannerVerticalSpacing = 6;     // مسافة بسيطة بين الشعار والشريط
    const double warningBannerHeight = 48;      // ارتفاع تقريبي للشريط الأحمر

    // المحتوى يبدأ أسفل الشعار + الشريط (إن وُجد)
    final double contentTopPadding = logoTopPadding +
        logoHeight +
        (isMobile ? (bannerVerticalSpacing + warningBannerHeight) : 0) +
        8;

    return Scaffold(
      // ✅ AppBar بعرض كامل
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: Material(
          color: Colors.white,
          elevation: 0,
          child: SizedBox(
            height: appBarHeight,
            width: double.infinity,
            child: CustomNewHome(), // Navbar يأخذ عرض الشاشة بالكامل
          ),
        ),
      ),

      endDrawer: isMobile ? _buildDrawer(context) : null,

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/back_tweets.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            /// ✅ الشعار أعلى المنتصف + (في الجوال) شريط أحمر عريض تحت الشعار
            Positioned(
              top: logoTopPadding,
              left: 0,
              right: 0,
              child: Column(
                children: [

                  if (isMobile) ...[
                    const SizedBox(height: bannerVerticalSpacing),
                    // 🔴 الشريط الأحمر العريض برسالة التحذير (فقط في الجوال)
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: warningBannerHeight),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      color: Color(0xFFD32F2F), // أحمر واضح
                      child: const Text(
                        'في الوقت الحالي شطارة تعمل بشكل أفضل على الكمبيوتر',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            /// ✅ المحتوى الرئيسي يبدأ مباشرة أسفل الشعار/الشريط
            Padding(
              padding: EdgeInsets.only(top: contentTopPadding),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    const PropertyPolicybtn(),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 7, 16, 7),
                      child: TermsWidget(
                        iconImage: const AssetImage('assets/onei.png'),
                        titleText: 'حقوق الطبع والنشر',
                        firstLineText:
                        'جميع المحتويات الأصلية المنشورة على هذا الموقع محمية بموجب قوانين حقوق الطبع والنشر الدولية. يشمل ذلك النصوص والمقالات والصور والفيديوهات والتصاميم الجرافيكية.',
                        secondSectionText:
                        'حقوق محفوظة: جميع الحقوق محفوظة © 2025. لا يجوز إعادة إنتاج أو توزيع أي محتوى دون إذن كتابي مسبق.',
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 7, 16, 7),
                      child: UsageWidget(
                        title: 'العلامات التجارية',
                        description:
                        'جميع العلامات التجارية والشعارات وأسماء الخدمات المعروضة على هذا الموقع هي ملكية خاصة لأصحابها المعنيين وتُستخدم لأغراض التعريف فقط.',
                        iconPath: 'assets/towi.png',
                        bullets: const [
                          'شعار الموقع والعلامة التجارية الخاصة بنا',
                          'التصاميم والألوان المميزة للموقع',
                          'أسماء المنتجات والخدمات الخاصة بنا',
                          'النطاق والعناوين الإلكترونية',
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 7, 16, 0),
                      child: UsageWidget(
                        title: 'استخدام المحتوى',
                        description:
                        'يُسمح بالاستخدام المحدود لمحتوى الموقع للأغراض الشخصية وغير التجارية فقط، شريطة:',
                        iconPath: 'assets/threei.png',
                        bullets: const [
                          'الاحتفاظ بجميع إشعارات حقوق الطبع والنشر',
                          'عدم تعديل أو تغيير المحتوى بأي شكل',
                          'عدم استخدام المحتوى لأغراض تجارية',
                          'الإشارة إلى المصدر عند المشاركة',
                        ],
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: CommercialUseWidget(),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 7, 16, 7),
                      child: UsageWidget(
                        title: 'الإبلاغ عن انتهاكات',
                        description:
                        'إذا كنت تعتقد أن محتوى على موقعنا ينتهك حقوق الملكية الفكرية الخاصة بك، يرجى إرسال إشعار مفصل يتضمن:',
                        iconPath: 'assets/foiri.png',
                        bullets: const [
                          'وصف دقيق للعمل المحمي بحقوق الطبع والنشر',
                          'موقع المحتوى المنتهك على موقعنا',
                          'معلومات الاتصال الخاصة بك',
                          'بيان يؤكد حسن نيتك في الإبلاغ',
                          'توقيعك الإلكتروني أو المادي',
                        ],
                      ),
                    ),

                    const SizedBox(height: 5),
                    const ContactSection(),
                    Container(
                      width: double.infinity,
                      height: 2,
                      color: const Color(0xFF999999),
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
    );
  }

  /// Drawer للجوال
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

/// عنصر القائمة داخل Drawer
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
    required this.label,
    required this.route,
    this.isSpecialActive = false,
    this.isAlwaysActive = false,
    this.isAnyHovering = false,
    this.onHoverChanged,
    this.onTapOverride,
    this.iconPath,
    super.key,
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
