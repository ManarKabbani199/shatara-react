import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../models/tweet_model.dart';
import '../../screens/Tweet/TweetDetailScreen.dart';

// ✅ استورد ودجت AdaptiveVideo (عدّل المسار حسب مكان الملف لديك)
import '../../utils/AdaptiveVideo.dart';

class TweetTile extends StatefulWidget {
  final TweetModel tweet;

  // ✅ كولباك اختياري لإبلاغ الأب بعد الحذف (يمكنك تجاهله إن ما تحتاجه)
  final VoidCallback? onDeleted;

  const TweetTile({
    super.key,
    required this.tweet,
    this.onDeleted,
  });

  @override
  _TweetTileState createState() => _TweetTileState();
}

class _TweetTileState extends State<TweetTile> {
  String? currentUserId;
  late bool isLiked;
  bool isDisliked = false;

  // ✅ حالة وعدّاد الحفظ من داخل وثيقة التغريدة (savedBy)
  bool isBookmarked = false;
  int bookmarkCount = 0;

  int replyCount = 0;
  int retweetCount = 0;

  // ✅ نص التغريدة المعروض (يُحدّث محليًا بعد التعديل)
  late String displayedText;

  // ✅ لإخفاء البطاقة فور الحذف (تحديث فوري للواجهة)
  bool _isDeleted = false;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid;

    final likes = widget.tweet.likes ?? const <String>[];
    final dislikes = widget.tweet.dislikes ?? const <String>[];

    isLiked = currentUserId != null && likes.contains(currentUserId);
    isDisliked = currentUserId != null && dislikes.contains(currentUserId);

    displayedText = widget.tweet.text;

