import 'package:flutter/material.dart';
import 'package:supplement_zan/database/db_helper.dart' as db;
import 'package:supplement_zan/models/supplement.dart' as model;

class AddSupplementScreen extends StatefulWidget {
  @override
  _AddSupplementScreenState createState() => _AddSupplementScreenState();
}

class _AddSupplementScreenState extends State<AddSupplementScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _dailyConsumptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _quantityController = TextEditingController();
    _dailyConsumptionController = TextEditingController();
  }

  Future<void> _addSupplement(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final newSupplement = model.Supplement(
        id: 0, // 新しいサプリメントのIDを指定
        name: _nameController.text,
        quantity: int.parse(_quantityController.text),
        dailyConsumption: int.parse(_dailyConsumptionController.text),
      );

      // DBHelperを使用して新しいサプリメントをデータベースに追加
      final dbHelper = db.DBHelper();
      await dbHelper.insertSupplement(newSupplement);

      // 追加後に前の画面に戻る
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('サプリメント追加'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: '名前'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '名前を入力してください';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: '数量'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '数量を入力してください';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dailyConsumptionController,
                decoration: InputDecoration(labelText: '1日の消費量'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '1日の消費量を入力してください';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _addSupplement(context), // BuildContext を渡す
                child: Text('サプリメントを追加'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}