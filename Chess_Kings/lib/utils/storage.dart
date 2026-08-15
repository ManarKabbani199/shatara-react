import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUid(String uid) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('uid', uid);
}

Future<String?> getSavedUid() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('uid');
}

Future<void> clearUid() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('uid');
}
