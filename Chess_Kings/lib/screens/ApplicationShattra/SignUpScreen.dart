import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../TermsAndConditionsPage.dart';
import 'LoginScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  bool obscurePassword = true;
  bool agreeToTerms = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String? selectedGender;
  String? selectedCountry;

  final List<String> genders = ['ذكر', 'أنثى'];

  final List<String> countries = const [
    'أفغانستان',
    'ألبانيا',
    'الجزائر',
    'أندورا',
    'أنغولا',
    'أنتيغوا وباربودا',
    'الأرجنتين',
    'أرمينيا',
    'أستراليا',
    'النمسا',
    'أذربيجان',
    'جزر البهاما',
    'البحرين',
    'بنغلاديش',
    'بربادوس',
    'بيلاروس',
    'بلجيكا',
    'بليز',
    'بنين',
    'بوتان',
    'بوليفيا',
    'البوسنة والهرسك',
    'بوتسوانا',
    'البرازيل',
    'بروناي',
    'بلغاريا',
    'بوركينا فاسو',
    'بوروندي',
    'الرأس الأخضر',
    'كمبوديا',
    'الكاميرون',
    'كندا',
    'جمهورية أفريقيا الوسطى',
    'تشاد',
    'تشيلي',
    'الصين',
    'كولومبيا',
    'جزر القمر',
    'الكونغو (جمهورية)',
    'الكونغو الديمقراطية',
    'كوستاريكا',
    'ساحل العاج',
    'كرواتيا',
    'كوبا',
    'قبرص',
    'التشيك',
    'الدنمارك',
    'جيبوتي',
    'دومينيكا',
    'جمهورية الدومينيكان',
    'تيمور الشرقية',
    'الإكوادور',
    'مصر',
    'السلفادور',
    'غينيا الاستوائية',
    'إريتريا',
    'إستونيا',
    'إسواتيني',
    'إثيوبيا',
    'فيجي',
    'فنلندا',
    'فرنسا',
    'الغابون',
    'غامبيا',
    'جورجيا',
    'ألمانيا',
    'غانا',
    'اليونان',
    'غرينادا',
    'غواتيمالا',
    'غينيا',
    'غينيا بيساو',
    'غيانا',
    'هايتي',
    'هندوراس',
    'المجر',
    'آيسلندا',
    'الهند',
    'إندونيسيا',
    'إيران',
    'العراق',
    'أيرلندا',
    'إيطاليا',
    'جامايكا',
    'اليابان',
    'الأردن',
    'كازاخستان',
    'كينيا',
    'كيريباتي',
    'كوريا الشمالية',
    'كوريا الجنوبية',
    'الكويت',
    'قيرغيزستان',
    'لاوس',
    'لاتفيا',
    'لبنان',
    'ليسوتو',
    'ليبيريا',
    'ليبيا',
    'ليختنشتاين',
    'ليتوانيا',
    'لوكسمبورغ',
    'مدغشقر',
    'مالاوي',
    'ماليزيا',
    'جزر المالديف',
    'مالي',
    'مالطا',
    'جزر مارشال',
    'موريتانيا',
    'موريشيوس',
    'المكسيك',
    'ميكرونيزيا',
    'مولدوفا',
    'موناكو',
    'منغوليا',
    'الجبل الأسود',
    'المغرب',
    'موزمبيق',
    'ميانمار',
    'ناميبيا',
    'ناورو',
    'نيبال',
    'هولندا',
    'نيوزيلندا',
    'نيكاراغوا',
    'النيجر',
    'نيجيريا',
    'مقدونيا الشمالية',
    'النرويج',
    'عُمان',
    'باكستان',
    'بالاو',
    'بنما',
    'بابوا غينيا الجديدة',
    'باراغواي',
    'بيرو',
    'الفلبين',
    'بولندا',
    'البرتغال',
    'قطر',
    'رومانيا',
    'روسيا',
    'رواندا',
    'سانت كيتس ونيفيس',
    'سانت لوسيا',
    'سانت فنسنت وجزر غرينادين',
    'ساموا',
    'سان مارينو',
    'ساو تومي وبرينسيب',
    'السعودية',
    'السنغال',
    'صربيا',
    'سيشل',
    'سيراليون',
    'سنغافورة',
    'سلوفاكيا',
    'سلوفينيا',
    'جزر سليمان',
    'الصومال',
    'جنوب أفريقيا',
    'جنوب السودان',
    'إسبانيا',
    'سريلانكا',
    'السودان',
    'سورينام',
    'السويد',
    'سويسرا',
    'سوريا',
    'طاجيكستان',
    'تنزانيا',
    'تايلاند',
    'توغو',
    'تونغا',
    'ترينيداد وتوباغو',
    'تونس',
    'تركيا',
    'تركمانستان',
    'توفالو',
    'أوغندا',
    'أوكرانيا',
    'الإمارات',
    'المملكة المتحدة',
    'الولايات المتحدة',
    'أوروغواي',
    'أوزبكستان',
    'فانواتو',
    'الفاتيكان',
    'فلسطين',
    'فنزويلا',
    'فيتنام',
    'اليمن',
    'زامبيا',
    'زيمبابوي',
  ];

  static const Color primaryColor = Color(0xFFB08AC4);
  static const Color textColor = Color(0xFF6B4E45);
  static const Color borderColor = Color(0xFFD9D9D9);
  static const Color backgroundColor = Color(0xFFF7F7F7);

  @override
  void dispose() {
    fullNameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    ageController.dispose();
    super.dispose();
  }

  InputDecoration _dropdownDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 13,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      suffixIcon: Icon(
        icon,
        color: textColor.withOpacity(0.75),
        size: 20,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.2,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 13,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      suffixIcon: Icon(
        icon,
        color: textColor.withOpacity(0.75),
        size: 20,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.2,
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFamily: 'Alexandria',
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 42,
          decoration: BoxDecoration(
            color: isActive ? primaryColor : Colors.white,
            border: Border.all(
              color: isActive ? primaryColor : borderColor,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Alexandria',
            ),
          ),
        ),
      ),
    );
  }

  void _showWaitingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEBDCF3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 42,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'تم تسجيلك في الموقع',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Alexandria',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'تم استلام طلبك بنجاح\nوهو الآن بانتظار موافقة المدير.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: textColor,
                    fontFamily: 'Alexandria',
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'حسناً',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Alexandria',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب الموافقة على الشروط والأحكام أولاً'),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final fullName = fullNameController.text.trim();
      final userName = userNameController.text.trim();
      final email = emailController.text.trim().toLowerCase();
      final phone = phoneController.text.trim();
      final password = passwordController.text.trim();
      final age = int.parse(ageController.text.trim());
      final gender = selectedGender!;
      final country = selectedCountry!;

      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance.collection('UserWatting').doc(email).set({
        'uid': credential.user?.uid,
        'fullName': fullName,
        'userName': userName,
        'email': email,
        'phone': phone,
        'age': age,
        'gender': gender,
        'country': country,
        'agreedToTerms': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      _showWaitingDialog();

      fullNameController.clear();
      userNameController.clear();
      emailController.clear();
      phoneController.clear();
      passwordController.clear();
      ageController.clear();

      setState(() {
        selectedGender = null;
        selectedCountry = null;
        agreeToTerms = false;
      });
    } on FirebaseAuthException catch (e) {
      String message = 'حدث خطأ أثناء إنشاء الحساب';

      if (e.code == 'email-already-in-use') {
        message = 'هذا البريد مستخدم مسبقًا';
      } else if (e.code == 'weak-password') {
        message = 'كلمة المرور ضعيفة جدًا';
      } else if (e.code == 'invalid-email') {
        message = 'البريد الإلكتروني غير صحيح';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),

                      Column(
                        children: [
                          Image.asset(
                            'assets/logoapp.png',
                            height: 70,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'عضو جديد في شطارة؟',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 21,
                              fontFamily: 'Alexandria',
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'مرحبًا بك! يمكنك الإنضمام إلينا عن طريق\nإنشاء حساب جديد',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: textColor,
                              fontFamily: 'Alexandria',
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      Row(
                        children: [
                          _buildTabButton(
                            title: 'تسجيل الدخول',
                            isActive: false,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                          ),
                          _buildTabButton(
                            title: 'إنشاء حساب',
                            isActive: true,
                            onTap: () {},
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      _buildLabel('الاسم الكامل'),
                      TextFormField(
                        controller: fullNameController,
                        textInputAction: TextInputAction.next,
                        decoration: _inputDecoration(
                          hint: 'الاسم الكامل',
                          icon: Icons.person_outline,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال الاسم الكامل';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      _buildLabel('اسم المستخدم'),
                      TextFormField(
                        controller: userNameController,
                        textInputAction: TextInputAction.next,
                        decoration: _inputDecoration(
                          hint: 'الاسم',
                          icon: Icons.alternate_email,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال اسم المستخدم';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      _buildLabel('البريد الإلكتروني'),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: _inputDecoration(
                          hint: 'm@example.com',
                          icon: Icons.mail_outline,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال البريد الإلكتروني';
                          }
                          if (!value.contains('@')) {
                            return 'بريد إلكتروني غير صحيح';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      _buildLabel('رقم الهاتف'),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: _inputDecoration(
                          hint: '+966 10 10 10',
                          icon: Icons.phone_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال رقم الهاتف';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      _buildLabel('العمر'),
                      TextFormField(
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        decoration: _inputDecoration(
                          hint: 'مثال: 26',
                          icon: Icons.cake_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال العمر';
                          }
                          final age = int.tryParse(value);
                          if (age == null) {
                            return 'يرجى إدخال أرقام فقط';
                          }
                          if (age < 5 || age > 100) {
                            return 'يرجى إدخال عمر صحيح';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      _buildLabel('الجنس'),
                      DropdownButtonFormField<String>(
                        value: selectedGender,
                        decoration: _dropdownDecoration(
                          hint: 'اختر الجنس',
                          icon: Icons.person_2_outlined,
                        ),
                        items: genders.map((gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى اختيار الجنس';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      _buildLabel('البلد'),
                      DropdownButtonFormField<String>(
                        value: selectedCountry,
                        decoration: _dropdownDecoration(
                          hint: 'اختر البلد',
                          icon: Icons.public_outlined,
                        ),
                        items: countries.map((country) {
                          return DropdownMenuItem<String>(
                            value: country,
                            child: Text(country),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCountry = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى اختيار البلد';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      _buildLabel('كلمة المرور'),
                      TextFormField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                            icon: Icon(
                              obscurePassword
                                  ? Icons.lock_outline
                                  : Icons.lock_open_outlined,
                              color: textColor.withOpacity(0.75),
                              size: 20,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: const BorderSide(color: borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: const BorderSide(
                              color: primaryColor,
                              width: 1.2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال كلمة المرور';
                          }
                          if (value.length < 6) {
                            return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: agreeToTerms,
                            activeColor: primaryColor,
                            onChanged: (value) {
                              setState(() {
                                agreeToTerms = value ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: Wrap(
                              children: [
                                const Text(
                                  'أنا أوافق على ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: textColor,
                                    fontFamily: 'Alexandria',
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const TermsAndConditionsPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'الشروط والأحكام',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      fontFamily: 'Alexandria',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                              : const Text(
                            'إنشاء حساب',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}