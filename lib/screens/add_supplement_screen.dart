import 'package:flutter/material.dart';
import 'package:supplement_zan/database/db_helper.dart';
import 'package:supplement_zan/models/supplement.dart';

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
    final dbHelper = DBHelper();

    // 🔹 `ID` を `0` にせず、データベースの `ID` を設定する
    int newId = await dbHelper.insertSupplement(
      Supplement(
        id: 0, // 🔴 `0` だが、DBが正しいIDを返す
        name: _nameController.text,
        quantity: int.parse(_quantityController.text),
        dailyConsumption: int.parse(_dailyConsumptionController.text),
      ),
    );

    final savedSupplement = Supplement(
      id: newId, // ✅ データベースの `ID` を適用
      name: _nameController.text,
      quantity: int.parse(_quantityController.text),
      dailyConsumption: int.parse(_dailyConsumptionController.text),
    );

    print("✅ 追加されたサプリメント: ${savedSupplement.name} (ID: ${savedSupplement.id})");

    Navigator.pop(context, savedSupplement);
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