import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';

import '../../Functions/pick_media.dart';



class CreateTweetScreen extends StatefulWidget {
  @override
  _CreateTweetScreenState createState() => _CreateTweetScreenState();
}

class _CreateTweetScreenState extends State<CreateTweetScreen> {
  final TextEditingController _textController = TextEditingController();
  bool isPosting = false;

  PlatformFile? selectedMedia;
  String? mediaType;
  List<String> mediaUrls = [];

  Future<void> _handlePickMedia() async {
    final result = await pickMedia();

    if (result != null) {
      setState(() {
        selectedMedia = result['file'];
        mediaType = result['type'];
        mediaUrls = [result['url']];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("فشل في اختيار أو رفع الملف")),
      );
    }
  }

  void _postTweet() async {
    final String text = _textController.text.trim();
    final userId = FirebaseAuth.instance.currentUser!.uid;

    if (text.isEmpty && mediaUrls.isEmpty) return;

    final hashtags = RegExp(r"#\w+")
        .allMatches(text)
        .map((match) => match.group(0)!)
        .toList();

    setState(() => isPosting = true);

    await FirebaseFirestore.instance.collection('tweets').add({
      'userId': userId,
      'text': text,
      'mediaUrls': mediaUrls,
      'likes': [],
      'dislikes': [],
      'replyTo': null,
      'conversationId': null,
      'type': 'tweet',
      'timestamp': FieldValue.serverTimestamp(),
      'hashtags': hashtags, // ✅ تخزين الهاشتاقات
    });

    setState(() => isPosting = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مشاركه جديدة'),
        actions: [
          TextButton(
            onPressed: isPosting ? null : _postTweet,
            child: Text('نشر', style: TextStyle(color: Colors.white)),
          ),
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _textController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'عن ماذا تفكر؟',
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 10),
              if (selectedMedia != null)
                mediaType == 'image'
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    selectedMedia!.bytes!,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                )
                    : Column(
                  children: [
                    Icon(Icons.videocam, size: 60, color: Colors.deepPurple),
                    Text(
                      'تم اختيار فيديو: ${selectedMedia!.name}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _handlePickMedia,
                icon: Icon(Icons.attach_file),
                label: Text('إضافة صورة أو فيديو'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
