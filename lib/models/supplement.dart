class Supplement {
  final String name;
  final int quantity;
  final int dailyConsumption; // 1日に消費する量を追加

  Supplement({
    required this.name,
    required this.quantity,
    required this.dailyConsumption,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'dailyConsumption': dailyConsumption,
    };
  }

  factory Supplement.fromMap(Map<String, dynamic> map) {
    return Supplement(
      name: map['name'],
      quantity: map['quantity'],
      dailyConsumption: map['dailyConsumption'],
    );
  }
}