import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';

Future<String?> uploadMedia(PlatformFile file, String mediaType) async {
  final uri = Uri.parse("https://shatarachess.com/profile_Image/upload_tweets.php");

  final fileBytes = file.bytes;
  final fileName = file.name;
  final mimeType = lookupMimeType(fileName) ?? 'application/octet-stream';

  if (fileBytes == null) {
    print("لا توجد بيانات مرفقة بالملف.");
    return null;
  }

  final request = http.MultipartRequest("POST", uri)
    ..fields['type'] = mediaType
    ..files.add(http.MultipartFile.fromBytes(
      'file',
      fileBytes,
      filename: fileName,
      contentType: MediaType.parse(mimeType),
    ));

  try {
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      if (data['success']) {
        return data['url'];
      } else {
        print("فشل الرفع: ${data['message']}");
      }
    } else {
      print("فشل الاتصال بالسيرفر: ${response.statusCode}");
    }
  } catch (e) {
    print("خطأ أثناء رفع الملف: $e");
  }

  return null;
}
