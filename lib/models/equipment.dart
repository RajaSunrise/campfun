class Equipment {
  final String id;
  final String name;
  final String description;
  final double pricePerDay;
  final String category;
  final String imageUrl;
  final bool available;

  Equipment({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerDay,
    required this.category,
    required this.imageUrl,
    required this.available,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pricePerDay: (json['pricePerDay'] as num).toDouble(),
      category: json['category'],
      imageUrl: json['imageUrl'],
      available: json['available'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pricePerDay': pricePerDay,
      'category': category,
      'imageUrl': imageUrl,
      'available': available,
    };
  }
}
