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

  Future<void> checkoutOrder(int orderid,int userid) async {
    String url = '$baseUrl/api/checkout/';
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: {
          "orderid": orderid.toString(),
          "userid": userid.toString(),
        },
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
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
}
