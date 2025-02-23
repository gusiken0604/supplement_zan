import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _thresholdController = TextEditingController();
  int _threshold = 10;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadThreshold();
  }

  Future<void> _loadThreshold() async {
    setState(() {
      _threshold = _prefs.getInt('threshold') ?? 10;
      _thresholdController.text = _threshold.toString();
    });
  }

  Future<void> _saveThreshold() async {
    await _prefs.setInt('threshold', int.parse(_thresholdController.text));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _thresholdController,
              decoration: const InputDecoration(labelText: '通知の残薬数'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveThreshold,
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}