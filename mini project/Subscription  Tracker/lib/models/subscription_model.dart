class SubscriptionModel {
  final String? id;
  final String name;
  final double price;
  final String date;
  final String category;

  SubscriptionModel({
    this.id,
    required this.name,
    required this.price,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'date': date,
      'category': category,
    };
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map, String id) {
    return SubscriptionModel(
      id: id,
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      date: map['date'] ?? '',
      category: map['category'] ?? 'Other',
    );
  }
}
