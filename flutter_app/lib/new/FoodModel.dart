class FoodModel {
  int? id;
  int? quantity;
  String? title;
  String? desc;
  double? price;
  String? time;
  String? image;

  FoodModel({this.id,this.quantity,this.title,this.desc, this.price, this.time, this.image});

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'],
      quantity: json['quantity'],
      title: json['food_name'],
      desc: json['desc'],
      price: json['price']as double,
      time: json['time'],
      image: json['image'],
    );
  }
}
