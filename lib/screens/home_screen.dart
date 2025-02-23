import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('サプリメント管理'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // サプリメント追加画面に遷移
          },
          child: const Text('サプリメントを追加'),
        ),
      ),
    );
  }
}