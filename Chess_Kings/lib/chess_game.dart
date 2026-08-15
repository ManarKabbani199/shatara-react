import 'package:flutter/material.dart';

class ChessGame extends StatelessWidget {
  const ChessGame({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChessBoardPage(),
    );
  }
}

class ChessBoardPage extends StatelessWidget {
   ChessBoardPage({super.key});

  final double squareSize = 40;

  // الجيش الاحتياطي
  final List<String> reservePieces = [
    '♟', '♟', '♟', '♟', // 4 جنود
    '♞', '♞',           // 2 حصان
    '♝', '♝',           // 2 فيل
    '♜', '♜',           // 2 قلعة
    '♛', '♛',           // 2 وزير
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("شطرنج شطارة")),
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الرقعة
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(8, (row) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(8, (col) {
                    bool isDark = (row + col) % 2 == 1;
                    return Container(
                      width: squareSize,
                      height: squareSize,
                      color: isDark ? Colors.brown : Colors.white,
                      child: const Center(),
                    );
                  }),
                );
              }),
            ),
            const SizedBox(width: 20),
            // الجيش الاحتياطي
            Column(
              mainAxisSize: MainAxisSize.min,
              children: reservePieces.map((piece) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  width: squareSize,
                  height: squareSize,
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(
                    child: Text(
                      piece,
                      style: TextStyle(fontSize: squareSize * 0.6),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
