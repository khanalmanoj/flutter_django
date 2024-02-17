
// order.dart
class OrderModel {
  int? id;
  int? userId;
  int? total;
  DateTime? dateTime;
  List<OrderItem>? order_items;

  OrderModel({this.id, this.userId, this.total, this.dateTime,this.order_items});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['user'],
      total: json['total'],
      dateTime: DateTime.parse(json['date_time']),
      order_items: (json['order_items'] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
    );
  }
}

// order_item.dart
class OrderItem {
  int? id;
  int? orderId;
  int? foodId;
  int? quantity;

  OrderItem({this.id, this.orderId, this.foodId, this.quantity});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order'],
      foodId: json['food'],
      quantity: json['quantity'],
    );
  }
}

class Order {
  int? id;
  int? userId;
  int? total;
  DateTime? dateTime;

  Order({this.id, this.userId, this.total, this.dateTime});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user'],
      total: json['total'],
      dateTime: DateTime.parse(json['date_time']),
    );
  }
}


class Food {
  int? id;
  String? foodName;
  String? desc;
  int? price;
  String? time;
  String? image;

  Food({this.id, this.foodName, this.desc, this.price, this.time, this.image});

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      foodName: json['food_name'],
      desc: json['desc'],
      price: json['price'],
      time: json['time'],
      image: json['image'],
    );
  }
}


class History {
  final int id;
  final int totalAmount;
  final List<FoodItem> foodItemsOrdered;
  final DateTime date;

  History({
    required this.id,
    required this.totalAmount,
    required this.foodItemsOrdered,
    required this.date,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'],
      totalAmount: json['total_amount'],
      foodItemsOrdered: (json['food_items_ordered'] as List)
          .map((item) => FoodItem.fromJson(item))
          .toList(),
      date: DateTime.parse(json['date']), // Assuming 'date' is in ISO 8601 format
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
