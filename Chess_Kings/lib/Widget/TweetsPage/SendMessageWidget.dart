import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import '../../models/UserModel.dart';

class SendMessageWidget extends StatefulWidget {
  final String conversationId;
  final UserModel currentUser;
  final UserModel peerUser;

  const SendMessageWidget({
    required this.conversationId,
    required this.currentUser,
    required this.peerUser,
  });

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  final TextEditingController _controller = TextEditingController();
  bool isSending = false;

  void _sendMessage({String? text, String? imageUrl}) async {
    if ((text == null || text.trim().isEmpty) && imageUrl == null) return;

    setState(() => isSending = true);

    await FirebaseFirestore.instance.collection('chats').doc(widget.conversationId).collection('messages').add({
      'senderId': widget.currentUser.uid,
      'receiverId': widget.peerUser.uid,
      'text': text ?? '',
      'imageUrl': imageUrl ?? '',
      'timestamp': FieldValue.serverTimestamp(),
      'type': imageUrl != null ? 'image' : 'text',
    });

    await FirebaseFirestore.instance.collection('chats').doc(widget.conversationId).update({
      'lastMessage': text?.isNotEmpty == true ? text : '📷 صورة',
      'lastSenderId': widget.currentUser.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _controller.clear();
    setState(() => isSending = false);
  }

  Future<void> _pickAndSendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final bytes = await pickedFile.readAsBytes();
    final imageUrl = await uploadImageToServer(pickedFile.name, bytes);
    if (imageUrl != null) {
      _sendMessage(imageUrl: imageUrl);
    }
  }

  Future<String?> uploadImageToServer(String filename, Uint8List bytes) async {
    final uri = Uri.parse('https://shatarachess.com/profile_Image/uploads/Message_Image/upload.php');
    final request = http.MultipartRequest('POST', uri);

    final mimeType = lookupMimeType(filename) ?? 'image/jpeg';

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
        contentType: MediaType.parse(mimeType),
      ),
    );

    final response = await request.send();
    if (response.statusCode == 200) {
      final resBody = await response.stream.bytesToString();
      final fixedUrl = 'https://shatarachess.com/profile_Image/uploads/Message_Image/uploads/Message_Image/' + resBody.trim().split('/').last;
      return fixedUrl;
    } else {
      print('❌ فشل في رفع الصورة إلى السيرفر');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.image, color: Colors.deepPurple),
              onPressed: _pickAndSendImage,
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'اكتب رسالة...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onSubmitted: (val) => _sendMessage(text: val.trim()),
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              onPressed: isSending ? null : () => _sendMessage(text: _controller.text.trim()),
              icon: Icon(Icons.send, color: Colors.deepPurple),
            )
          ],
        ),
      ),
    );
  }
}
