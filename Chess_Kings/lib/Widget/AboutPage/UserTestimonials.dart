import 'package:flutter/material.dart';

class UserTestimonials extends StatefulWidget {
  const UserTestimonials({super.key});

  @override
  State<UserTestimonials> createState() => _UserTestimonialsState();
}

class _UserTestimonialsState extends State<UserTestimonials> {
  final PageController _controller = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  final List<Map<String, String>> testimonials = [
    {
      'name': 'اسم المستخدم',
      'role': 'مستخدم عادي',
      'text': 'المجتمع في شطارة ساهم في تعلّمي وتطوري بسرعة ملحوظة.',
    },
    {
      'name': 'اسم المستخدم',
      'role': 'مستخدم عادي',
      'text': 'نظام جيش الاحتياط أضفى بُعدًا تكتيكيًا لم أجده في أي لعبة شطرنج أخرى.',
    },
  ];

  void _next() {
    if (_currentPage < testimonials.length - 1) {
      _currentPage++;
      _controller.animateToPage(_currentPage,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  void _previous() {
    if (_currentPage > 0) {
      _currentPage--;
      _controller.animateToPage(_currentPage,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'آراء مستخدمينا',
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6B4E45),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _previous,
                icon: const Icon(Icons.arrow_back),
                color: const Color(0xFF6B4E45),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFDDDDDC),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _next,
                icon: const Icon(Icons.arrow_forward),
                color: Colors.white,
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFAB86B9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _controller,
              itemCount: testimonials.length,
              itemBuilder: (context, index) {
                final item = testimonials[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFAB86B9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person, size: 40, color: Colors.white),
                      const SizedBox(height: 8),
                      Text(
                        item['name']!,
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item['role']!,
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item['text']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: isMobile ? 13 : 15,
                          color: Colors.white,
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
    );
  }
}
