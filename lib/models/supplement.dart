class Supplement {
  final int id;
  final String name;
  final int quantity;
  final int dailyConsumption;

  Supplement({
    required this.id,
    required this.name,
    required this.quantity,
    required this.dailyConsumption,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'dailyConsumption': dailyConsumption,
    };
  }
factory Supplement.fromMap(Map<String, dynamic> map) {
  return Supplement(
    id: map['id'] ?? 0, // ✅ `ID` を必ず取得（デフォルト値 `0` を回避）
    name: map['name'],
    quantity: map['quantity'],
    dailyConsumption: map['dailyConsumption'],
  );
}
  // factory Supplement.fromMap(Map<String, dynamic> map) {
  //   return Supplement(
  //     id: map['id'],
  //     name: map['name'],
  //     quantity: map['quantity'],
  //     dailyConsumption: map['dailyConsumption'],
  //   );
  // }
}