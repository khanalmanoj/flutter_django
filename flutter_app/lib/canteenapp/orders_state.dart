import 'dart:convert';
import 'package:flutter_app/baseurl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_app/canteenapp/canteen_model.dart';


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

  Future<Map<String, dynamic>> verifyOrderToken(String token) async {
  String url = '$baseUrl/api/verifytoken/'; // Replace with your API endpoint

  try {
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({'token': token}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return {'order_id': responseData['order_id']}; // Return order_id
    } else if (response.statusCode == 400) {
      throw Exception('Token not provided');
    } else if (response.statusCode == 404) {
      throw Exception('Order not found for the provided token');
    } else {
      throw Exception('Failed to verify order token: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to connect to the server: $e');
  }
}


Future<Map<String, dynamic>> checkOrderItem(String token) async {
  String url = '$baseUrl/api/checkorder/'; 

  try {
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({'token': token}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {'error': true, 'message': 'Failed to call API'};
    }
  } catch (e) {
    // Exception occurred during API call
    return {'error': true, 'message': 'Exception: $e'};
    }
  }

  Future<void> checkoutOrder(String token) async {
    String url = '$baseUrl/api/checkout/';
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: {
          jsonEncode({'token': token}),
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
