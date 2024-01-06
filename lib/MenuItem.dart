class MenuItem {
  final int itemId;
  final String name;
  final String description;
  final double price;

  MenuItem({
    required this.itemId,
    required this.name,
    required this.description,
    required this.price,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      itemId: json['item_id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: json['price'].toDouble(),
    );
  }
}
