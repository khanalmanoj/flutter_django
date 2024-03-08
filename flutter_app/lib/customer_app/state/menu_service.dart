import 'dart:convert';
import 'package:flutter_app/customer_app/models/menu.dart';
import 'package:http/http.dart' as http;
import '../../baseurl.dart';

class Service {
  static var client = http.Client();
  String url = '$baseUrl/api/food/';
  Future<List<FoodModel>?> fetchAllMenu() async {
    var response =
        await client.get(Uri.parse(url));
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
