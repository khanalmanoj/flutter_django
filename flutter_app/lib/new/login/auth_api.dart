import 'dart:convert';
import 'package:flutter_app/new/login/loginmodel.dart';
import 'package:http/http.dart' as http;

const baseUrl = "http://127.0.0.1:8000";

Future<dynamic> userAuth(String email, String password) async {
  Map body = {
    //"username": "",
    "email": email,
    "password": password
  };
  var url = Uri.parse("$baseUrl/api/auth/login/");
  var res = await http.post(url, body: body);

  print("token:${res.body}");
  if (res.statusCode == 200) {
    Map json = jsonDecode(res.body);
    String token = json['key'];
    User? user = await getUser(token);
    return user;
  } else {
    Map json = jsonDecode(res.body);
    print(json);
    if (json.containsKey("email")) {
      return json["email"][0];
    }
    if (json.containsKey("password")) {
      return json["password"][0];
    }
    if (json.containsKey("non_field_errors")) {
      return json["non_field_errors"][0];
    }
  }
}

Future<User?> getUser(String token) async {
  var url = Uri.parse("$baseUrl/api/auth/user/");
  var res = await http.get(url, headers: {
    'Authorization': 'Token $token',
  });

  var json = jsonDecode(res.body);

  User user = User.fromJson(json);
  user.token = token;
  print(json);
  return user;
}
