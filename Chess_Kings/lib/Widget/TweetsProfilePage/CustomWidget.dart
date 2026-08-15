import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import '../../screens/Tweet/TweetsProfile.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart' show kIsWeb;

class CustomWidget extends StatefulWidget {
  final String level;
  final String loginCount;
  final String vsComputerCount;
  final String winCount;

  const CustomWidget({
    Key? key,
    required this.level,
    required this.loginCount,
    required this.vsComputerCount,
    required this.winCount,
  }) : super(key: key);

  @override
  _CustomWidgetState createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {
  final TextEditingController _textController = TextEditingController();
  bool isPosting = false;

  PlatformFile? selectedMedia;
  String? mediaType; // 'image' | 'video'
  List<String> mediaUrls = [];

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ====================== رفع "صورة" مع شريط تقدم (اختياري) ======================
  Future<Map<String, dynamic>?> pickImageFileWithProgress(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: kIsWeb, // للويب نحتاج bytes
    );

    if (result == null) {
      debugPrint('المستخدم ألغى اختيار الصورة');
      return null;
    }

    // مساعد لإغلاق الديالوج بأمان
    void safePop() {
      if (Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }

    double progress = 0.0;
    late StateSetter dialogSetState;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            dialogSetState = setState;
            return AlertDialog(
              title: const Text('جاري رفع الصورة'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(value: progress == 0 ? null : progress),
                  const SizedBox(height: 16),
                  Text('${(progress * 100).toStringAsFixed(0)}%'),
                ],
              ),
            );
          },
        );
      },
    );

    final file = result.files.single;

    try {
      // ✅ قيود حجم مناسبة للويب (عدّل الحد حسب حاجتك)
      if (kIsWeb) {
        final sizeMB = file.size / (1024 * 1024);
        const maxMB = 20.0; // حد افتراضي 20MB للصور على الويب
        if (sizeMB > maxMB) {
          safePop();
          return {
            "success": false,
            "message": "حجم الصورة (${sizeMB.toStringAsFixed(1)}MB) أكبر من الحد الأقصى (${maxMB.toStringAsFixed(0)}MB). صغّرها أولاً."
          };
        }
      }

      // ✅ مهلات أطول (تقلل انقطاعات الرفع)
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(minutes: 2),
        sendTimeout: const Duration(minutes: 15),
        receiveTimeout: const Duration(minutes: 15),
        responseType: ResponseType.json,
        validateStatus: (c) => c != null && c >= 200 && c < 500,
      ));

      // اسم + MIME
      final filename = file.name.isNotEmpty ? file.name : 'image.jpg';
      final mime = lookupMimeType(filename) ?? 'image/jpeg';
      final mt = MediaType.parse(mime);

      // تجهيز الملف
      MultipartFile multipartFile;
      if (kIsWeb) {
        final bytes = file.bytes;
        if (bytes == null) {
          safePop();
          return {"success": false, "message": "لا توجد بيانات صورة (bytes) على الويب"};
        }
        multipartFile = MultipartFile.fromBytes(bytes, filename: filename, contentType: mt);
      } else {
        final filePath = file.path;
        if (filePath == null) {
          safePop();
          return {"success": false, "message": "مسار الصورة غير متاح"};
        }
        multipartFile = await MultipartFile.fromFile(
          filePath,
          filename: p.basename(filePath),
          contentType: mt,
        );
      }

      final formData = FormData.fromMap({
        "file": multipartFile,
        "type": "image",
      });

      final response = await dio.post(
        "https://shatarachess.com/profile_Image/upload_tweets.php",
        data: formData,
        onSendProgress: (sent, total) {
          // total قد يكون -1 في بعض السيرفرات → أبقِ الشريط غير محدد
          if (total > 0) {
            progress = sent / total;
            dialogSetState(() {});
          }
        },
      );

      safePop();

      // التعامل مع الاستجابة
      dynamic data = response.data;
      if (data is String) {
        try {
          data = jsonDecode(data);
        } catch (_) {
          debugPrint('استجابة الصورة ليست JSON:\n$data');
        }
      }

      if (response.statusCode == 200 &&
          data is Map &&
          (data["success"] == true || data["status"] == "success")) {
        final url = data["url"] ?? data["file_url"] ?? data["path"] ?? '';
        return {
          "success": true,
          "url": url,
          "name": filename,
          "raw": data,
        };
      } else {
        debugPrint("فشل رفع الصورة. الكود: ${response.statusCode}, البيانات: $data");
        return {
          "success": false,
          "message": (data is Map ? (data["message"] ?? data["error"]) : null)
              ?? "فشل رفع الصورة (${response.statusCode})",
          "raw": data,
        };
      }
    } on DioException catch (e) {
      safePop();
      debugPrint("DioException (image): ${e.message}");
      debugPrint("Response: ${e.response?.data}");
      return {
        "success": false,
        "message": e.message ?? "خطأ غير معروف أثناء رفع الصورة",
        "raw": e.response?.data,
      };
    } catch (e) {
      safePop();
      debugPrint("خطأ أثناء رفع الصورة: $e");
      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }


  // ====================== رفع "فيديو" مع شريط تقدم ======================
  Future<Map<String, dynamic>?> pickVideoFileWithProgress(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
      withData: kIsWeb,
    );

    if (result == null) {
      debugPrint('المستخدم ألغى الاختيار');
      return null;
    }

    double progress = 0.0;
    late StateSetter dialogSetState;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            dialogSetState = setState;
            return AlertDialog(
              title: const Text('جاري رفع الفيديو'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(value: progress == 0 ? null : progress),
                  const SizedBox(height: 16),
                  Text('${(progress * 100).toStringAsFixed(0)}%'),
                ],
              ),
            );
          },
        );
      },
    );

    final file = result.files.single;

    // رفض الأحجام الكبيرة على الويب (عدّل الحد حسبك)
    if (kIsWeb) {
      final sizeMB = file.size / (1024 * 1024);
      if (sizeMB > 150) {
        if (Navigator.canPop(context)) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        return {
          "success": false,
          "message": "حجم الفيديو (${sizeMB.toStringAsFixed(1)}MB) أكبر من الحد (150MB). صغّر الملف أولًا."
        };
      }
    }

