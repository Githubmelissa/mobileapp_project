class MenuItem {
  final int itemId;
  final String name;
  final String description;
  final double price;
  int quantity; // Add quantity property

  MenuItem({
    required this.itemId,
    required this.name,
    required this.description,
    required this.price,
    this.quantity = 1, // Set a default value for quantity if needed
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      itemId: int.tryParse(json['item_id'].toString()) ?? 0,
      name: json['name'],
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
    );
  }
}
