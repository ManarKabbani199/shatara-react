import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String login;
  final String play_computer;
  final String wins;
  final String phone_number;
  final String level;
  final String password;
  final String username;
  final String name;
  final String bio;
  final String profileImageUrl;
  final String bannerImageUrl;
  final List<dynamic> followers;
  final List<dynamic> following;
  final bool isBanned;
  final DateTime? createdAt;
  final bool online;

  // ✅ الحقول الجديدة
  final int WChessId;
  final int ShataID;

  UserModel({
    required this.uid,
    required this.email,
    required this.login,
    required this.play_computer,
    required this.wins,
    required this.phone_number,
    required this.level,
    required this.password,
    required this.username,
    required this.name,
    required this.bio,
    required this.profileImageUrl,
    required this.bannerImageUrl,
    required this.followers,
    required this.following,
    this.isBanned = false,
    this.createdAt,
    this.online = false,
    this.WChessId = 0,
    required this.ShataID,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final created = map['createdAt'];
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      login: map['login'] ?? '',
      play_computer: map['play_computer'] ?? '',
      wins: map['wins'] ?? '',
      phone_number: map['phone_number'] ?? '',
      level: map['level'] ?? '',
      password: map['password'] ?? '',
      username: map['username'] ?? '',
      name: map['name'] ?? '',
      bio: map['bio'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      bannerImageUrl: map['bannerImageUrl'] ?? '',
      followers: map['followers'] ?? [],
      following: map['following'] ?? [],
      isBanned: map['isBanned'] ?? false,
      createdAt: created is Timestamp ? created.toDate() : null,
      online: map['online'] ?? false,
      WChessId: map['WChessId'] ?? 0,
      ShataID: map['ShataID'] ?? 10001,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'login': login,
      'play_computer': play_computer,
      'wins': wins,
      'phone_number': phone_number,
      'level': level,
      'password': password,
      'username': username,
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'bannerImageUrl': bannerImageUrl,
      'followers': followers,
      'following': following,
      'isBanned': isBanned,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
      'online': online,
      'WChessId': WChessId,
      'ShataID': ShataID,
    };
  }
}
