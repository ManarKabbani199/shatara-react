import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileName extends StatefulWidget {
  final Function(String) onSearchChanged;

  const ProfileName({Key? key, required this.onSearchChanged}) : super(key: key);

  @override
  _ProfileNameState createState() => _ProfileNameState();
}

class _ProfileNameState extends State<ProfileName> {
  String username = "جار التحميل...";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (doc.exists) {
          setState(() {
            username = doc.data()?['username'] ?? "مستخدم غير معروف";
          });
        }
      }
    } catch (e) {
      setState(() {
        username = "خطأ في التحميل";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 3;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // مربع البحث
          SizedBox(
            width: screenWidth * 0.39,
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                widget.onSearchChanged(value);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchController.clear();
                    widget.onSearchChanged('');
                  },
                ),
                hintText: 'إبحث',
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),

          // النصوص
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                username,
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.05,
                  color: const Color(0xFF6B4E45),
                ),
              ),
              const Text(
                'أهلا بعودتك',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Color(0xFF6B4E45),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
