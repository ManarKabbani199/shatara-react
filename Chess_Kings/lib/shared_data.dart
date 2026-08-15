library shared_data;
String id_user = '';
String username = '';
String email = '';
String n_login = '';
String n_computer = '';
String n_win = '';
String image1 = "assets/iconrrrr.png";
String name1 = "مستخدم";
String userName1 = "@user";

String image2 = "assets/iconrrrr.png";
String name2 = "مستخدم";
String userName2 = "@user";



RegExp nameExp = RegExp('[a-zA-Z]');
RegExp passExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');