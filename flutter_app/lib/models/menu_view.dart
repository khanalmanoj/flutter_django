import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/user_app/authentication/loginmodel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/menu.dart';
import 'package:flutter_app/user_app/service.dart';

class FoodViewModel extends ChangeNotifier {
  final String? userToken;

  FoodViewModel(this.userToken);

  User? user;
  var foodLists = <FoodModel>[];
  var filteredFoodLists = <FoodModel>[];
  var filteredDrinks = <FoodModel>[];
  var cartLists = <FoodModel>[];

  var isLoading = true;

  setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  Future<void> getAllMenu() async {
    setLoading(true);
    var food = await Service.fetchAllFoods();
    if (food != null) {
      foodLists = food;
      setLoading(false);
    }
  }

  Future<void> getdrinks() async {
    setLoading(true);
    if (foodLists.isEmpty) {
      await getAllMenu();
    } else {
      filteredDrinks =
          foodLists.where((element) => element.category == 'Drinks').toList();
      setLoading(false);
    }
  }

  Future<void> getfood() async {
    filteredFoodLists =
        foodLists.where((element) => element.category == '').toList();
    notifyListeners();
  }

  Future<void> filterFoodByCategory(String category) async {
    if (category.isEmpty) {
      filteredFoodLists =
          List.from(foodLists); // If category is empty, show all items
    } else {
      filteredFoodLists =
          foodLists.where((foodItem) => foodItem.category == category).toList();
    }
    notifyListeners(); // Notify listeners to update UI
  }

  Future<void> addToCart(int foodId) async {
    const String apiUrl = 'http://127.0.0.1:8000/api/addorder/';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': "token $userToken"
        },
        body: jsonEncode(<String, dynamic>{
          'id': foodId,
        }),
      );

      if (response.statusCode == 200) {
        // Successfully added to cart
        print('Food added to order successfully');
      } else {
        // Error adding to cart
        print(
            'Failed to add food to order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Exception occurred
      print('Exception adding food to cart: $e');
    }
  }

  // int get countCart => cartLists.length;
  // double get totalPrice => cartLists.fold(
  //     0,
  //     (previousValue, element) =>
  //         previousValue +
  //         (double.parse(element.price!.toString()) * (element.quantity ?? 0)));

  // addCart(FoodModel item) {
  //   item.quantity ??= 1;
  //   cartLists.add(item);
  //   notifyListeners();
  // }

  // incrementQuantity(FoodModel item) {
  //   item.quantity = (item.quantity ?? 0) + 1;
  //   notifyListeners();
  // }

  // decrementQuantity(FoodModel item) {
  //   if (item.quantity != null && item.quantity! > 1) {
  //     item.quantity = item.quantity! - 1;
  //   }
  //   notifyListeners();
  // }

  // removeCart(FoodModel item) {
  //   cartLists.remove(item);
  //   notifyListeners();
  // }

  // clearCart() {
  //   cartLists.clear();
  // }

  // String cartListtoJson() {
  //   List<String> jsonDataList = [];

  //   for (var item in cartLists) {
  //     Map<String, dynamic> jsonData = item.toJson();
  //     String jsonDataString = json.encode(jsonData);
  //     jsonDataList.add(jsonDataString);
  //   }

  //   print(jsonDataList.toString());
  //   return jsonDataList.toString();
  // }

  // // List<Map<String, dynamic>> carttooJson() {
  // //   List<Map<String, dynamic>> orderItems = [];

  // //   for (var item in cartLists) {
  // //     Map<String, dynamic> itemData = {
  // //       'food_name': item.id,
  // //       'desc': item.desc,
  // //       'time': item.time,
  // //     };
  // //     orderItems.add(itemData);
  // //   }
  // //   return orderItems;
  // // }

  // Map<String, dynamic> carttoJson() {
  //   Map<String, dynamic> jsonData = {};

  //   for (var item in cartLists) {
  //     jsonData['food'] = item.id;
  //     jsonData['quantity'] = item.quantity;
  //     jsonData['u_id'] = item.userId;
  //   }
  //   print(jsonData.toString());
  //   return jsonData;
  // }

  // createOrderItem() async {
  //   final response = await http.post(
  //     Uri.parse('http://127.0.0.1:8000/api/orderitem/create/'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(carttoJson()),
  //   );

  //   if (response.statusCode == 201) {
  //     print('Orderitem created successfully');
  //   } else {
  //     print('Failed to create orderitem: ${response.statusCode}');
  //     print(response.body);
  //   }
  // }

  // createOrder() async {
  //   Map<String, dynamic> jsonData = {
  //     'user': '2',
  //   };
  //   final response = await http.post(
  //     Uri.parse('http://127.0.0.1:8000/api/orders/create/'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(jsonData),
  //   );

  //   if (response.statusCode == 201) {
  //     print('Order created successfully');
  //   } else {
  //     print('Failed to create order: ${response.statusCode}');
  //     print(response.body);
  //   }
  // }
}
