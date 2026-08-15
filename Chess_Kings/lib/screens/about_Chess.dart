import 'package:flutter/material.dart';
import '../Widget/AboutChessPage/CustomNavbarAbout_Chess.dart';
import '../Widget/AboutChessPage/GametWidget.dart';
import '../Widget/HomePage/BottomNavbar.dart';
import '../Widget/HomePage/ContactSection.dart';
import '../Widget/HomePage/FooterCopyright.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Widget/about_shatara/GameConceptWidget.dart';
import '../Widget/about_shatara/btnAboutShatra.dart';
import '../services/logout_service.dart';

class about_shatara extends StatefulWidget {
  const about_shatara({super.key});

  @override
  State<about_shatara> createState() => _about_shataraState();
}

class _about_shataraState extends State<about_shatara> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool get isMobile => MediaQuery.of(context).size.width < 600;

  bool isAnyDrawerHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ============================================
  // HERO IMAGE (desktop: centered top, mobile: top, smaller)
  // ============================================
  Widget _heroImage(bool isMobile) {
    return Padding(
      padding: EdgeInsets.only(top: isMobile ? 8 : 16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/test.png',
              height: isMobile ? 30 : 50, // ✅ تصغير الصورة للجوال والكمبيوتر
              fit: BoxFit.contain,
            ),
          ),

          // ✅ النص التحذيري أسفل الصورة (يظهر فقط في الجوال)
          if (isMobile) ...[
            const SizedBox(height: 8),
            const Text(
              'في الوقت الحالي شطارة تعمل بشكل أفضل على الكمبيوتر',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: 'Alexandria',
                decoration: TextDecoration.underline,
                decorationColor: Colors.red,
                decorationThickness: 3, // ✅ خط أحمر عريض تحت النص
              ),
            ),
          ],
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      endDrawer: isMobile ? _buildDrawer(context) : null,
      body: Stack(
        children: [
          // ✅ صورة الخلفية
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/back_tweets.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ✅ المحتوى فوق الصورة
          Container(
            color: const Color(0xFFDDDDDC).withOpacity(0.9), // طبقة شفافة إن أردت
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ===== Navbar always aligned to the right =====
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CustomNavbarAbout_Chess(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ===== Hero image at the very top =====
                    _heroImage(isMobile),

                    const SizedBox(height: 35),
                    const btnAboutShatra(),
                    const SizedBox(height: 15),
                    const SizedBox(height: 15),

                    GameConceptWidget(
                      title: 'مفهوم اللعبة والأهداف',
                      bulletItems: [
                        SelectableText(
                          'الهدف الأساسي هو تحقيق "كش مات" لملك الخصم، أي وضعه تحت التهديد دون وجود حركة قانونية لإنقاذه',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            height: 1.6,
                            fontFamily: 'Alexandria',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        SelectableText(
                          'قد تنتهي اللعبة أيضًا بالتعادل—مثل (لو كان الملك ليس في حال تهديد ولكن لا توجد حركات قانونية)، أو التكرار ثلاث مرات، ',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            height: 1.6,
                            fontFamily: 'Alexandria',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        SelectableText(
                          'أو نفاد الوقت إذا لم يتمكن الخصم من كسب، أو حتى اتفاق اللاعبَين على التعادل.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            height: 1.6,
                            fontFamily: 'Alexandria',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),

                    GametWidget(
                      title: 'أعداد الرقعة والقطع',
                      description: 'الرقعة عبارة عن مربعات 8×8، بلونين متناوبين. الهدف أن يكون المربع الأقصى الأيمن لكل لاعب هو لون فاتح',
                      imagePath: 'assets/shat.png',
                    ),

                    const SizedBox(height: 15),
                    Center(child: Image.asset('caaa.png')),
                    const SizedBox(height: 15),
                    SelectableText(
                      ' أعداد الرقعة والقطع ',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 15 : 25,
                        color: Color(0xFF6B4E45),
                      ),
                    ),

                    const SizedBox(height: 15),
                    GametWidget(
                      title: 'الملك',
                      description: 'مربع واحد في أي اتجاه؛ بالإضافة إلى التبييت (castle) مرّة واحدة لكل لاعب وفق شروط معينة',
                      imagePath: 'assets/shat1.png',
                    ),
                    const SizedBox(height: 15),
                    GametWidget(
                      title: 'الوزير',
                      description: 'تتحرك بقدر مالها من مربعات أفقياً، عمودياً أو قطرياً.',
                      imagePath: 'assets/shat2.png',
                    ),
                    const SizedBox(height: 15),
                    GametWidget(
                      title: 'القلعة',
                      description: 'أفقياً أو عمودياً بعدد غير محدود من المربعات.',
                      imagePath: 'assets/shat3.png',
                    ),
                    const SizedBox(height: 15),
                    GametWidget(
                      title: 'الفيل',
                      description: ': قطرياً كما يشاء فقط على لون المربع الذي يبدأ عليه.',
                      imagePath: 'assets/shat4.png',
                    ),
                    const SizedBox(height: 15),
                    GametWidget(
                      title: 'الحصان',
                      description: ': يتحرّك على شكل "L" — مربعان أفقي + مربع عمودي أو العكس — ويقفز فوق القطع.',
                      imagePath: 'assets/shat7.png',
                    ),
                    const SizedBox(height: 15),
                    GametWidget(
                      title: 'الجندي',
                      description:
                      'يتحرك إلى الأمام مربع واحد، ومربعَين من البداية فقط، إن كان خاليا.\n'
                          'يلتقط قطعتين قطرياً أمامه فقط.\n'
                          'يصل لآخر الصف فيُترقّى إلى قطعة أقوى (عادة وزير أو أي قطعة أخرى يتختارها اللاعب).',
                      imagePath: 'assets/shat8.png',
                    ),
                    const SizedBox(height: 15),
                    GametWidget(
                      title: 'التبييت (Castling)',
                      description: 'ينقل الملك مربعين تجاه الرّخ، ثم ينتقل الرّخ إلى الجهة الثالثة منه. \n'
                          'شرط ألا يكون أي من الملك أو الرّخ قد حُرّك سابقًا، ولا وجود قطع بينهما، ولا المرور عبر أو الوقوع في كش',
                      imagePath: 'assets/shat9.png',
                    ),

                    const SizedBox(height: 15),
                    GameConceptWidget(
                      title: 'الكش، الكش مات، والسكتة',
                      bulletItems: [
                        SelectableText(
                          'الكش: تهديد مباشر للملك .',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            height: 1.6,
                            fontFamily: 'Alexandria',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        SelectableText(
                          'الكش مات: إذا لم يستطع الملك الهروب أو إغلاق التهديد أو اعتراض المسار بأي قطعة، يخسر اللاعب .',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            height: 1.6,
                            fontFamily: 'Alexandria',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        SelectableText(
                          'السكتة (Stalemate): إذا لم يكن في كش، لكن لا توجد حركة قانونية—النتيجة تعادل.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            height: 1.6,
                            fontFamily: 'Alexandria',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    GameConceptWidget(
                      title: 'قواعد التكرار',
                      bulletItems: [
                        SelectableText(
                          'التكرار ثلاث مرات يعطي الحق للمطالبة بالتعادل (اللاعب يجب أن يطالب) .',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            height: 1.6,
                            fontFamily: 'Alexandria',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        SelectableText(
                          'التكرار خمس مرات يؤدي إلى إعلان تعادل تلقائي من الحكم.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            height: 1.6,
                            fontFamily: 'Alexandria',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    GameConceptWidget(
                      title: 'الوقت',
                      bulletItems: [
                        SelectableText(
                          'تُستخدم ساعات شطرنج لضبط الوقت.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            height: 1.6,
                            fontFamily: 'Alexandria',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        SelectableText(
                          'في المباريات الرسمية وفق قوانين FIDE، قد يضاف تأخير (delay) أو زيادة (increment) مع كل حركة',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            height: 1.6,
                            fontFamily: 'Alexandria',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        SelectableText(
                          'نفاد الوقت يؤدي إلى خسارة، إلا إذا كان الخصم معروف بعجزه عن الكش مات نظريًا—ثم يكون التعادل طبقًا لقواعد FIDE .',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            height: 1.6,
                            fontFamily: 'Alexandria',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    GameConceptWidget(
                      title: 'المستوى الرسمي: FIDE',
                      bulletItems: [
                        SelectableText(
                          'الاتحاد الدولي للشطرنج (FIDE) يضع القوانين الرسمية، تنفذ عالمياً في البطولات',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            height: 1.6,
                            fontFamily: 'Alexandria',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        SelectableText(
                          'القوانين تشمل تحكيم الأخطاء، أوقات اللعبة، الترتيبات، والمخالفات.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            height: 1.6,
                            fontFamily: 'Alexandria',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    const BottomNavbar(),
                    const SizedBox(height: 5),
                    Container(width: double.infinity, height: 2, color: Color(0xFF999999)),
                    const ContactSection(),
                    Container(width: double.infinity, height: 2, color: Color(0xFF999999)),
                    const SizedBox(height: 5),
                    const FooterCopyright(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        final isLoggedIn = FirebaseAuth.instance.currentUser != null;
        return ClipRRect(
          borderRadius: BorderRadius.zero,
          child: Drawer(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            backgroundColor: const Color(0xFFDDDDDC),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click, // المؤشر يصبح يد
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: Image.asset(
                        'assets/logon.png',
                        height: 60,
                      ),
                    ),
                  ),
                  const Divider(),
                  _HoverDrawerItem(label: 'تعرف على شطاره', route: '/main', isSpecialActive: true, isAnyHovering: isAnyDrawerHovering, onHoverChanged: (h) => setState(() => isAnyDrawerHovering = h)),
                  _HoverDrawerItem(label: 'من نحن', route: '/about', isAnyHovering: isAnyDrawerHovering, onHoverChanged: (h) => setState(() => isAnyDrawerHovering = h)),
                  _HoverDrawerItem(label: 'الاسئلة الشائعة', route: '/faq', isAnyHovering: isAnyDrawerHovering, onHoverChanged: (h) => setState(() => isAnyDrawerHovering = h)),
                  _HoverDrawerItem(label: 'ألعب الأن', route: '/playNow', isAnyHovering: isAnyDrawerHovering, onHoverChanged: (h) => setState(() => isAnyDrawerHovering = h)),
                  isLoggedIn
                      ? _HoverDrawerItem(label: 'تسجيل الخروج', route: '/home', isAlwaysActive: true, onTapOverride: () async {
                    await LogoutService.signOut(context, redirectRoute: '/main');
                  })
                      : _HoverDrawerItem(label: 'تسجيل الدخول', route: '/login', isAlwaysActive: true),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


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
