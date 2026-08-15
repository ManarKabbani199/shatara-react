import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'ShataraPdfViewerUniversal.dart';

class ShataraJoinGuideWidget extends StatefulWidget {
  const ShataraJoinGuideWidget({
    super.key,
    this.onDownload,
  });

  final VoidCallback? onDownload;

  @override
  State<ShataraJoinGuideWidget> createState() =>
      _ShataraJoinGuideWidgetState();
}

class _ShataraJoinGuideWidgetState extends State<ShataraJoinGuideWidget> {
  final _formKey = GlobalKey<FormState>();

  final _fullName = TextEditingController();
  final _userName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _age = TextEditingController(text: '26');
  final _password = TextEditingController();

  String? _gender;
  String? _country;

  bool _loading = false;
  bool _submitted = false;
  bool _obscurePassword = true;

  static const _bg = Color(0xFFEFF3F7);
  static const String _pdfUrl = 'https://shatara.sa/shatraBooks.pdf';

  static const List<String> allCountriesAr = [
    // ضع هنا نفس قائمة الدول الطويلة الموجودة عندك كما هي
    'السعودية',
    'الكويت',
    'قطر',
    'الإمارات',
    'البحرين',
    'عُمان',
    'مصر',
    'الأردن',
    'لبنان',
    'العراق',
    'سوريا',
    'فلسطين',
    'اليمن',
    'المغرب',
    'الجزائر',
    'تونس',
    'ليبيا',
    'السودان',
  ];

