import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RankEntry {
  final String avatar; // مسار صورة اللاعب
  final String name;   // الاسم
  final String handle; // اليوزر مثل @Nour
  final String iso2;   // كود الدولة ISO-2 مثل SA, SY
  const RankEntry({
    required this.avatar,
    required this.name,
    required this.handle,
    required this.iso2,
  });
}

class ShataraTopListWidget extends StatelessWidget {
  const ShataraTopListWidget({
    super.key,
    required this.entries, // يتوقع 6 عناصر (الصفوف 2..7)
  });

  /// الصفوف (من الثاني إلى السابع)
  final List<RankEntry> entries;

  static const _brandTextBlack = Colors.black;
  static const _brandTextGray = Colors.black45;
  static const _ctaBg = Color(0xFFAB86B9);
  static const _brown = Color(0xFF6B4E45);

  double _fs(BuildContext context, {required double regular, required double mobile}) {
    final w = MediaQuery.of(context).size.width;
    return w < 600 ? mobile : regular;
  }

  TextStyle _nameStyle(BuildContext context) => TextStyle(
    fontFamily: 'Alexandria',
    fontWeight: FontWeight.w700,
    color: _brandTextBlack,
    fontSize: _fs(context, regular: 13, mobile: 9),
    height: 1.2,
  );

  TextStyle _handleStyle(BuildContext context) => TextStyle(
    fontFamily: 'Alexandria',
    fontWeight: FontWeight.w700,
    color: _brandTextGray,
    fontSize: _fs(context, regular: 9, mobile: 7),
    height: 1.2,
  );

  Widget _thinDivider() => Divider(thickness: 0.5, color: Colors.grey.shade300, height: 24);

  /// تحويل كود الدولة ISO-2 إلى إيموجي علم
  String _flagEmoji(String iso2) {
    if (iso2.length != 2) return '🏳️';
    final base = 0x1F1E6;
    final first = iso2.toUpperCase().codeUnitAt(0) - 0x41 + base;
    final second = iso2.toUpperCase().codeUnitAt(1) - 0x41 + base;
    return String.fromCharCodes([first, second]);
  }

