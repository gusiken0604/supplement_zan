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
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
Future<void> _loadSupplements() async {
  final dbHelper = DBHelper();
  final loadedSupplements = await dbHelper.getAllSupplements();

  setState(() {
    _supplements = loadedSupplements;
  });

  print("📦 保存されているサプリメントの数: ${_supplements.length}");
}
  // Future<void> _loadSupplements() async {
  //   final supplements = await _dbHelper.getAllSupplements();
  //   setState(() {
  //     _supplements = supplements;
  //   });
  //   _checkSupplements();
  // }

  Future<void> _checkSupplements() async {
    for (var supplement in _supplements) {
      if (supplement.quantity < 10) { // 残数が10未満の場合に通知
        print('通知を表示: ${supplement.name}'); // デバッグログを追加
        await _showNotification(supplement);
      }
    }
  }

  Future<void> _showNotification(Supplement supplement) async {
    final depletionDate = _calculateDepletionDate(supplement);
    final notificationMessage = '$depletionDateに${supplement.name}がなくなります。';

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description', // 名前付き引数を使用
      importance: Importance.max,
      priority: Priority.high,
    );
    const DarwinNotificationDetails iosPlatformChannelSpecifics = DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'サプリメント残数警告',
      notificationMessage,
      platformChannelSpecifics,
    );
  }

  Future<void> _showTestNotification() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      "テスト通知",
      "バナー通知が正しく表示されるか確認してください。",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
Future<void> _navigateToEditScreen(Supplement supplement) async {
  final updatedSupplement = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => EditSupplementScreen(supplement: supplement)),
  );

  if (updatedSupplement != null && updatedSupplement is Supplement) {
    setState(() {
      // ✅ `id` で正しいデータを検索・更新
      final index = _supplements.indexWhere((s) => s.id == updatedSupplement.id);
      if (index != -1) {
        _supplements[index] = updatedSupplement;
        print("✅ 更新されたサプリメント: ${updatedSupplement.name} (ID: ${updatedSupplement.id})");
      } else {
        print("⚠️ 更新対象のサプリメントがリストに見つかりませんでした (ID: ${updatedSupplement.id})");
      }
    });

    _saveSupplements(); // ✅ データベースへ保存
  }
}

Future<void> _navigateToAddScreen() async {
  final newSupplement = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddSupplementScreen()),
  );

  if (newSupplement != null && newSupplement is Supplement) {
    setState(() {
      _supplements.add(newSupplement);
    });

    print("✅ 追加されたサプリメント: ${newSupplement.name} (ID: ${newSupplement.id})");
    _saveSupplements(); // ✅ データベースに保存
  }
}
// Future<void> _navigateToAddScreen() async {
//   final newSupplement = await Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => AddSupplementScreen()),
//   );

//   if (newSupplement != null && newSupplement is Supplement) {
//     setState(() {
//       _supplements.add(newSupplement);
//     });

//     print("✅ 追加されたサプリメント: ${newSupplement.name} (ID: ${newSupplement.id})");
//     _saveSupplements();
//   }
// }
// Future<void> _navigateToAddScreen() async {
//   final newSupplement = await Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => AddSupplementScreen()),
//   );

//   if (newSupplement != null && newSupplement is Supplement) {
//     setState(() {
//       _supplements.add(newSupplement); // ✅ 追加したサプリメントをリストに追加
//     });

//     _saveSupplements(); // ✅ データベースに保存
//   }
// }

Future<void> _saveSupplements() async {
  final dbHelper = DBHelper();
  for (var supplement in _supplements) {
    await dbHelper.updateSupplement(supplement);
  }
}
// Future<void> _navigateToAddScreen() async {
//   final newSupplement = await Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => AddSupplementScreen()),
//   );

//   if (newSupplement != null && newSupplement is Supplement) {
//     setState(() {
//       _supplements.add(newSupplement); // 🔹 追加したサプリメントをリストに追加
//     });
//   }
// }
  // Future<void> _navigateToAddScreen() async {
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => AddSupplementScreen()),
  //   );

  //   if (result == true) {
  //     _loadSupplements();
  //   }
  // }

  // Future<void> _navigateToEditScreen(Supplement supplement) async {
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => EditSupplementScreen(supplement: supplement)),
  //   );

  //   if (result == true) {
  //     _loadSupplements();
  //   }
  // }

  Future<void> _navigateToSettingsScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  Future<void> _updateSupplementQuantity(int id, int newQuantity) async {
    await _dbHelper.updateSupplementQuantity(id, newQuantity);
    _loadSupplements();
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
      floatingActionButton: Stack(
        children: [
          // サプリメント追加ボタン
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: _navigateToAddScreen,
              child: const Icon(Icons.add),
              tooltip: "サプリメントを追加",
            ),
          ),

          // 通知テストボタン
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: FloatingActionButton(
              onPressed: _showTestNotification,
              child: const Icon(Icons.notifications),
              tooltip: "テスト通知を送る",
            ),
          ),
        ],
      ),
    );
  }
}