import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/supplement.dart';
import 'add_supplement_screen.dart';
import 'edit_supplement_screen.dart'; // 編集画面のインポート
import 'package:intl/intl.dart'; // 日付フォーマット用

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Supplement> _supplements = [];

  @override
  void initState() {
    super.initState();
    _loadSupplements();
  }

  Future<void> _loadSupplements() async {
    final supplements = await _dbHelper.getAllSupplements();
    setState(() {
      _supplements = supplements;
    });
  }

  Future<void> _navigateToAddScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddSupplementScreen()),
    );

    if (result == true) {
      _loadSupplements();
    }
  }

  Future<void> _navigateToEditScreen(Supplement supplement) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditSupplementScreen(supplement: supplement)),
    );

    if (result == true) {
      _loadSupplements();
    }
  }

  String _calculateDepletionDate(Supplement supplement) {
    if (supplement.dailyConsumption == 0) return '消費速度が設定されていません';
    final daysLeft = supplement.quantity / supplement.dailyConsumption;
    final depletionDate = DateTime.now().add(Duration(days: daysLeft.toInt()));
    return DateFormat('yyyy/MM/dd').format(depletionDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('サプリメント管理'),
      ),
      body: _supplements.isEmpty
          ? const Center(child: Text('サプリメントがありません'))
          : ListView.builder(
              itemCount: _supplements.length,
              itemBuilder: (context, index) {
                final supplement = _supplements[index];
                return ListTile(
                  title: Text(supplement.name),
                  subtitle: Text('数量: ${supplement.quantity}\n残量ゼロ予定日: ${_calculateDepletionDate(supplement)}'),
                  onTap: () => _navigateToEditScreen(supplement), // タップで編集画面に遷移
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}