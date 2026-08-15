import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  late final TextEditingController emailController;

  // ثوابت الاتصال
  static const String _email = 'info@shatarachess.com';
  static const String _phoneDisplay = '+966 54 892 9642';
  static const String _phoneRaw = '966548929642'; // بدون + ومسافات ل wa.me

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _openWhatsApp() async {
    final uri = Uri.parse('https://wa.me/$_phoneRaw');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(
        msg: 'تعذّر فتح واتساب',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> _sendEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _email,
      // بإمكانك تمرير subject/body عند الحاجة:
      // query: 'subject=استفسار&body=مرحباً،',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(
        msg: 'تعذّر فتح البريد',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final baseStyle = TextStyle(
      fontFamily: 'Alexandria',
      fontSize: isMobile ? 9 : 15,
      color: const Color(0xFF6B4E45),
    );

    final linkStyle = baseStyle.copyWith(
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w600,
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ القسم الأيمن
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // ✅
                children: [
                  SelectableText(
                    'تواصل معنا',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: isMobile ? 11 : 19,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6B4E45),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // سطر البريد — فقط الإيميل قابل للنقر
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'البريد الإلكتروني : ', style: baseStyle),
                        TextSpan(
                          text: _email,
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()..onTap = _sendEmail,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),

                  // سطر الهاتف — فقط الرقم قابل للنقر (يفتح واتساب)
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'رقم الهاتف : ', style: baseStyle),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: GestureDetector(
                              onTap: _openWhatsApp,
                              child: Text('+966 54 892 9642', style: linkStyle),
                            ),
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.right,
                  )

                ],
              ),
            ),

            const SizedBox(width: 20),

            // ✅ القسم الأيسر
            Expanded(
              flex: 1,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 600;
                  final fieldHeight = isMobile ? 40.0 : 48.0;
                  final radius = 8.0;

                  final fieldWidth = isMobile ? 230.0 : 280.0;
                  final buttonWidth = isMobile ? 230.0 : 280.0;

                  return Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 🟢 حقل البريد الإلكتروني
                        SizedBox(
                          width: fieldWidth,
                          height: fieldHeight,
                          child: TextField(
                            controller: emailController,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'البريد الإلكتروني',
                              hintStyle: TextStyle(
                                fontFamily: 'Alexandria',
                                fontSize: isMobile ? 11 : 14,
                                color: const Color(0xFF6B4E45),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(radius),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: 'Alexandria',
                              fontSize: isMobile ? 11 : 14,
                              color: const Color(0xFF6B4E45),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // 🟣 زر "ابق مطّلعًا على جديد شطارة"
                        Material(
                          color: const Color(0xFFAB86B9), // خلفية الزر
                          borderRadius: BorderRadius.zero, // حواف حادة
                          child: InkWell(
                            borderRadius: BorderRadius.zero,
                            onTap: () {
                              Fluttertoast.showToast(
                                msg: 'تم تسجيلك بنجاح',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.black87,
                                textColor: Colors.white,
                              );
                            },
                            child: SizedBox(
                              height: fieldHeight,
                              width: buttonWidth,
                              child: const Center(
                                child: Text(
                                  'ابقَ مطلعاً على جديد شطارة',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Alexandria',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
