class CartItem {
  final String id;
  final String equipmentId;
  final int quantity;
  final DateTime startDate;
  final DateTime endDate;

  CartItem({
    required this.id,
    required this.equipmentId,
    required this.quantity,
    required this.startDate,
    required this.endDate,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      equipmentId: json['equipmentId'],
      quantity: json['quantity'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'equipmentId': equipmentId,
      'quantity': quantity,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}
