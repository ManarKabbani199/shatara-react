import 'package:flutter/material.dart';

class ExperienceTabs extends StatefulWidget {
  const ExperienceTabs({super.key});

  @override
  State<ExperienceTabs> createState() => _ExperienceTabsState();
}

class _ExperienceTabsState extends State<ExperienceTabs> {
  int _selectedIndex = 0;

  final List<String> tabs = ['إثراء التجربة', 'بناء المجتمع', 'تمكين اللاعب'];
  final List<String> tabContents = [
    'توسيع آفاق التفكير وزيادة المتعة عبر “جيش الاحتياط”، الفرص المحتملة ، والتحديات المتجددة.',
    'مجتمع رقمي متفاعل يربط اللاعبين ويوفّر بيئة للتحدي والتعلم وتبادل الخبرات.',
    'نطوّر مهارات اللاعبين عبر أدوات تحليل، وتحديات، ومحتوى تدريبي ذكي وشامل.'
  ];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      color: const Color(0xFFAB86B9),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصورة
            Expanded(
              flex: 1,
              child: Center(
                child: Image.asset(
                  'assets/ress.PNG',
                  width: isMobile ? 80 : 240,
                ),
              ),
            ),
            const SizedBox(width: 20),
            // النصوص والتبويبات
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SelectableText(
                      'رسالتنا',
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        fontSize: isMobile ? 25 : 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTabs(isMobile),
                  const SizedBox(height: 16),

                  Center(child: _buildTabContent(isMobile)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(tabs.length, (index) {
        final isSelected = index == _selectedIndex;
        return GestureDetector(
          onTap: () {
            setState(() => _selectedIndex = index);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFAB86B9) : Colors.white,
              border: Border.all(color: const Color(0xFFDDDDDC)),
            ),
            child: Text(
              tabs[index],
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 7 : 14,
                color: isSelected ? Colors.white : const Color(0xFF6B4E45),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTabContent(bool isMobile) {
    return SelectableText(
      tabContents[_selectedIndex],
      style: TextStyle(
        fontFamily: 'Alexandria',
        fontSize: isMobile ? 10 : 15,
        color: Colors.white,
      ),
      textAlign: TextAlign.right,
    );
  }
}