  @override
  Widget build(BuildContext context) {
    // تأكيد أن لدينا 6 عناصر على الأقل (للصفوف 2..7)
    final list = entries.length >= 6 ? entries.take(6).toList() : [
      ...entries,
      ...List.generate(6 - entries.length, (_) => const RankEntry(
        avatar: 'assets/ooo.png', name: 'Nour', handle: '@Nour', iso2: 'SA',
      )),
    ];

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
              // الهيدر القابل للضغط
              Container(
                color: Colors.black, // خلفية سوداء
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                child: SizedBox(
                  height: 36,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // أقصى اليمين: بيلتز + سهم (زر)
                      InkWell(
                        onTap: () => _showTimeControlsSheet(context),
                        borderRadius: BorderRadius.circular(6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'بيلتز',
                              style: TextStyle(
                                fontFamily: 'Alexandria',
                                fontWeight: FontWeight.w700,
                                color: _brown,
                                fontSize: _fs(context, regular: 17, mobile: 12),
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.expand_more, size: 18, color: _brown),
                          ],
                        ),
                      ),

                      // أقصى الشمال: أيقونة الكرة الأرضية + عالمي (زر)
                      InkWell(
                        onTap: () => _showCountrySheet(context),
                        borderRadius: BorderRadius.circular(6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.public, size: 21, color: _brown),
                            SizedBox(width: 6),
                            Text(
                              'عالمي',
                              style: TextStyle(
                                fontFamily: 'Alexandria',
                                fontWeight: FontWeight.w700,
                                color: _brown,
                                fontSize: 12,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // الصفوف 2..7 من القائمة
              _rankRow(context, entry: list[0]),
              _rankRow(context, entry: list[1]),
              _rankRow(context, entry: list[2]),
              _rankRow(context, entry: list[3]),
              _rankRow(context, entry: list[4]),

              // الصف الثامن: خط + زر "عرض الكل"
              const SizedBox(height: 16),
              _thinDivider(),
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
                  onPressed: () => _showTopPlayersDialog(context),
                  child: const Text(
                    'عرض الكل',
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 14,
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

  Widget _rankRow(BuildContext context, {required RankEntry entry}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // من اليمين: الصورة
          ClipRRect(
            borderRadius: BorderRadius.zero,
            child: Image.asset(
              entry.avatar,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),

          // الاسم واليوزر
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.name, style: _nameStyle(context)),
                Text(entry.handle, style: _handleStyle(context)),
              ],
            ),
          ),

          const SizedBox(width: 30),

          // إيموجي العلم
          Text(
            _flagEmoji(entry.iso2),
            style: TextStyle(fontSize: _fs(context, regular: 20, mobile: 18)),
          ),
          const SizedBox(width: 10),

          // trophy.png في اليسار
          const Image(
            image: AssetImage('assets/trophy.png'),
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  // ===== Helpers =====

  String _iso2FromPhone(String? phone) {
    if (phone == null) return 'SA';
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return 'SA';

    const codeToIso2 = {
      '966': 'SA','20':'EG','971':'AE','973':'BH','965':'KW','974':'QA','968':'OM',
      '962':'JO','961':'LB','963':'SY','964':'IQ','970':'PS','967':'YE',
      '212':'MA','213':'DZ','216':'TN','218':'LY','249':'SD',
    };

    for (final len in [3, 2]) {
      if (digits.length >= len) {
        final key = digits.substring(0, len);
        final iso = codeToIso2[key];
        if (iso != null) return iso;
      }
    }
    return 'SA';
  }

  int _asWins(dynamic v) {
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  // ===== بيلتز: قائمة الأوقات =====
  /// BottomSheet: أوضاع الوقت (بيلتز)
  Future<void> _showTimeControlsSheet(BuildContext context) async {
    final options = <Map<String, String>>[
      {'label': '1+0 (Bullet)', 'value': '1+0'},
      {'label': '3+0 (Bullet)', 'value': '3+0'},
      {'label': '10+0 (Rapid)', 'value': '10+0'},
      {'label': '30+0 (Classical)', 'value': '30+0'},
    ];

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: options.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (ctx, i) {
            final o = options[i];
            return ListTile(
              title: Text(
                o['label']!,
                style: const TextStyle(fontFamily: 'Alexandria'),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _showPlayersByGameType(context, o['value']!);
              },
            );
          },
        ),
      ),
    );
  }

  /// دايالوج: عرض اللاعبين حسب نوع اللعبة (gameType)
  Future<void> _showPlayersByGameType(BuildContext context, String gameType) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'اللاعبون في نمط $gameType',
              style: const TextStyle(fontFamily: 'Alexandria', fontWeight: FontWeight.w700),
            ),
            content: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('games')
                  .where('gameType', isEqualTo: gameType)
                  .where('wins', isEqualTo: 1)
                  .get(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()));
                }
                if (snap.hasError) {
                  return Text('خطأ: ${snap.error}');
                }
                final docs = snap.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Text('لا يوجد أي فائز في هذا النمط بعد.');
                }

                // نحسب عدد مرات الفوز لكل لاعب
                final Map<String, int> winCount = {};
                for (final d in docs) {
                  final data = d.data() as Map<String, dynamic>;
                  final player = data['playerNumber'] ?? 'غير معروف';
                  winCount[player] = (winCount[player] ?? 0) + 1;
                }

                // ترتيب اللاعبين حسب عدد الفوز
                final sorted = winCount.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value));

                return SizedBox(
                  width: 420,
                  height: 420,
                  child: ListView.separated(
                    itemCount: sorted.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final playerId = sorted[i].key;
                      final wins = sorted[i].value;

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('users').doc(playerId).get(),
                        builder: (ctx, userSnap) {
                          if (!userSnap.hasData) {
                            return const ListTile(
                              title: Text('جاري التحميل...', style: TextStyle(fontFamily: 'Alexandria')),
                            );
                          }

                          final user = userSnap.data!.data() as Map<String, dynamic>? ?? {};
                          final name = user['username'] ?? user['name'] ?? 'مجهول';
                          final phone = user['phone_number']?.toString();
                          final iso2 = _iso2FromPhone(phone);

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey.shade200,
                              child: Text('${i + 1}', style: const TextStyle(color: Color(0xFF6B4E45))),
                            ),
                            title: Text(
                              name,
                              style: const TextStyle(
                                fontFamily: 'Alexandria',
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            subtitle: Text(
                              'عدد الفوز: $wins',
                              style: const TextStyle(
                                fontFamily: 'Alexandria',
                                color: Color(0xFFA32B37),
                              ),
                            ),
                            trailing: Text(_flagEmoji(iso2), style: const TextStyle(fontSize: 22)),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('إغلاق', style: TextStyle(fontFamily: 'Alexandria')),
              ),
            ],
          ),
        );
      },
    );
  }


  // ===== عالمي: قائمة الدول ثم عرض لاعبي الدولة المختارة =====
  Future<void> _showCountrySheet(BuildContext context) async {
    final countries = <Map<String, String>>[
      {'iso2': 'SA', 'name': 'السعودية'},
      {'iso2': 'AE', 'name': 'الإمارات'},
      {'iso2': 'QA', 'name': 'قطر'},
      {'iso2': 'KW', 'name': 'الكويت'},
      {'iso2': 'OM', 'name': 'عُمان'},
      {'iso2': 'BH', 'name': 'البحرين'},
      {'iso2': 'EG', 'name': 'مصر'},
      {'iso2': 'JO', 'name': 'الأردن'},
      {'iso2': 'LB', 'name': 'لبنان'},
      {'iso2': 'SY', 'name': 'سوريا'},
      {'iso2': 'IQ', 'name': 'العراق'},
      {'iso2': 'YE', 'name': 'اليمن'},
      {'iso2': 'PS', 'name': 'فلسطين'},
      {'iso2': 'MA', 'name': 'المغرب'},
      {'iso2': 'DZ', 'name': 'الجزائر'},
      {'iso2': 'TN', 'name': 'تونس'},
      {'iso2': 'LY', 'name': 'ليبيا'},
      {'iso2': 'SD', 'name': 'السودان'},
      // أضف دولًا أخرى عند الحاجة
    ];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              const Text('اختر الدولة', style: TextStyle(fontFamily: 'Alexandria', fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: countries.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final c = countries[i];
                    final iso = c['iso2']!;
                    final name = c['name']!;
                    return ListTile(
                      leading: Text(_flagEmoji(iso), style: const TextStyle(fontSize: 22)),
                      title: Text(name, style: const TextStyle(fontFamily: 'Alexandria')),
                      onTap: () {
                        Navigator.pop(ctx);
                        _showPlayersByCountryDialog(context, iso2: iso, countryName: name);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // خريطة: ISO2 -> قائمة أكواد الهاتف (prefixes)
  Map<String, List<String>> get _iso2ToCodes {
    const codeToIso2 = {
      '966': 'SA','20':'EG','971':'AE','973':'BH','965':'KW','974':'QA','968':'OM',
      '962':'JO','961':'LB','963':'SY','964':'IQ','970':'PS','967':'YE',
      '212':'MA','213':'DZ','216':'TN','218':'LY','249':'SD',
    };
    final m = <String, List<String>>{};
    codeToIso2.forEach((code, iso) {
      m.putIfAbsent(iso, () => []).add(code);
    });
    return m;
  }

  List<String> _countryPrefixes(String iso2) => _iso2ToCodes[iso2] ?? const [];

  /// جلب المستخدمين الذين يبدأ رقمهم بـ prefix (يدعم عدة prefixes ويزيل التكرار)
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _fetchUsersByPhonePrefixes(
      List<String> prefixes,
      ) async {
    final fs = FirebaseFirestore.instance;
    final out = <QueryDocumentSnapshot<Map<String, dynamic>>>[];

    for (final raw in prefixes) {
      final prefix = raw.startsWith('+') ? raw : '+$raw';
      final snap = await fs
          .collection('users')
          .orderBy('phone_number')
          .startAt([prefix])
          .endAt(['$prefix\uf8ff'])
          .get();

      for (final d in snap.docs) {
        if (!out.any((e) => e.id == d.id)) out.add(d);
      }
    }
    return out;
  }

  /// دايالوج: لاعبو الدولة المختارة مرتّبين حسب wins تنازليًا
  Future<void> _showPlayersByCountryDialog(
      BuildContext context, {
        required String iso2,
        required String countryName,
      }) async {
    final prefixes = _countryPrefixes(iso2);

    await showDialog(
      context: context,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'لاعبو $countryName ${_flagEmoji(iso2)}',
              style: const TextStyle(fontFamily: 'Alexandria', fontWeight: FontWeight.w700),
            ),
            content: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
              future: _fetchUsersByPhonePrefixes(prefixes),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const SizedBox(height: 140, child: Center(child: CircularProgressIndicator()));
                }
                if (snap.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('حدث خطأ: ${snap.error}'),
                  );
                }
                final docs = snap.data ?? [];
                if (docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('لا يوجد لاعبون من هذه الدولة حتى الآن'),
                  );
                }

                final players = docs.map((d) => d.data()).toList()
                  ..sort((a, b) => _asWins(b['wins']).compareTo(_asWins(a['wins'])));

                return SizedBox(
                  width: 420,
                  height: 460,
                  child: ListView.separated(
                    itemCount: players.length,
                    separatorBuilder: (_, __) => Divider(height: 16, color: Colors.grey.shade200),
                    itemBuilder: (_, i) {
                      final data = players[i];
                      final name = (data['username'] ?? data['name'] ?? 'مجهول').toString();
                      final wins = _asWins(data['wins']);
                      final phone = data['phone_number']?.toString();
                      final userIso = _iso2FromPhone(phone);

                      return ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey.shade200,
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _brown,
                            ),
                          ),
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(
                            fontFamily: 'Alexandria',
                            fontWeight: FontWeight.w700,
                            color: Colors.deepPurple,
                          ),
                        ),
                        subtitle: Text(
                          'wins $wins',
                          style: const TextStyle(
                            fontFamily: 'Alexandria',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFA32B37),
                          ),
                        ),
                        trailing: Text(_flagEmoji(userIso), style: const TextStyle(fontSize: 22)),
                      );
                    },
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('إغلاق', style: TextStyle(fontFamily: 'Alexandria')),
              ),
            ],
          ),
        );
      },
    );
  }

  // ===== دايالوج: أفضل اللاعبين عمومًا =====
  Future<void> _showTopPlayersDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text(
              'أفضل اللاعبين',
              style: TextStyle(fontFamily: 'Alexandria', fontWeight: FontWeight.w700),
            ),
            content: SizedBox(
              width: 420,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .orderBy('wins', descending: true)
                    .limit(50)
                    .snapshots(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()));
                  }
                  if (!snap.hasData || snap.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('لا يوجد لاعبون حتى الآن'),
                    );
                  }

                  final docs = snap.data!.docs;

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => Divider(height: 16, color: Colors.grey.shade200),
                    itemBuilder: (context, i) {
                      final data = docs[i].data() as Map<String, dynamic>;
                      final name = (data['username'] ?? data['name'] ?? 'مجهول').toString();
                      final wins = _asWins(data['wins']);
                      final iso2 = _iso2FromPhone(data['phone_number']?.toString());

                      return ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey.shade200,
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _brown,
                            ),
                          ),
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(
                            fontFamily: 'Alexandria',
                            fontWeight: FontWeight.w700,
                            color: Colors.deepPurple,
                          ),
                        ),
                        subtitle: Text(
                          'wins $wins',
                          style: const TextStyle(
                            fontFamily: 'Alexandria',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFA32B37),
                          ),
                        ),
                        trailing: Text(
                          _flagEmoji(iso2),
                          style: const TextStyle(fontSize: 22),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('إغلاق', style: TextStyle(fontFamily: 'Alexandria')),
              ),
            ],
          ),
        );
      },
    );
  }
}
