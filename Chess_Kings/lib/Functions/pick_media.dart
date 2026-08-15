import 'package:file_picker/file_picker.dart';
import 'upload_media.dart';

Future<Map<String, dynamic>?> pickMedia() async {
  final result = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4'],
    withData: true, // ضروري في Flutter Web!
  );

  if (result != null && result.files.isNotEmpty) {
    final file = result.files.first;
    final extension = file.extension?.toLowerCase();
    final mediaType = extension == 'mp4' ? 'video' : 'image';

    String? url = await uploadMedia(file, mediaType);

    // ✅ تصحيح الرابط إن كان ناقص المسار
    if (url != null && url.contains('/uploads/tweet_Image') && !url.contains('/profile_Image/')) {
      url = url.replaceFirst(
        '/uploads/tweet_Image',
        '/profile_Image/uploads/tweet_Image',
      );
    }

    if (url != null) {
      return {
        'file': file,
        'url': url,
        'type': mediaType,
      };
    }
  }

  return null;
}
