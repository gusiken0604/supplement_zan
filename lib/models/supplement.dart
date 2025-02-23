
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

  // toMap メソッドを追加
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'dailyConsumption': dailyConsumption,
    };
  }

  // fromMap メソッドを追加
  factory Supplement.fromMap(Map<String, dynamic> map) {
    return Supplement(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      dailyConsumption: map['dailyConsumption'],
    );
  }
}