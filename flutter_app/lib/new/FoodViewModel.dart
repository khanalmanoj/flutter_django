import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/new/FoodModel.dart';
import 'package:flutter_app/new/Service.dart';

class FoodViewModel extends ChangeNotifier {
  var foodLists = <FoodModel>[];
  var cartLists = <FoodModel>[];
  var isLoading = true;

  int get countCart => cartLists.length;
  double get totalPrice => cartLists.fold(
      0,
      (previousValue, element) =>
          previousValue +
          (double.parse(element.price!.toString()) * (element.quantity ?? 0)));

  setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  Future<void> getAllProducts() async {
    var food = await Service.fetchAllFoods();
    if (food != null) {
      foodLists = food;
      setLoading(false);
    }
  }

  addCart(FoodModel item) {
    item.quantity ??= 1;
    cartLists.add(item);
    notifyListeners();
  }

  incrementQuantity(FoodModel item) {
    item.quantity = (item.quantity ?? 0) + 1;
    notifyListeners();
  }

  decrementQuantity(FoodModel item) {
    if (item.quantity != null && item.quantity! > 1) {
      item.quantity = item.quantity! - 1;
    }
    notifyListeners();
  }

  removeCart(FoodModel item) {
    cartLists.remove(item);
    notifyListeners();
  }

  clearCart() {
    cartLists.clear();
  }

  String cartListtoJson() {
  List<String> jsonDataList = [];

  for (var item in cartLists) {
    Map<String, dynamic> jsonData = item.toJson();
    String jsonDataString = json.encode(jsonData);
    jsonDataList.add(jsonDataString);
  }

  print(jsonDataList.toString());
  return jsonDataList.toString();
}

  Map<String,dynamic> carttoJson() {

    Map<String, dynamic> jsonData = {};

    for (var item in cartLists) {
      jsonData['food'] = item.id;
      jsonData['items'] = cartListtoJson();
      jsonData['quantity'] = item.quantity;
    }
    return jsonData;
  }

  createOrder() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/orders/create/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(carttoJson()),
    );

    if (response.statusCode == 201) {
      print('Order created successfully');
    } else {
      print('Failed to create order: ${response.statusCode}');
      print(response.body);
    }
  }
}
