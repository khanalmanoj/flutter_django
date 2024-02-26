import 'dart:convert';
import 'package:flutter_app/models/menu.dart';
import 'package:http/http.dart' as http;

class Service {
  static var client = http.Client();

  static Future<List<FoodModel>?> fetchAllFoods() async {
    var response =
        await client.get(Uri.parse("http://127.0.0.1:8000/api/food/"));
    if (response.statusCode == 200) {
      var convertedJsonData = jsonDecode(response.body);
      return (convertedJsonData as List)
          .map((e) => FoodModel.fromJson(e))
          .toList();
    } else {
      return null;
    }
  }
}
