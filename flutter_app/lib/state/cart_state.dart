import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/cart.dart';
import 'package:http/http.dart' as http;

const baseUrl = "http://127.0.0.1:8000";


class CartState with ChangeNotifier {
 final String? userToken;

  CartState(this.userToken);

  List<OrderModel> _orderModels = [];

  List<OrderModel> get orderModels => _orderModels;

  Future<void> getOrderDatas() async {
    String url = '$baseUrl/api/order/';
    try {
      http.Response response = await http.get(Uri.parse(url), headers: {
        "Authorization": "token $userToken",
      });
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as Map;
        print(data['error']);
        if (data['error'] == false) {
          List<OrderModel> demo = [];
          for (var item in data['data']) {
            demo.add(OrderModel.fromJson(item));
          }
          _orderModels = demo;
          notifyListeners();
        } else {
          print(data['data']);
        }
      } else {
        // Handle unexpected status code
        print('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Error getCartDatas: $e');
    }
  }

  Future<void> deleteOrderitem(int id) async {
    String url = '$baseUrl/api/deleteitem/';
    try {
      http.Response response = await http.post(Uri.parse(url), body: {
        "id": id.toString(),
      }, headers: {
        "Authorization": "token $userToken",
      });
      if (response.statusCode == 200) {
        notifyListeners();
        print('Cart item deleted successfully');
      } else {
        // Handle unexpected status code
        print('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Error deleteCart: $e');
    }
  }

  Future<void> deleteOrder(int id) async {
    String url = '$baseUrl/api/deleteorder/';
    try {
      http.Response response = await http.post(Uri.parse(url), body: {
        "id": id.toString(),
      }, headers: {
        "Authorization": "token $userToken",
      });
      if (response.statusCode == 200) {
        notifyListeners();
        print('Cart deleted successfully');
      } else {
        // Handle unexpected status code
        print('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Error deleteCart: $e');
    }
  }

    Future<void> checkoutOrder(int id) async {
    String url = '$baseUrl/api/checkout/';
    try {
      http.Response response = await http.post(Uri.parse(url), body: {
        "id": id.toString(),
      }, headers: {
        "Authorization": "token $userToken",
      });
      if (response.statusCode == 200) {
        notifyListeners();
        print('Orders created sucessfully');
      } else {
        // Handle unexpected status code
        print('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Error checkout: $e');
    }
  }

  List<History> _checkouts = [];
  List<History> get checkouts => _checkouts;

  String url = '$baseUrl/api/history/';

  Future<void> fetchCheckouts() async { // Add your authentication token here
    final urls = Uri.parse(url);
    
    try {
      final response = await http.get(
        urls,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonBody = jsonDecode(response.body);
        _checkouts = jsonBody.map((item) => History.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load checkout data');
      }
    } catch (e) {
      // Handle error
      print('Error fetching checkout data: $e');
    }
  }
}
