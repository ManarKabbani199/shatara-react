import 'package:flutter/material.dart';
import '../../screens/ShataraRegisterPage.dart';

/// نموذج بسيط لعضو/حساب يظهر في القسم الثاني
class ShataraMember {
  final String avatarPath; // مسار صورة الأيقونة
  final String name;       // الاسم
  final String handle;     // اليوزر
  const ShataraMember({
    required this.avatarPath,
    required this.name,
    required this.handle,
  });
}

class ShataraCommunityWidget extends StatelessWidget {
  const ShataraCommunityWidget({
    super.key,
    // متحولات القسم الأول
    required this.coverImagePath,     // كانت: "اريد الصوره ان تكون متحول"
    required this.headline,           // كانت: "متحول 1"
    required this.timeAgo,            // كانت: "متحول 2"
    required this.likes,              // كانت: "متحول3"
    // متحولات القسم الثاني (صفّين)
    required this.memberTop,          // كانت: "صوره متحول / متحول 6 / متحول7"
    required this.memberBottom,       // كانت: "صوره متحول / متحول 4 / متحول 5"
  });

  // القسم الأول
  final String coverImagePath;
  final String headline;
  final String timeAgo;
  final String likes;

  // القسم الثاني
  final ShataraMember memberTop;
  final ShataraMember memberBottom;

  static const _brandColor = Color(0xFF6B4E45);
  static const _ctaBg = Color(0xFFAB86B9);

  double _fs(BuildContext context, {required double regular, required double mobile}) {
    final w = MediaQuery.of(context).size.width;
    return w < 600 ? mobile : regular;
  }

  TextStyle _textStyle(
      BuildContext context, {
        required double regularSize,
        required double mobileSize,
        FontWeight weight = FontWeight.w700,
        Color color = _brandColor,
      }) {
    return TextStyle(
      fontFamily: 'Alexandria',
      fontWeight: weight,
      color: color,
      fontSize: _fs(context, regular: regularSize, mobile: mobileSize),
      height: 1.3,
    );
  }

  Widget _thinDivider() => Divider(thickness: 0.5, color: Colors.grey.shade300, height: 24);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backkkb.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              //

              _thinDivider(),

              // القسم الثاني
              SelectableText(
                'عضو جديد في مجمتع شطارة',
                style: _textStyle(context, regularSize: 19, mobileSize: 12),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 12),

              // الصف الأول (Top)
              _profileRowWithAction(context, memberTop),

              const SizedBox(height: 30), // sizeBox height:30

              // الصف الثاني (Bottom)
              _profileRowWithAction(context, memberBottom),

              _thinDivider(),

              // القسم الثالث: زر انضمام
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _ctaBg,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // حواف حادة
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ShataraRegisterPage(),
                      ),
                    );
                  },
                  child: SelectableText(
                    'انضم لمجتمع شطارة',
                    style: _textStyle(
                      context,
                      regularSize: 14,
                      mobileSize: 12,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileRowWithAction(BuildContext context, ShataraMember member) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // القسم اليميني: أيقونة + اسم + يوزر
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // الأيقونة
              ClipRRect(
                borderRadius: BorderRadius.zero,
                child: Image.asset(
                  member.avatarPath,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              // النصوص
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SelectableText(
                    member.name,
                    style: _textStyle(context, regularSize: 15, mobileSize: 12),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 2),
                  SelectableText(
                    member.handle,
                    style: _textStyle(
                      context,
                      regularSize: 10,
                      mobileSize: 7,
                      weight: FontWeight.w400,
                      color: Colors.black45,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // القسم اليساري: زر/صورة
        const Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.topLeft,
            child: Image(
              image: AssetImage('assets/btnnewm.png'),
              height: 36,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}

/// ويدجت جاهزة تعرض 3 عناصر ShataraCommunityWidget جنب بعض مع مسافات بينهم
class ShataraCommunityTriple extends StatelessWidget {
  const ShataraCommunityTriple({super.key});

  @override
  Widget build(BuildContext context) {
    // مسافة ثابتة بين العناصر
    const gap = SizedBox(width: 16);

    return LayoutBuilder(
      builder: (context, c) {
        // لو الشاشة واسعة، صف أفقي بثلاث عناصر
        if (c.maxWidth >= 900) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _item1(context)),
              gap,
              Expanded(child: _item2(context)),
              gap,
              Expanded(child: _item3(context)),
            ],
          );
        }
        // شاشات متوسطة: شبكي 2 ثم 1
        if (c.maxWidth >= 600) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: _item1(context)),
                  gap,
                  Expanded(child: _item2(context)),
                ],
              ),
              const SizedBox(height: 16),
              _item3(context),
            ],
          );
        }
        // موبايل: واحد تحت الثاني
        return Column(
          children: [
            _item1(context),
            const SizedBox(height: 16),
            _item2(context),
            const SizedBox(height: 16),
            _item3(context),
          ],
        );
      },
    );
  }

  // أمثلة تعبئة بالـ متحولات — عدّلها كما تريد
  Widget _item1(BuildContext context) => ShataraCommunityWidget(
    coverImagePath: 'assets/RectangleAbout.png',
    headline: 'EA SPORT COLLABORATE WITH #SHATARACHESS',
    timeAgo: '23 min',
    likes: '16.9K',
    memberTop: const ShataraMember(
      avatarPath: 'assets/iconrrrr.png',
      name: 'Nour',
      handle: '@nour_off',
    ),
    memberBottom: const ShataraMember(
      avatarPath: 'assets/iconrrrr.png',
      name: 'Maha',
      handle: '@maha_dev',
    ),
  );

  Widget _item2(BuildContext context) => ShataraCommunityWidget(
    coverImagePath: 'assets/RectangleAbout.png',
    headline: 'GRANDMASTER JOINS #SHATARA COMMUNITY',
    timeAgo: '8 min',
    likes: '5.3K',
    memberTop: const ShataraMember(
      avatarPath: 'assets/iconrrrr.png',
      name: 'Ali',
      handle: '@ali_chess',
    ),
    memberBottom: const ShataraMember(
      avatarPath: 'assets/iconrrrr.png',
      name: 'Hala',
      handle: '@hala_ai',
    ),
  );

  Widget _item3(BuildContext context) => ShataraCommunityWidget(
    coverImagePath: 'assets/RectangleAbout.png',
    headline: 'WEEKLY TOURNAMENT STARTS NOW',
    timeAgo: '1 hr',
    likes: '9.1K',
    memberTop: const ShataraMember(
      avatarPath: 'assets/iconrrrr.png',
      name: 'Yousef',
      handle: '@yousef_pro',
    ),
    memberBottom: const ShataraMember(
      avatarPath: 'assets/iconrrrr.png',
      name: 'Lina',
      handle: '@lina_code',
    ),
  );
}
