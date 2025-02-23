import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/supplement.dart';

class AddSupplementScreen extends StatefulWidget {
  const AddSupplementScreen({super.key});

  @override
  _AddSupplementScreenState createState() => _AddSupplementScreenState();
}

class _AddSupplementScreenState extends State<AddSupplementScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  Future<void> _saveSupplement() async {
    if (_formKey.currentState!.validate()) {
      final newSupplement = Supplement(
        name: _nameController.text,
        quantity: int.parse(_quantityController.text),
      );

      await _dbHelper.insertSupplement(newSupplement);

      // 保存後に前の画面に戻る
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('サプリメントを追加'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'サプリメント名'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'サプリメント名を入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: '数量'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '数量を入力してください';
                  }
                  if (int.tryParse(value) == null) {
                    return '有効な数字を入力してください';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveSupplement,
                child: const Text('保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}