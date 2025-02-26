import 'package:flutter/material.dart';
import 'package:supplement_zan/database/db_helper.dart'; // 正しいパスを指定
import 'package:supplement_zan/models/supplement.dart';

class EditSupplementScreen extends StatefulWidget {
  final Supplement supplement;

  const EditSupplementScreen({super.key, required this.supplement});

  @override
  _EditSupplementScreenState createState() => _EditSupplementScreenState();
}

class _EditSupplementScreenState extends State<EditSupplementScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _dailyConsumptionController;
  final DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.supplement.name);
    _quantityController = TextEditingController(text: widget.supplement.quantity.toString());
    _dailyConsumptionController = TextEditingController(text: widget.supplement.dailyConsumption.toString());
  }

Future<void> _updateSupplement(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    final updatedSupplement = Supplement(
      id: widget.supplement.id,
      name: _nameController.text,
      quantity: int.parse(_quantityController.text),
      dailyConsumption: int.parse(_dailyConsumptionController.text),
    );

    final dbHelper = DBHelper();
    await dbHelper.updateSupplement(updatedSupplement);

    print("🔄 更新するサプリメント: ${updatedSupplement.name} (ID: ${updatedSupplement.id})");

    // 🔹 `Navigator.pop()` の戻り値として `updatedSupplement` を渡す
    Navigator.pop(context, updatedSupplement);
  }
}

  Future<void> _updateSupplementQuantity(int id, int newQuantity) async {
    await _dbHelper.updateSupplementQuantity(id, newQuantity);
    // 必要に応じて他の処理を追加
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('サプリメント編集'),
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
  onPressed: () => _updateSupplement(context), // ✅ 無名関数で `BuildContext` を渡す
  child: Text('更新'),
),
              // ElevatedButton(
              //   onPressed: _updateSupplement,
              //   child: Text('サプリメントを更新'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}