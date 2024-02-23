class Orders {
  final int id;
  final int userId;
  final int totalAmount;
  final List<FoodItem> foodItemsOrdered;
  final DateTime date;

  Orders({
    required this.userId,
    required this.id,
    required this.totalAmount,
    required this.foodItemsOrdered,
    required this.date,
  });

  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
      id: json['id'],
      userId: json['user'],
      totalAmount: json['total_amount'],
      foodItemsOrdered: (json['food_items_ordered'] as List)
          .map((item) => FoodItem.fromJson(item))
          .toList(),
      date:
          DateTime.parse(json['date']), // Assuming 'date' is in ISO 8601 format
    );
  }
}

class FoodItem {
  String foodName;
  int quantity;

  FoodItem({
    required this.foodName,
    required this.quantity,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      foodName: json['food_name'],
      quantity: json['quantity'],
    );
  }
}
