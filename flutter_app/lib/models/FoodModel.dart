class FoodModel {
  int? id;
  int? userId; 
  int? quantity;
  String? title;
  String? desc;
  double? price;
  String? time;
  String? image;

  FoodModel({this.id, this.userId, this.quantity, this.title, this.desc, this.price, this.time, this.image});

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'],
      userId: json['user_id'], 
      quantity: json['quantity'],
      title: json['food_name'],
      desc: json['desc'],
      price: json['price'] as double,
      time: json['time'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food': title,
      'quantity': quantity,
      'user_id': userId, 
    };
  }
}
