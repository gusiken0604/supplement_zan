import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/supplement.dart';
import 'add_supplement_screen.dart';

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
      MaterialPageRoute(builder: (context) => const AddSupplementScreen()),
    );

    if (result == true) {
      _loadSupplements();
    }
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
                  subtitle: Text('数量: ${supplement.quantity}'),
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