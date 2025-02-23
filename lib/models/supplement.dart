class Supplement {
  int? id;
  String name;
  int quantity;

  Supplement({this.id, required this.name, required this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
    };
  }

  factory Supplement.fromMap(Map<String, dynamic> map) {
    return Supplement(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
    );
  }
}