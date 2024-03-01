import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_app/canteenapp/canteen_model.dart';

const baseUrl = "http://127.0.0.1:8000";

class OrderState extends ChangeNotifier {
  List<Orders> _orders = [];
  List<Orders> get orders => _orders;

  String url = '$baseUrl/api/allorders/';

  Future<void> fetchAllOrders() async {
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
        _orders = jsonBody.map((item) => Orders.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception('Canteenapp: Failed to load orders data');
      }
    } catch (e) {
      // Handle error
      print('Canteenapp: Error fetching orders data: $e');
    }
  }

  // Future<void> checkoutOrder(String token) async {
  //   String url = '$baseUrl/api/checkout/';
  //   try {
  //     var url = Uri.parse("$baseUrl/api/auth/login/");
  //     var res = await http.post(url, body: body);
  //     http.Response response = await http.post(
  //       Uri.parse(url),
  //       body: body,
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //     var res = await http.post(url, body: body);
  //     if (response.statusCode == 200) {
  //       Map json = jsonDecode(res.body);
  //       String token = json['key'];
  //       notifyListeners();
  //       print('Orders created sucessfully');
  //     } else {
  //       // Handle unexpected status code
  //       print('Unexpected status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     // Handle network errors or other exceptions
  //     print('Error checkout: $e');
  //   }
  // }

  final List<User> _users = [];
  List<User> get users => _users;
  Future<void> fetchUser() async {
    String url = '$baseUrl/api/user/';
    final urls = Uri.parse(url);
    final response = await http.get(
      urls,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      var convertedJsonData = jsonDecode(response.body);
      _users.addAll(
          (convertedJsonData as List).map((e) => User.fromJson(e)).toList());
    }
  }
}
