import 'package:flutter/material.dart';

import '../Widget/AboutChessPage/CustomNavbarAbout_Chess.dart';
import '../Widget/AboutChessPage/btnAbout.dart';
import '../Widget/HomePage/BottomNavbar.dart';
import '../Widget/HomePage/ContactSection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/logout_service.dart';


class about_Chess extends StatefulWidget {
  const about_Chess({super.key});

  @override
  State<about_Chess> createState() => _about_ChessState();
}

class _about_ChessState extends State<about_Chess> with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      endDrawer: isMobile ? _buildDrawer(context) : null,
      body: Stack(
        children: [
          // ✅ صورة الخلفية
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/looooog.png'), // ✅ الصورة الجديدة
                fit: BoxFit.cover,
              ),
            ),
          ),


          // ✅ المحتوى فوق الصورة
          Container(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: isMobile
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // 🔹 الصورة + التحذير (مصغّرة)
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/test.png',
                                  width: 90,  // ↓ كان 150
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: Colors.red, width: 2), // ↓ كان 3
                                    ),
                                  ),
                                  child: const Text(
                                    'شطارة تعمل بشكل أفضل على الكمبيوتر',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Alexandria',
                                      fontSize: 10, // ↓ كان 12
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 🔹 أيقونة النافبار — تظهر بدون أي تزاحم
                          Padding(
                            padding: const EdgeInsets.only(right: 8, top: 4),
                            child: CustomNavbarAbout_Chess(),
                          ),
                        ],
                      )
                          : CustomNavbarAbout_Chess(),

                    ),
                    const SizedBox(height: 35),
                    const btnAbout(),


                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 750, // ⭐ عرض ثابت لكل العناصر (قم بتغييره كما تريد)
                        ),
                        child: Column(
                          children: [

                            Center(
                              child: Stack(
                                children: [
                                  // الخلفية البيضاء بدل abnnn.png
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.white,
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: SelectableText(
                                        'شطرنج شطارة هي تطوير رسمي للشطرنج ببراءة اختراع سعودية يحتفظ بكل قواعد اللعبة الأصلية.\n'
                                            'يضيف منطقة جديدة تُسمّى منطقة الدعم تمنح اللاعبين بعدًا استراتيجيًا جديدًا من خلال ميزتين: التعزيز والترقية التدريجية.\n'
                                            'لأن في الحروب الحقيقية يوجد دائمًا جيش احتياطي جاهز للدعم.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Alexandria',
                                          fontSize: isMobile ? 13 : 18,
                                          color:Color(0xFF6B4E45),
                                          height: 1.6,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),


                            const SizedBox(height: 45),

                            // منطقة الدعم (نص + الصورة تحت)
                            Container(
                              color: Colors.white,
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SelectableText(
                                    'منطقة الدعم :',
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontFamily: 'Alexandria',
                                      fontSize: isMobile ? 13 : 21,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6B4E45),
                                    ),
                                  ),

                                  const SizedBox(height: 35),

                                  SelectableText(
                                    'إضافة استراتيجية تقع إلى جانب الرقعة الرئيسية، تمثل منطقة الإمداد العسكري للاعب.\n'
                                        'كل لاعب منطقة دعم جانبية تقع على يمين الرقعة الرئيسية تتكوّن من 12 مربعًا (3 صفوف × 4 أعمدة) وتُرتب فيها القطع الإضافية الخاصة باللاعب.',
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontFamily: 'Alexandria',
                                      fontSize: isMobile ? 11 : 18,
                                      color: Color(0xFF6B4E45),
                                      height: 1.7,
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  Center(
                                    child: Image.asset(
                                      'assets/anmmmm.png',
                                      width: isMobile ? 260 : 450,  // حجم ممتاز للموبايل ومناسب للديسكتوب
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                ],
                              ),
                            ),

                            const SizedBox(height: 25),

                            Image.asset(
                              'assets/abt1.png',
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Image.asset(
                                'assets/aaabbbbb1.png',
                                fit: BoxFit.contain,
                              ),
                            ),


                            const SizedBox(height: 25),
                            const BottomNavbar(),
                            const SizedBox(height: 25),
                            const ContactSection(),

                            const SizedBox(height: 25),
                            Center(
                              child: SelectableText(
                                '  جميع الحقوق محفوظة شطارة ©2025',
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: 'Alexandria',
                                  fontSize: isMobile ? 13 : 17,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF6B4E45),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),


                          ],
                        ),
                      ),
                    ),
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
                  _HoverDrawerItem(label: 'تعرف على شطاره', route: '/main',isSpecialActive: true,isAnyHovering: isAnyDrawerHovering, onHoverChanged: (h) => setState(() => isAnyDrawerHovering = h)),
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

// ✅ يمكنك الحفاظ على كلاس _HoverDrawerItem كما هو دون تغيير

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