  @override
  void dispose() {
    _fullName.dispose();
    _userName.dispose();
    _email.dispose();
    _phone.dispose();
    _age.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _downloadPdf() async {
    final uri = Uri.parse(_pdfUrl);

    final ok = await launchUrl(
      uri,
      mode: LaunchMode.platformDefault,
      webOnlyWindowName: '_blank',
    );

    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذّر فتح رابط التحميل'),
        ),
      );
    }
  }

  void _onDownloadTap() {
    if (widget.onDownload != null) {
      widget.onDownload!.call();
      return;
    }
    _downloadPdf();
  }

  Future<void> _showJoinedDialog() async {
    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        content: const Text(
          'تم إنشاء الحساب بنجاح ✅\nوتم تسجيلك في قائمة الانتظار\nوفي انتظار موافقة المدير',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Alexandria',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF6B4E45),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'موافق',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontWeight: FontWeight.bold,
                color: Color(0xFFAB86B9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_loading) return;

    if (!_submitted) {
      setState(() => _submitted = true);
    }

    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() => _loading = true);

    try {
      final fullName = _fullName.text.trim();
      final userName = _userName.text.trim();
      final mail = _email.text.trim().toLowerCase();
      final phone = _phone.text.trim();
      final ageValue = int.parse(_age.text.trim());
      final password = _password.text.trim();

      final userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mail,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('تعذر إنشاء المستخدم');
      }

      await user.updateDisplayName(userName);

      await FirebaseFirestore.instance
          .collection('UserWatting')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'email': mail,
        'fullName': fullName,
        'userName': userName,
        'phone': phone,
        'age': ageValue,
        'gender': _gender,
        'country': _country,
        'approvalStatus': 'pending',
        'approved': false,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      await _showJoinedDialog();

      _fullName.clear();
      _userName.clear();
      _email.clear();
      _phone.clear();
      _age.text = '26';
      _password.clear();

      setState(() {
        _gender = null;
        _country = null;
        _submitted = false;
        _obscurePassword = true;
      });
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String msg = 'حدث خطأ أثناء إنشاء الحساب';

      if (e.code == 'email-already-in-use') {
        msg = 'هذا البريد الإلكتروني مستخدم مسبقًا';
      } else if (e.code == 'weak-password') {
        msg = 'كلمة المرور ضعيفة جدًا';
      } else if (e.code == 'invalid-email') {
        msg = 'البريد الإلكتروني غير صالح';
      } else if (e.code == 'operation-not-allowed') {
        msg = 'تسجيل البريد الإلكتروني وكلمة المرور غير مفعّل في Firebase';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء الحفظ: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        color: _bg,
        padding: const EdgeInsets.all(14),
        child: LayoutBuilder(
          builder: (context, c) {
            final isWide = c.maxWidth >= 900;

            final guide = _GuideCard(onDownload: _onDownloadTap);

            final form = _JoinPanel(
              formKey: _formKey,
              submitted: _submitted,
              fullName: _fullName,
              userName: _userName,
              email: _email,
              phone: _phone,
              age: _age,
              password: _password,
              gender: _gender,
              country: _country,
              loading: _loading,
              obscurePassword: _obscurePassword,
              onTogglePassword: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              onGenderChanged: (v) => setState(() => _gender = v),
              onCountryChanged: (v) => setState(() => _country = v),
              onSubmit: _handleSubmit,
              countries: allCountriesAr,
            );

            if (!isWide) {
              return Column(
                children: [
                  form,
                  const SizedBox(height: 14),
                  guide,
                ],
              );
            }

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 7, child: form),
                  const SizedBox(width: 14),
                  Expanded(flex: 5, child: guide),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  const _GuideCard({this.onDownload});

  final VoidCallback? onDownload;

  static const _brown = Color(0xFF6B4E45);
  static const _green = Color(0xFF06AC2A);

  @override
  Widget build(BuildContext context) {
    return _SilverShell(
      backgroundColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.menu_book_rounded, size: 16, color: _brown),
                    SizedBox(width: 6),
                    Text(
                      'دليل شطارة',
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: _brown,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  height: 28,
                  child: ElevatedButton.icon(
                    onPressed: onDownload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    icon: const Icon(Icons.download_rounded, size: 16),
                    label: const Text(
                      'تحميل',
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ShataraPdfViewerUniversal(height: 560),
        ],
      ),
    );
  }
}

class _JoinPanel extends StatelessWidget {
  const _JoinPanel({
    required this.formKey,
    required this.submitted,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.phone,
    required this.age,
    required this.password,
    required this.gender,
    required this.country,
    required this.loading,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onGenderChanged,
    required this.onCountryChanged,
    required this.onSubmit,
    required this.countries,
  });

  final GlobalKey<FormState> formKey;
  final bool submitted;
  final TextEditingController fullName;
  final TextEditingController userName;
  final TextEditingController email;
  final TextEditingController phone;
  final TextEditingController age;
  final TextEditingController password;
  final String? gender;
  final String? country;
  final bool loading;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final ValueChanged<String?> onGenderChanged;
  final ValueChanged<String?> onCountryChanged;
  final VoidCallback onSubmit;
  final List<String> countries;

  static const _brown = Color(0xFF6B4E45);
  static const _purple = Color(0xFFAB86B9);

  OutlineInputBorder _sharpBorder([
    Color c = const Color(0xFFE5E7EB),
  ]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: c),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _SilverShell(
      backgroundColor: Colors.transparent,
      child: Form(
        key: formKey,
        autovalidateMode: submitted
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'يرجى تسجيل بياناتك للانضمام إلى قائمة المهتمين بمشروع شطارة',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _brown,
              ),
            ),
            const SizedBox(height: 12),

            _label('اسمك بالكامل'),
            _field(
              controller: fullName,
              suffix: const Icon(Icons.person_outline_rounded, size: 18),
              validator: (v) {
                final t = (v ?? '').trim();
                if (t.isEmpty) return 'مطلوب';
                if (t.length < 3) return 'الاسم قصير';
                return null;
              },
            ),
            const SizedBox(height: 10),

            _label('اسم المستخدم'),
            _field(
              controller: userName,
              suffix: const Icon(Icons.badge_outlined, size: 18),
              validator: (v) {
                final t = (v ?? '').trim();
                if (t.isEmpty) return 'مطلوب';
                if (t.length < 3) return 'اسم المستخدم قصير';
                return null;
              },
            ),
            const SizedBox(height: 10),

            _label('البريد الإلكتروني'),
            _field(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              suffix: const Icon(Icons.alternate_email_rounded, size: 18),
              validator: (v) {
                final t = (v ?? '').trim();
                if (t.isEmpty) return 'مطلوب';
                final ok =
                RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t);
                if (!ok) return 'بريد غير صحيح';
                return null;
              },
            ),
            const SizedBox(height: 10),

            _label('كلمة المرور'),
            _field(
              controller: password,
              obscureText: obscurePassword,
              suffix: IconButton(
                onPressed: onTogglePassword,
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                ),
              ),
              validator: (v) {
                final t = (v ?? '').trim();
                if (t.isEmpty) return 'مطلوب';
                if (t.length < 8) return 'يجب أن تكون 8 أحرف على الأقل';
                return null;
              },
            ),
            const SizedBox(height: 10),

            _label('رقم الهاتف'),
            _field(
              controller: phone,
              keyboardType: TextInputType.phone,
              suffix: const Icon(Icons.phone_outlined, size: 18),
              validator: (v) {
                final t = (v ?? '').trim();
                if (t.isEmpty) return 'مطلوب';
                if (t.length < 7) return 'رقم الهاتف غير صحيح';
                return null;
              },
            ),
            const SizedBox(height: 10),

            _label('الجنس'),
            DropdownButtonFormField<String>(
              value: gender,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              style: const TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 12,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                enabledBorder: _sharpBorder(),
                focusedBorder: _sharpBorder(const Color(0xFFCBD5E1)),
              ),
              items: const ['ذكر', 'أنثى']
                  .map(
                    (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
                  .toList(),
              onChanged: onGenderChanged,
              validator: (v) =>
              (v == null || v.isEmpty) ? 'مطلوب' : null,
            ),
            const SizedBox(height: 10),

            _label('الدولة / الجنسية'),
            DropdownButtonFormField<String>(
              value: country,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              style: const TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 12,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.flag_rounded,
                  size: 18,
                  color: Color(0xFF16A34A),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                enabledBorder: _sharpBorder(),
                focusedBorder: _sharpBorder(const Color(0xFFCBD5E1)),
              ),
              items: countries
                  .map(
                    (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
                  .toList(),
              onChanged: onCountryChanged,
              validator: (v) =>
              (v == null || v.isEmpty) ? 'مطلوب' : null,
            ),
            const SizedBox(height: 10),

            _label('العمر'),
            _field(
              controller: age,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              validator: (v) {
                final t = (v ?? '').trim();
                if (t.isEmpty) return 'مطلوب';
                final n = int.tryParse(t);
                if (n == null) return 'رقم فقط';
                if (n < 5 || n > 120) return 'غير صحيح';
                return null;
              },
            ),
            const SizedBox(height: 14),

            SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: loading ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _purple,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                child: loading
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text(
                  'انضم',
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Alexandria',
          fontSize: 10,
          color: Color(0xFF6B7280),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    TextInputType? keyboardType,
    Widget? suffix,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
  }) {
    OutlineInputBorder border([
      Color c = const Color(0xFFE5E7EB),
    ]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: c),
      );
    }

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      style: const TextStyle(
        fontFamily: 'Alexandria',
        fontSize: 12,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffix,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: border(),
        focusedBorder: border(const Color(0xFFCBD5E1)),
      ),
    );
  }
}

class _SilverShell extends StatelessWidget {
  const _SilverShell({
    required this.child,
    required this.backgroundColor,
  });

  final Widget child;
  final Color backgroundColor;

  static const _silver = Color(0xFFC0C0C0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: _silver, width: 1),
      ),
      child: child,
    );
  }
}