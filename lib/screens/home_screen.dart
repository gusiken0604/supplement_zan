import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../database/db_helper.dart';
import '../models/supplement.dart';
import 'add_supplement_screen.dart';
import 'edit_supplement_screen.dart';
import 'settings_screen.dart'; // 設定画面のインポート
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Supplement> _supplements = [];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadSupplements();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _loadSupplements() async {
    final supplements = await _dbHelper.getAllSupplements();
    setState(() {
      _supplements = supplements;
    });
    _checkSupplements();
  }

  Future<void> _checkSupplements() async {
    for (var supplement in _supplements) {
      if (supplement.quantity < 10) { // 残数が10未満の場合に通知
        await _showNotification(supplement);
      }
    }
  }

  Future<void> _showNotification(Supplement supplement) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description', // 名前付き引数を使用
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Supplement Added',
      'A new supplement has been added: ${supplement.name}',
      platformChannelSpecifics,
    );
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

  Future<void> _navigateToSettingsScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettingsScreen,
          ),
        ],
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
                  onTap: () => _navigateToEditScreen(supplement),
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