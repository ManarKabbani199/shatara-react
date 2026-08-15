import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/tweet_model.dart';
import '../../screens/Tweet/ChatScreen.dart';
import '../../screens/Tweet/MyTweets.dart';
import '../../screens/Tweet/SearchAndTrendsScreen.dart';
import '../../screens/Tweet/StatsScreen.dart';
import '../../screens/Tweet/TweetDetailScreen.dart';
import '../../screens/Tweet/TweetsFriend.dart';
import '../../screens/Tweet/TweetsProfile.dart';
import '../../screens/Tweet/TweetsSave.dart';
import '../../screens/Tweet/edit_profile_screen.dart';
import '../../screens/Tweet/followers_screen.dart';
import '../../models/UserModel.dart';
import '../../screens/Tweet/profile_screen.dart';
import '../../shared_data.dart' as shared;

class CustomSidebar extends StatelessWidget {
  final bool isInDrawer;
  final UserModel user;
  final String currentUserId;
  final int unreadMessages;
  final int unreadNotifications;

  const CustomSidebar({
    super.key,
    this.isInDrawer = false,
    required this.user,
    required this.currentUserId,
    required this.unreadMessages,
    required this.unreadNotifications,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    final sidebarContent = Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: !isInDrawer,
        children: [
          Container(
            color: const Color(0xFFD3B3D6),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.home, color: Colors.white, size: isMobile ? 18 : 24),
                const SizedBox(width: 8),
                Text(
                  'الرئيسية',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 13 : 16,
                    fontFamily: 'Alexandria',
                  ),
                ),
              ],
            ),
          ),

          _buildMenuItem(
            context,
            Icons.edit,
            'تعديل بروفايل',
            EditProfileScreen(user: user),
            isMobile,
          ),

          // رسائل (بادج من notifications:type=message)
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('notifications')
                .where('to', isEqualTo: currentUserId)
                .where('type', isEqualTo: 'message')
                .snapshots(),
            builder: (context, snap) {
              final int count = snap.hasData ? snap.data!.docs.length : 0;
              print('💬 message notifs for $currentUserId = $count');

              return _buildMenuItem(
                context,
                null,
                'رسائل',
                null,
                isMobile,
                trailing: null,
                onTap: () => _showMessagesDialog(context),
                leadingWidget: _notificationIconWithBadge(Icons.message, count, isMobile),
              );
            },
          ),

          // التنبيهات (كل الأنواع)
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('notifications')
                .where('to', isEqualTo: currentUserId)
                .snapshots(),
            builder: (context, snap) {
              final int count = snap.hasData ? snap.data!.docs.length : 0;
              print('🔔 sidebar count for $currentUserId = $count');

              return _buildMenuItem(
                context,
                null,
                'التنبيهات',
                null,
                isMobile,
                trailing: (count > 0)
                    ? Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => _showNotificationsDialog(context),
                    child: Text(
                      'لديك إشعارات جديدة ($count)',
                      style: const TextStyle(
                        fontFamily: 'Alexandria',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFAB86B9),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                )
                    : null,
                onTap: () => _showNotificationsDialog(context),
                leadingWidget: _notificationIconWithBadge(Icons.notifications, count, isMobile),
              );
            },
          ),

          _buildMenuItem(
            context,
            Icons.person_add_alt,
            'أضف أصدقاء',
            FollowersScreen(title: 'جميع المستخدمين'),
            isMobile,
          ),
          _buildMenuItem(
              context, Icons.bookmark_border, 'محفوظاتي', TweetsSave(userId: shared.id_user), isMobile),
          _buildMenuItem(
              context, Icons.chat_bubble_outline, 'تغريداتي', MyTweets(userId: shared.id_user), isMobile),
          _buildMenuItem(
              context, Icons.trending_up, 'المواضيع الشائعه', SearchAndTrendsScreen(), isMobile),
          _buildMenuItem(
              context, Icons.groups, 'مجتمع شطارة', TweetsProfile(userId: shared.id_user), isMobile),
          _buildMenuItem(
              context, Icons.flag_outlined, 'مجتمعي', TweetsFriend(userId: shared.id_user), isMobile),
          _buildMenuItem(
              context, Icons.bar_chart, 'إحصائيات', StatsScreen(), isMobile),
        ],
      ),
    );

    return isInDrawer
        ? Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: sidebarContent,
    )
        : sidebarContent;
  }

  // عنصر القائمة الموحد
  static Widget _buildMenuItem(
      BuildContext context,
      IconData? icon,
      String title,
      Widget? page,
      bool isMobile, {
        Widget? trailing,
        VoidCallback? onTap,
        Widget? leadingWidget,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/backMenu.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 3)),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        visualDensity: isMobile ? const VisualDensity(horizontal: -2, vertical: -2) : VisualDensity.standard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minLeadingWidth: 0,
        leading: leadingWidget ?? Icon(icon, color: Colors.brown, size: isMobile ? 18 : 24),
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.brown,
              fontSize: isMobile ? 13.5 : 15,
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        trailing: trailing,
        onTap: () {
          final scaffoldState = Scaffold.maybeOf(context);
          final isDrawerOpen = scaffoldState?.isDrawerOpen ?? false;
          if (isDrawerOpen) Navigator.of(context).pop();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (onTap != null) {
              onTap();
            } else if (page != null) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => page));
            }
          });
        },
      ),
    );
  }

  // شارة صغيرة
  static Widget _buildBadge(int count, bool isMobile) {
    if (count <= 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
      constraints: BoxConstraints(minWidth: isMobile ? 16 : 20, minHeight: isMobile ? 16 : 20),
      child: Center(
        child: Text(
          '$count',
          style: TextStyle(color: Colors.white, fontSize: isMobile ? 10 : 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // أيقونة مع بادج
  static Widget _notificationIconWithBadge(IconData icon, int count, bool isMobile) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon, color: Colors.brown, size: isMobile ? 18 : 24),
        if (count > 0)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              constraints: BoxConstraints(minWidth: isMobile ? 14 : 16, minHeight: isMobile ? 14 : 16),
              child: Center(
                child: Text(
                  '${count > 99 ? 99 : count}',
                  style: TextStyle(color: Colors.white, fontSize: isMobile ? 8 : 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ====== نافذة الإشعارات ======
  Future<void> _showNotificationsDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "الإشعارات",
                              style: TextStyle(
                                fontFamily: 'Alexandria',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFAB86B9),
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(height: 4),
                            Text(
                              "الإشعارات الجديدة",
                              style: TextStyle(
                                fontFamily: 'Alexandria',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 300,
                    width: 420,
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('notifications')
                          .where('to', isEqualTo: currentUserId)
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        print('🔔 dialog stream state=${snapshot.connectionState} hasData=${snapshot.hasData} for $currentUserId');

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          print('🔔 dialog notifications empty');
                          return const Center(
                            child: Text(
                              "لا توجد إشعارات.",
                              style: TextStyle(
                                fontFamily: 'Alexandria',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        final docs = snapshot.data!.docs;
                        print('🔔 dialog notifications count = ${docs.length}');

                        return ListView.separated(
                          itemCount: docs.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final doc = docs[index];
                            final data = doc.data();

                            final String fromId = ((data['fromId'] ?? data['from']) ?? '').toString().trim();
                            String fromName = (data['fromName'] ?? 'مستخدم').toString();

                            if (fromId.isEmpty) {
                              return _notificationLinkTile(
                                context: context,
                                data: data,
                                docId: doc.id,
                                fromName: fromName,
                              );
                            }

                            return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                              future: FirebaseFirestore.instance.collection('users').doc(fromId).get(),
                              builder: (context, userSnap) {
                                if (userSnap.hasData && userSnap.data!.exists) {
                                  final u = userSnap.data!.data()!;
                                  fromName = (u['name'] ?? u['username'] ?? fromName).toString();
                                }
                                return _notificationLinkTile(
                                  context: context,
                                  data: data,
                                  docId: doc.id,
                                  fromName: fromName,
                                );
                              },
                            );
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
      },
    );

    // ❌ لم نعد نحذف كل الإشعارات هنا
    // await _deleteAllNotificationsFor(currentUserId);
  }

  // ====== Dialog الرسائل ======

  static bool _messagesDialogOpen = false;

  Future<void> _showMessagesDialog(BuildContext context) async {
    if (_messagesDialogOpen) return;
    _messagesDialogOpen = true;

    print('💬 OPEN messages dialog (fixed snapshot) for $currentUserId');

    List<Map<String, dynamic>> messages = [];

    try {
      final snap = await FirebaseFirestore.instance
          .collection('notifications')
          .where('to', isEqualTo: currentUserId)
          .where('type', isEqualTo: 'message')
          .orderBy('timestamp', descending: true)
          .get();

      messages = snap.docs.map((d) => d.data() as Map<String, dynamic>).toList();
    } catch (e, st) {
      print('❌ messages query with orderBy failed: $e');
      print(st);
      try {
        final snapNoOrder = await FirebaseFirestore.instance
            .collection('notifications')
            .where('to', isEqualTo: currentUserId)
            .where('type', isEqualTo: 'message')
            .get();
        messages = snapNoOrder.docs.map((d) => d.data() as Map<String, dynamic>).toList();

        messages.sort((a, b) {
          final ta = (a['timestamp'] ?? 0);
          final tb = (b['timestamp'] ?? 0);
          final va = ta is int ? ta : (ta is Timestamp ? ta.millisecondsSinceEpoch : 0);
          final vb = tb is int ? tb : (tb is Timestamp ? tb.millisecondsSinceEpoch : 0);
          return vb.compareTo(va);
        });
      } catch (e2, st2) {
        print('❌ fallback messages query failed: $e2');
        print(st2);
      }
    }

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "الرسائل",
                              style: TextStyle(
                                fontFamily: 'Alexandria',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFAB86B9),
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(height: 4),
                            Text(
                              "الإشعارات الخاصة بالرسائل",
                              style: TextStyle(
                                fontFamily: 'Alexandria',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 360,
                    width: 520,
                    child: messages.isEmpty
                        ? const Center(
                      child: Text(
                        "لا توجد رسائل.",
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                        : ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final data = messages[index];
                        final String preview = (data['preview'] ?? '').toString();
                        final String fromIdTap = ((data['fromId'] ?? data['from']) ?? '').toString();
                        final String conversationId = (data['conversationId'] ?? '').toString();

                        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          future: FirebaseFirestore.instance.collection('users').doc(fromIdTap).get(),
                          builder: (context, userSnap) {
                            String peerName = 'مستخدم';
                            Map<String, dynamic>? uMap;

                            if (userSnap.hasData && userSnap.data != null && userSnap.data!.exists) {
                              uMap = userSnap.data!.data()!;
                              uMap['uid'] ??= fromIdTap;
                              peerName = (uMap['name'] ?? uMap['username'] ?? peerName).toString();
                            }

                            return ListTile(
                              leading: const Icon(Icons.message, color: Colors.deepPurple),
                              title: Text(
                                peerName,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontFamily: 'Alexandria',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              subtitle: preview.isEmpty
                                  ? null
                                  : Text(
                                preview,
                                textAlign: TextAlign.right,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Alexandria',
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                              onTap: () async {
                                final navigator = Navigator.of(context, rootNavigator: true);
                                if (navigator.canPop()) navigator.pop(); // أغلق نافذة الرسائل

                                try {
                                  if (uMap == null) {
                                    final uSnap = await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(fromIdTap)
                                        .get();
                                    if (!uSnap.exists || uSnap.data() == null) {
                                      print('⚠️ user $fromIdTap not found');
                                      return;
                                    }
                                    uMap = uSnap.data() as Map<String, dynamic>;
                                    uMap!['uid'] ??= fromIdTap;
                                  }
                                  final peerUser = UserModel.fromMap(uMap!);

                                  String? convIdToOpen = conversationId.isNotEmpty ? conversationId : null;
                                  if (convIdToOpen == null) {
                                    final chatsQ = await FirebaseFirestore.instance
                                        .collection('chats')
                                        .where('members', arrayContains: currentUserId)
                                        .get();
                                    for (final doc in chatsQ.docs) {
                                      final m =
                                      (doc.data() as Map<String, dynamic>)['members'] as List?;
                                      if (m != null &&
                                          m.map((e) => e.toString()).toSet().contains(fromIdTap)) {
                                        convIdToOpen = doc.id;
                                        break;
                                      }
                                    }
                                  }

                                  // فصل الفريم قبل أي push
                                  await Future<void>.delayed(const Duration(milliseconds: 1));

                                  navigator.push(
                                    MaterialPageRoute(
                                      builder: (_) => ChatScreen(
                                        conversationId: convIdToOpen ?? '',
                                        currentUser: user,
                                        peerUser: peerUser,
                                      ),
                                    ),
                                  );

                                  // حذف الإشعار الخاص بهذه الرسالة إن وُجد معرفه
                                  final notifId = (data['_id'] ?? '').toString();
                                  if (notifId.isNotEmpty) {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('notifications')
                                          .doc(notifId)
                                          .delete();
                                    } catch (e) {
                                      print('⚠️ failed deleting notif $notifId: $e');
                                    }
                                  }
                                } catch (e) {
                                  print('❌ open ChatScreen failed: $e');
                                }
                              },
                            );
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
      },
    );

    print('💬 CLOSE messages dialog → delete message notifications');
    try {
      await _deleteMessageNotificationsFor(currentUserId);
    } catch (e, st) {
      print('⚠️ delete message notifications failed: $e');
      print(st);
    } finally {
      _messagesDialogOpen = false;
    }
  }

  // ====== عنصر الإشعار كرابط ======
  Widget _notificationLinkTile({
    required BuildContext context,
    required Map<String, dynamic> data,
    required String docId,
    required String fromName,
  }) {
    final String rawType = (data['type'] ?? '').toString();
    final String type = rawType.toLowerCase().trim();
    final String label = _buildNotificationText(type: type, fromName: fromName, data: data);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: InkWell(
        onTap: () => _handleNotificationTap(context, type, data, docId), // ✅ نمرر docId
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Alexandria',
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.underline,
            color: Color(0xFFAB86B9),
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  String _buildNotificationText({
    required String type,
    required String fromName,
    required Map<String, dynamic> data,
  }) {
    switch (type) {
      case 'retweet':
        return 'إعادة تغريد بواسطة $fromName';
      case 'like':
        return 'إعجاب على تغريدتك بواسطة $fromName';
      case 'message':
        final preview = (data['messagePreview'] ?? data['message'] ?? '').toString();
        return preview.isNotEmpty ? 'رسالة من $fromName: $preview' : 'رسالة جديدة من $fromName';
      case 'follow':
        return '$fromName تابعك';
      default:
        return (data['title'] ?? data['text'] ?? 'إشعار من $fromName').toString();
    }
  }

  // ====== التصرّف عند الضغط على الإشعار — يحذف إشعار واحد فقط ======
  Future<void> _handleNotificationTap(
      BuildContext context, String type, Map<String, dynamic> data, String docId) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) navigator.pop(); // أغلق الـDialog إن وُجد

    // افصل الفريم قبل أي push
    await Future<void>.delayed(const Duration(milliseconds: 1));

    switch (type) {
      case 'message':
        _openMessageWithNavigator(navigator, data);
        break;
      case 'follow':
        _openFollowWithNavigator(navigator, data);
        break;
      case 'retweet':
      case 'like':
        _openTweetWithNavigator(navigator, data);
        break;
      default:
        break;
    }

    // ✅ حذف الإشعار الذي تم الضغط عليه فقط
    try {
      await FirebaseFirestore.instance.collection('notifications').doc(docId).delete();
      print('🗑️ Deleted notification $docId after tap');
    } catch (e) {
      print('⚠️ Failed to delete notification $docId: $e');
    }
  }

  // ====== فتح الرسائل باستخدام Navigator مُمرَّر ======
  void _openMessageWithNavigator(NavigatorState navigator, Map<String, dynamic> data) async {
    final String? fromId =
    _firstNonEmpty([data['fromId'], data['from'], data['peerId'], data['senderId']]);
    final String? convId =
    _firstNonEmpty([data['conversationId'], data['chatId'], data['threadId']]);

    if (fromId == null || fromId.isEmpty) {
      print('⚠️ _openMessage: fromId is null/empty');
      return;
    }

    try {
      final uSnap = await FirebaseFirestore.instance.collection('users').doc(fromId).get();
      if (!uSnap.exists || uSnap.data() == null) {
        print('⚠️ user $fromId not found');
        return;
      }
      final uMap = uSnap.data()!..putIfAbsent('uid', () => fromId);
      final peerUser = UserModel.fromMap(uMap);

      String? convIdToOpen = convId;
      if (convIdToOpen == null || convIdToOpen.isEmpty) {
        final chatsQ = await FirebaseFirestore.instance
            .collection('chats')
            .where('members', arrayContains: currentUserId)
            .get();
        for (final doc in chatsQ.docs) {
          final m = (doc.data() as Map<String, dynamic>)['members'] as List?;
          if (m != null && m.map((e) => e.toString()).toSet().contains(fromId)) {
            convIdToOpen = doc.id;
            break;
          }
        }
      }

      await Future<void>.delayed(const Duration(milliseconds: 1));
      navigator.push(
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            conversationId: convIdToOpen ?? '',
            currentUser: user,
            peerUser: peerUser,
          ),
        ),
      );
    } catch (e) {
      print('❌ _openMessage failed: $e');
    }
  }

  // ====== فتح التغريدة باستخدام Navigator مُمرَّر ======
  void _openTweetWithNavigator(NavigatorState navigator, Map<String, dynamic> data) async {
    // 0) لو التغريدة مضمّنة في الإشعار، استخدمها مباشرةً
    final embedded = data['tweet'];
    if (embedded is Map<String, dynamic> && embedded.isNotEmpty) {
      final map = Map<String, dynamic>.from(embedded);
      map['id'] ??=
          (data['tweetId'] ?? data['postId'] ?? data['retweetId'] ?? '').toString();

      final model = _mapToTweetModel(map);
      if (model == null) {
        print('⚠️ تعذّر تحويل بيانات التغريدة (embedded)');
        return;
      }

      await Future<void>.delayed(const Duration(milliseconds: 1));
      navigator.push(
        MaterialPageRoute(builder: (_) => TweetDetailScreen(tweet: model)),
      );
      return;
    }

    // 1) استخرج tweetId من الحقول المحتملة
    final String? tweetId = _firstNonEmpty([
      data['tweetId'],
      data['postId'],
      data['targetPostId'],
      data['retweetId'],
      data['targetId'],
    ]);

    // 2) فولباك لو لم نجد tweetId
    String? finalId = tweetId;
    if (finalId == null || finalId.isEmpty) {
      finalId = _firstNonEmpty([data['originalTweetId'], data['originalPostId']]);
      if (finalId == null || finalId.isEmpty) {
        print('⚠️ لا يوجد tweetId مناسب في الإشعار.');
        return;
      }
    }

    // 3) اجلب التغريدة كـ Map
    final fetchedMap = await _fetchTweetById(finalId);
    if (fetchedMap == null) {
      print('⚠️ تعذّر العثور على التغريدة ($finalId).');
      return;
    }

    // 4) حوّلها إلى TweetModel ثم افتح الشاشة
    final model = _mapToTweetModel(fetchedMap);
    if (model == null) {
      print('⚠️ تعذّر تحويل بيانات التغريدة (fetched).');
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 1));
    navigator.push(
      MaterialPageRoute(builder: (_) => TweetDetailScreen(tweet: model)),
    );
  }

  // ====== فتح بروفايل المُرسل باستخدام Navigator مُمرَّر ======
  void _openFollowWithNavigator(NavigatorState navigator, Map<String, dynamic> data) {
    final String? fromId = _firstNonEmpty([data['fromId'], data['from']]);
    if (fromId == null || fromId.isEmpty) return;

    navigator.push(
      MaterialPageRoute(
        builder: (_) => ProfileScreen(userId: fromId),
      ),
    );
  }

  // ====== أدوات مساعدة ======
  String? _firstNonEmpty(List<dynamic> vals) {
    for (final v in vals) {
      final s = (v ?? '').toString();
      if (s.trim().isNotEmpty) return s;
    }
    return null;
  }

  // تحويل Map إلى TweetModel
  TweetModel? _mapToTweetModel(Map<String, dynamic> map) {
    try {
      map['id'] ??= map['tweetId'] ?? map['postId'] ?? map['retweetId'];
      return TweetModel.fromMap(map);
    } catch (e) {
      print('⚠️ failed to build TweetModel from map: $e');
      return null;
    }
  }

  // جلب التغريدة من عدّة كولكشنز محتملة
  Future<Map<String, dynamic>?> _fetchTweetById(String tweetId) async {
    final candidateCollections = <String>[
      'tweets',
      'Tweets',
      'posts',
      'userTweets',
      'timeline',
      'retweets',
    ];

    // doc(tweetId)
    for (final col in candidateCollections) {
      try {
        final doc = await FirebaseFirestore.instance.collection(col).doc(tweetId).get();
        if (doc.exists && doc.data() != null) {
          final map = Map<String, dynamic>.from(doc.data()!);
          map['id'] ??= doc.id;
          map['__collection__'] = col;
          return map;
        }
      } catch (_) {}
    }

    // where id == tweetId
    for (final col in candidateCollections) {
      try {
        final q = await FirebaseFirestore.instance
            .collection(col)
            .where('id', isEqualTo: tweetId)
            .limit(1)
            .get();
        if (q.docs.isNotEmpty) {
          final d = q.docs.first;
          final map = Map<String, dynamic>.from(d.data());
          map['id'] ??= d.id;
          map['__collection__'] = col;
          return map;
        }
      } catch (_) {}
    }

    return null;
  }

  // حذف كل إشعارات المستخدم (لم نعد نستخدمه عند إغلاق الديالوج)
  Future<void> _deleteAllNotificationsFor(String userId) async {
    final q = await FirebaseFirestore.instance
        .collection('notifications')
        .where('to', isEqualTo: userId)
        .get();

    for (final d in q.docs) {
      try {
        await d.reference.delete();
      } catch (_) {}
    }
  }

  Future<void> _deleteMessageNotificationsFor(String userId) async {
    print('🗑️ delete message notifications for $userId');
    try {
      final q = await FirebaseFirestore.instance
          .collection('notifications')
          .where('to', isEqualTo: userId)
          .where('type', isEqualTo: 'message')
          .get();

      if (q.docs.isEmpty) {
        print('🗑️ no message notifications to delete');
        return;
      }

      for (final d in q.docs) {
        try {
          await d.reference.delete();
          print('  • deleted notif ${d.id}');
        } catch (e) {
          print('  ! failed to delete ${d.id}: $e');
        }
      }
    } catch (e, st) {
      print('❌ _deleteMessageNotificationsFor failed: $e');
      print(st);
    }
  }
}