    _loadBookmarkState();        // ✅ يقرأ savedBy من وثيقة التغريدة
    _loadReplyAndRetweetCounts();
  }

  /// ✅ يجلب savedBy من وثيقة التغريدة ويحدّث حالة الحفظ والعدّاد
  Future<void> _loadBookmarkState() async {
    if (currentUserId == null) return;

    try {
      final snap = await FirebaseFirestore.instance
          .collection('tweets')
          .doc(widget.tweet.id)
          .get();

      if (!snap.exists) return;
      final data = snap.data() as Map<String, dynamic>?;

      final List<dynamic> savedByDyn = (data?['savedBy'] as List?) ?? const [];
      final savedBy = savedByDyn.map((e) => e?.toString()).whereType<String>().toList();

      if (!mounted) return;
      setState(() {
        isBookmarked = savedBy.contains(currentUserId);
        bookmarkCount = savedBy.length;
      });
    } catch (_) {}
  }

  Future<void> _loadReplyAndRetweetCounts() async {
    try {
      final repliesSnap = await FirebaseFirestore.instance
          .collection('tweets')
          .where('replyTo', isEqualTo: widget.tweet.id)
          .where('type', isEqualTo: 'reply')
          .get();

      final retweetsSnap = await FirebaseFirestore.instance
          .collection('tweets')
          .where('retweetedFrom', isEqualTo: widget.tweet.id)
          .where('type', isEqualTo: 'retweet')
          .get();

      if (!mounted) return;
      setState(() {
        replyCount = repliesSnap.docs.length;
        retweetCount = retweetsSnap.docs.length;
      });
    } catch (_) {}
  }

  Future<void> _toggleLike() async {
    if (currentUserId == null) return;
    final tweetRef = FirebaseFirestore.instance.collection('tweets').doc(widget.tweet.id);

    try {
      if (isLiked) {
        await tweetRef.update({'likes': FieldValue.arrayRemove([currentUserId])});
      } else {
        await tweetRef.update({'likes': FieldValue.arrayUnion([currentUserId])});
      }
      if (!mounted) return;
      setState(() {
        isLiked = !isLiked;
      });
    } catch (_) {}
  }

  Future<void> _toggleDislike() async {
    if (currentUserId == null) return;
    final tweetRef = FirebaseFirestore.instance.collection('tweets').doc(widget.tweet.id);

    try {
      if (isDisliked) {
        await tweetRef.update({'dislikes': FieldValue.arrayRemove([currentUserId])});
      } else {
        await tweetRef.update({'dislikes': FieldValue.arrayUnion([currentUserId])});
      }
      if (!mounted) return;
      setState(() {
        isDisliked = !isDisliked;
      });
    } catch (_) {}
  }

  /// ✅ يحفظ/يلغي الحفظ داخل وثيقة التغريدة في حقل savedBy
  Future<void> _toggleBookmark() async {
    if (currentUserId == null) return;
    final tweetRef = FirebaseFirestore.instance.collection('tweets').doc(widget.tweet.id);

    try {
      if (isBookmarked) {
        await tweetRef.update({'savedBy': FieldValue.arrayRemove([currentUserId])});
        if (!mounted) return;
        setState(() {
          isBookmarked = false;
          bookmarkCount = (bookmarkCount - 1).clamp(0, 1 << 31);
        });
      } else {
        await tweetRef.update({'savedBy': FieldValue.arrayUnion([currentUserId])});
        if (!mounted) return;
        setState(() {
          isBookmarked = true;
          bookmarkCount = bookmarkCount + 1;
        });
      }
    } catch (_) {}
  }

  Future<void> _retweet() async {
    if (currentUserId == null) return;
    try {
      await FirebaseFirestore.instance.collection('tweets').add({
        'userId': currentUserId,
        'text': widget.tweet.text,
        'mediaUrls': widget.tweet.mediaUrls ?? const [],
        'likes': [],
        'dislikes': [],
        'replyTo': null,
        'conversationId': null,
        'type': 'retweet',
        'retweetedFrom': widget.tweet.id,
        'timestamp': FieldValue.serverTimestamp(),
        'hashtags': widget.tweet.hashtags ?? const [],
        // مبدئيًا بدون savedBy في الريتويت الجديد
      });

      if (currentUserId != widget.tweet.userId && widget.tweet.userId.isNotEmpty) {
        await FirebaseFirestore.instance.collection('notifications').add({
          'type': 'retweet',
          'from': currentUserId,
          'to': widget.tweet.userId,
          'tweetId': widget.tweet.id,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تمت إعادة التغريد")));
      _loadReplyAndRetweetCounts();
    } catch (_) {}
  }

  void _replyToTweet() {
    if (currentUserId == null) return;

    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('رد على التغريدة', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'اكتب ردك...'),
              maxLines: null,
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final replyText = controller.text.trim();
                if (replyText.isEmpty) return;

                final hashtags = RegExp(r"#\w+")
                    .allMatches(replyText)
                    .map((m) => m.group(0)!)
                    .toList();

                try {
                  await FirebaseFirestore.instance.collection('tweets').add({
                    'userId': currentUserId,
                    'text': replyText,
                    'mediaUrls': [],
                    'likes': [],
                    'dislikes': [],
                    'replyTo': widget.tweet.id,
                    'conversationId': widget.tweet.conversationId ?? widget.tweet.id,
                    'type': 'reply',
                    'timestamp': FieldValue.serverTimestamp(),
                    'hashtags': hashtags,
                  });

                  if (currentUserId != widget.tweet.userId && widget.tweet.userId.isNotEmpty) {
                    await FirebaseFirestore.instance.collection('notifications').add({
                      'type': 'reply',
                      'from': currentUserId,
                      'to': widget.tweet.userId,
                      'tweetId': widget.tweet.id,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                  }
                } catch (_) {}

                if (!mounted) return;
                Navigator.pop(ctx);
                _loadReplyAndRetweetCounts();
              },
              child: const Text('نشر الرد'),
            )
          ],
        ),
      ),
    );
  }

  // =======================
  // ✅ التعديل والحذف (مالك فقط)
  // =======================

  Future<void> _showEditSheet() async {
    if (currentUserId == null) return;
    final controller = TextEditingController(text: displayedText);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('تعديل التغريدة', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'حدّث نص التغريدة...',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      final newText = controller.text.trim();
                      if (newText.isEmpty) return;

                      // استخراج الهاشتاقات من النص الجديد
                      final hashtags = RegExp(r"#\w+")
                          .allMatches(newText)
                          .map((m) => m.group(0)!)
                          .toList();

                      try {
                        await FirebaseFirestore.instance
                            .collection('tweets')
                            .doc(widget.tweet.id)
                            .update({
                          'text': newText,
                          'hashtags': hashtags,
                          'updatedAt': FieldValue.serverTimestamp(),
                        });

                        if (!mounted) return;
                        setState(() {
                          displayedText = newText; // ✅ تحديث فوري
                        });

                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم تحديث التغريدة')),
                        );
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('فشل التعديل')),
                        );
                      }
                    },
                    child: const Text('حفظ'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('إلغاء'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete() async {
    if (currentUserId == null) return;
    final isOwner = currentUserId == widget.tweet.userId;
    if (!isOwner) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('حذف التغريدة'),
          content: const Text('هل أنت متأكد من حذف هذه التغريدة؟ لا يمكن التراجع.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('حذف', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );

    if (ok != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('tweets')
          .doc(widget.tweet.id)
          .delete();

      if (!mounted) return;

      // ✅ تحديث فوري في الواجهة: إخفاء العنصر + إبلاغ الأب (إن وُجِد)
      setState(() {
        _isDeleted = true;
      });
      widget.onDeleted?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حذف التغريدة')),
      );

      // ملاحظة: لو تبغى حذف الردود/الريتويت المرتبطة، نفّذ استعلامات إضافية واحذفها كذلك (Batch/Transaction).
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل الحذف')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ لو تم حذف التغريدة، لا تُظهر أي شيء (تختفي فورًا)
    if (_isDeleted) return const SizedBox.shrink();

    if (widget.tweet.userId.isEmpty) {
      return _buildCard(
        timestampLabel: _formatTime(widget.tweet.timestamp),
        userName: 'مستخدم',
        userHandle: '',
        profileUrl: '',
      );
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.tweet.userId)
          .get(),
      builder: (context, snapshot) {
        Map<String, dynamic>? userMap;
        if (snapshot.hasData && snapshot.data!.exists) {
          userMap = snapshot.data!.data() as Map<String, dynamic>?;
        }

        final userName = (userMap?['name'] as String?) ?? 'مستخدم';
        final userHandle = (userMap?['username'] as String?) ?? '';
        final profileUrl = (userMap?['profileImageUrl'] as String?) ?? '';

        return _buildCard(
          timestampLabel: _formatTime(widget.tweet.timestamp),
          userName: userName,
          userHandle: userHandle.isNotEmpty ? '@$userHandle' : '',
          profileUrl: profileUrl,
        );
      },
    );
  }

  String _formatTime(dynamic ts) {
    try {
      if (ts is Timestamp) {
        return timeago.format(ts.toDate());
      } else if (ts is DateTime) {
        return timeago.format(ts);
      }
    } catch (_) {}
    return 'تاريخ غير معروف';
  }

  Widget _buildCard({
    required String timestampLabel,
    required String userName,
    required String userHandle,
    required String profileUrl,
  }) {
    final media = widget.tweet.mediaUrls ?? const <String>[];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      color: Colors.white,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TweetDetailScreen(tweet: widget.tweet),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIconsColumn(),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // يسار: الوقت
                        Text(
                          timestampLabel,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: 'Alexandria',
                          ),
                        ),

                        // يمين: اسم المستخدم + قائمة المالك
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                fontFamily: 'Alexandria',
                              ),
                            ),

                            // ✅ تظهر فقط لمالك التغريدة
                            if (currentUserId == widget.tweet.userId) ...[
                              const SizedBox(width: 4),
                              PopupMenuButton<String>(
                                tooltip: 'خيارات',
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showEditSheet();
                                  } else if (value == 'delete') {
                                    _confirmDelete();
                                  }
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Text('تعديل'),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text('حذف'),
                                  ),
                                ],
                                icon: const Icon(Icons.more_vert, size: 18),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (userHandle.isNotEmpty)
                      Text(
                        userHandle,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 11,
                          fontFamily: 'Alexandria',
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    Text(
                      displayedText, // ✅ النص بعد التعديل
                      style: const TextStyle(fontSize: 14, fontFamily: 'Alexandria'),
                      textAlign: TextAlign.right,
                    ),

                    // الوسائط (فيديو/صور)
                    if (media.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _buildMedia(media.first),
                        ),
                      ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  /// يبني ويدجت الوسائط بحسب نوع الرابط (فيديو أو صورة).
  Widget _buildMedia(String url) {
    if (_isVideoUrl(url)) {
      // ✅ استخدام AdaptiveVideo بدل VideoPlayerWidget
      return AdaptiveVideo(url: url);
    }
    // صورة
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (_, __, ___) => const Text('تعذّر تحميل الوسائط'),
    );
  }

  /// تحقّق بدائي من امتداد الرابط لتحديد إن كان فيديو.
  bool _isVideoUrl(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.webm') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.m4v') ||
        lower.endsWith('.m3u8');
  }

  Widget _buildIconsColumn() {
    final likesCount = (widget.tweet.likes ?? const <String>[]).length;
    final dislikesCount = (widget.tweet.dislikes ?? const <String>[]).length;

    return Container(
      width: 50,
      color: const Color(0xFF6C5851),
      child: Column(
        children: [
          _iconWithText(
            Icons.favorite,
            likesCount.toString(),
            isLiked ? Colors.red : Colors.white,
            _toggleLike,
          ),
          _iconWithText(
            Icons.thumb_down_alt_outlined,
            dislikesCount.toString(),
            isDisliked ? Colors.blueGrey : Colors.white,
            _toggleDislike,
          ),
          _iconWithText(
            Icons.chat_bubble_outline,
            replyCount.toString(),
            Colors.white,
            _replyToTweet,
          ),
          _iconWithText(
            Icons.repeat,
            retweetCount.toString(),
            Colors.white,
            _retweet,
          ),
          // ✅ أيقونة الحفظ (Bookmark) المعتمدة على savedBy
          _iconWithText(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            bookmarkCount.toString(),
            Colors.white,
            _toggleBookmark,
          ),
        ],
      ),
    );
  }

  Widget _iconWithText(IconData icon, String text, Color color, VoidCallback onTap) {
    return Column(
      children: [
        IconButton(icon: Icon(icon, color: color), onPressed: onTap),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.white)),
      ],
    );
  }
}
  