// زِد المهَلات في Dio
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(minutes: 2),
      sendTimeout: const Duration(minutes: 30),   // كان 5 دقائق → قليل
      receiveTimeout: const Duration(minutes: 30),
      responseType: ResponseType.json,
      validateStatus: (c) => c != null && c >= 200 && c < 500,
    ));


    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(minutes: 5),
        receiveTimeout: const Duration(minutes: 5),
        responseType: ResponseType.json,
        validateStatus: (c) => c != null && c >= 200 && c < 500,
      ));

      final filename = (file.name.isNotEmpty ? file.name : (kIsWeb ? 'video.webm' : 'video.mp4'));
      final mime = lookupMimeType(filename) ?? 'video/mp4';
      final mt = MediaType.parse(mime);

      MultipartFile multipartFile;
      if (kIsWeb) {
        final bytes = file.bytes;
        if (bytes == null) {
          if (Navigator.canPop(context)) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          return {"success": false, "message": "لا توجد بيانات للملف (bytes) على الويب"};
        }
        multipartFile = MultipartFile.fromBytes(bytes, filename: filename, contentType: mt);
      } else {
        final filePath = file.path;
        if (filePath == null) {
          if (Navigator.canPop(context)) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          return {"success": false, "message": "مسار الملف غير متاح"};
        }
        multipartFile = await MultipartFile.fromFile(filePath,
            filename: p.basename(filePath), contentType: mt);
      }

      final formData = FormData.fromMap({
        "file": multipartFile,
        "type": "video",
      });

      final response = await dio.post(
        "https://shatarachess.com/profile_Image/upload_tweets.php",
        data: formData,
        onSendProgress: (sent, total) {
          if (total > 0) {
            progress = sent / total;
            dialogSetState(() {});
          }
        },
      );

      if (Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      dynamic data = response.data;
      if (data is String) {
        try {
          data = jsonDecode(data);
        } catch (_) {
          debugPrint('استجابة ليست JSON، النص:\n$data');
        }
      }

      if (response.statusCode == 200 &&
          data is Map &&
          (data["success"] == true || data["status"] == "success")) {
        final url = data["url"] ?? data["file_url"] ?? data["path"] ?? '';
        return {"success": true, "url": url, "name": filename, "raw": data};
      } else {
        debugPrint("فشل الرفع. الكود: ${response.statusCode}, البيانات: $data");
        return {
          "success": false,
          "message": (data is Map ? (data["message"] ?? data["error"]) : null) ??
              "فشل رفع الملف (${response.statusCode})",
          "raw": data
        };
      }
    } on DioException catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      debugPrint("DioException: ${e.message}");
      debugPrint("Response: ${e.response?.data}");
      return {
        "success": false,
        "message": e.message ?? "خطأ غير معروف أثناء الرفع",
        "raw": e.response?.data,
      };
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      debugPrint("خطأ أثناء رفع الفيديو: $e");
      return {"success": false, "message": e.toString()};
    }
  }

  // ====================== نشر التغريدة ======================
  Future<void> _postTweet() async {
    final String text = _textController.text.trim();
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      _showSnack('الرجاء تسجيل الدخول أولاً');
      return;
    }

    if (text.isEmpty && mediaUrls.isEmpty) {
      _showSnack('اكتب نصًا أو أرفق وسيطًا للنشر');
      return;
    }

    final hashtags = RegExp(r"#\w+")
        .allMatches(text)
        .map((match) => match.group(0)!)
        .toList();

    setState(() => isPosting = true);
    try {
      await FirebaseFirestore.instance.collection('tweets').add({
        'userId': userId,
        'text': text,
        'mediaUrls': mediaUrls, // ← أصبحت تحتوي رابط الفيديو/الصورة من السيرفر
        'likes': [],
        'dislikes': [],
        'replyTo': null,
        'conversationId': null,
        'type': 'tweet',
        'timestamp': FieldValue.serverTimestamp(),
        'hashtags': hashtags,
      });
      _showSnack('تم نشر التغريدة');
      // إعادة التهيئة
      _textController.clear();
      mediaUrls = [];
      selectedMedia = null;
      mediaType = null;
      setState(() {});
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TweetsProfile(userId: userId)),
      );
    } catch (e) {
      _showSnack('فشل نشر التغريدة: $e');
    } finally {
      if (mounted) setState(() => isPosting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        double baseFontSize = screenWidth < 400 ? 14 : 14;
        double titleFontSize = screenWidth < 400 ? 13 : 9;
        double iconSize = screenWidth < 400 ? 35 : 75;
        double imageSize = screenWidth < 400 ? 50 : 70;

        return Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.ltr,
                children: [
                  IconButton(
                    icon: Image.asset('assets/icol.png', width: iconSize),
                    onPressed: isPosting ? null : _postTweet,
                  ),
                  Row(
                    textDirection: TextDirection.ltr,
                    children: [
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: _textController,
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: 'قم بنشر شطارة لك',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset('assets/iconr.png', width: iconSize),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // رفع صورة
                        GestureDetector(
                          onTap: () async {
                            try {
                              final res = await pickImageFileWithProgress(context);
                              if (res?['success'] == true) {
                                final url = res!['url'] as String;
                                setState(() {
                                  mediaUrls = [url];
                                  mediaType = 'image';
                                  // للمعاينة، نعطي selectedMedia من الذاكرة إن توفر
                                  // هنا ما عندنا bytes من السيرفر؛ فنعرض لاحقًا صورة الشبكة بعد النشر
                                  selectedMedia = PlatformFile(
                                    name: res['name'] ?? 'image.jpg',
                                    size: 0,
                                  );
                                });
                                _showSnack('تم رفع الصورة');
                              } else if (res != null) {
                                _showSnack(res['message'] ?? 'فشل رفع الصورة');
                              }
                            } catch (e, st) {
                              debugPrint('pickImageFileWithProgress threw: $e\n$st');
                              _showSnack('حدث خطأ أثناء رفع الصورة');
                            }
                          },
                          child: Image.asset('assets/ic1.png', width: imageSize, height: imageSize),
                        ),

                        // رفع فيديو
                        GestureDetector(
                          onTap: () async {
                            try {
                              final res = await pickVideoFileWithProgress(context);
                              debugPrint('upload result: $res');
                              if (res?['success'] == true) {
                                final url = res!['url'] as String;
                                setState(() {
                                  mediaUrls = [url];       // ← مهم: حتى تُحفظ مع التغريدة
                                  mediaType = 'video';
                                  selectedMedia = PlatformFile(
                                    name: res['name'] ?? 'video.mp4',
                                    size: 0,
                                  );
                                });
                                _showSnack('تم رفع الفيديو');
                              } else if (res != null) {
                                _showSnack(res['message'] ?? 'فشل رفع الفيديو');
                              }
                            } catch (e, st) {
                              debugPrint('pickVideoFileWithProgress threw: $e\n$st');
                              _showSnack('حدث خطأ أثناء رفع الفيديو');
                            }
                          },
                          child: Image.asset('assets/ic2.png', width: imageSize, height: imageSize),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // معاينة: لو في وسائط مختارة
                    if (selectedMedia != null)
                      mediaType == 'image'
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.image, size: 60, color: Colors.deepPurple),
                          Text(
                            'تم اختيار صورة: ${selectedMedia!.name}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      )
                          : Column(
                        children: [
                          const Icon(Icons.videocam, size: 60, color: Colors.deepPurple),
                          Text(
                            'تم اختيار فيديو: ${selectedMedia!.name}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              _buildStatRow(widget.level, 'المستوى', iconSize, baseFontSize, titleFontSize),
              _buildStatRow(widget.loginCount, 'عدد مرات تسجيل الدخول', iconSize, baseFontSize, titleFontSize),
              _buildStatRow(widget.vsComputerCount, 'عدد مرات اللعب ضد الكمبيوتر', iconSize, baseFontSize, titleFontSize),
              _buildStatRow(widget.winCount, 'عدد مرات الفوز', iconSize, baseFontSize, titleFontSize),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageButton(BuildContext context, String assetPath, Widget destination, double size) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      ),
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildStatRow(String value, String label, double iconSize, double baseFontSize, double titleFontSize) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.ltr,
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: baseFontSize,
              color: const Color(0xFFAB86B9),
            ),
          ),
          Row(
            textDirection: TextDirection.ltr,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.bold,
                  fontSize: titleFontSize,
                  color: const Color(0xFF6B4E45),
                ),
              ),
              const SizedBox(width: 8),
              Image.asset('assets/iconrrrr.png', width: iconSize),
            ],
          ),
        ],
      ),
    );
  }
}
