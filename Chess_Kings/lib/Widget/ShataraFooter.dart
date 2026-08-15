import 'package:flutter/material.dart';

class ShataraFooter extends StatelessWidget {
  const ShataraFooter({super.key});

  static const primaryColor = Color(0xFFAB86B9);
  static const textColor = Color(0xFF6B4E45);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Stack(
          children: [
            // ✅ اللوقو أعلى اليمين
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                'assets/logon.png',
                width: isMobile ? 90 : 175,
                fit: BoxFit.contain,
              ),
            ),

            // محتوى الفوتر
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Column(
                children: [
                  isMobile
                      ? Column(
                    children: _buildSections(isMobile),
                  )
                      : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _buildSections(isMobile),
                  ),

                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 16),

                  // الحقوق
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '© 2025 شطارة. جميع الحقوق محفوظة',
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 12,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: const [
                          _FooterLink('الشروط و الأحكام'),
                          SizedBox(width: 20),
                          _FooterLink('سياسة الملكية الفكرية'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSections(bool isMobile) {
    return [
      _pagesSection(),
      if (!isMobile) const SizedBox(width: 40),
      _contactSection(),
      if (!isMobile) const SizedBox(width: 40),
      _newsletterSection(isMobile),
    ];
  }

  Widget _pagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'الصفحات',
          style: TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 16,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        _FooterLink('الرئيسية'),
        _FooterLink('تعرّف على شطارة'),
        _FooterLink('العب الآن'),
        _FooterLink('من نحن'),
      ],
    );
  }

  Widget _contactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'تواصل معنا',
          style: TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 14,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'shatara@shatara.sa',
          style: TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 13,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        Text(
          '+966 54 892 9642',
          style: TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 13,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        _SupportButton(),
      ],
    );
  }

  Widget _newsletterSection(bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : 500,
      padding: const EdgeInsets.all(16),
      color: Colors.black.withOpacity(0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ابقَ مطّلع على جديد شطارة',
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 14,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child:TextField(
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 14,
                    color: Color(0xFF6B4E45),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'البريد الإلكتروني',
                    hintStyle: TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: 13,
                      color: Color(0xFF9E9E9E),
                    ),
                    filled: true,
                    fillColor: Colors.white,

                    isDense: false, // 👈 يسمح بارتفاع أكبر
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14, // 👈 زودنا الارتفاع
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                ),

              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'اشترك الآن',
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Text(
            'حسابات شطارة',
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 13,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: const [
              _SocialIcon(Icons.facebook),
              _SocialIcon(Icons.close),
              _SocialIcon(Icons.telegram),
              _SocialIcon(Icons.linked_camera),
              _SocialIcon(Icons.camera_alt),
            ],
          ),
        ],
      ),
    );
  }
}

// ================= COMPONENTS =================

class _FooterLink extends StatelessWidget {
  final String text;
  const _FooterLink(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Alexandria',
          fontSize: 13,
          color: Color(0xFF6B4E45),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  const _SocialIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xFFAB86B9),
      ),
      child: Icon(icon, size: 16, color: Colors.white),
    );
  }
}

class _SupportButton extends StatelessWidget {
  const _SupportButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFAB86B9),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      onPressed: () {},
      child: const Text(
        'مركز المساعدة و الدعم',
        style: TextStyle(
          fontFamily: 'Alexandria',
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
