import 'dart:convert';
import 'package:flutter_app/authentication/loginmodel.dart';
import 'package:http/http.dart' as http;
import '../baseurl.dart';



Future<dynamic> loginUser(String email, String password) async {
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

Future<void> logoutUser(String token) async {
  var url = Uri.parse("$baseUrl/api/auth/logout/");
  var res = await http.post(url, headers: {
    'Authorization': 'Token $token',
  });
  print(res.body);
}

Future<dynamic> registerUser(
  String username,
  String email,
  String password1,
  String password2,
) async {
  Map<String, dynamic> data = {
    "username": username,
    "email": email,
    "password1": password1,
    "password2": password2,
  };
  var url = Uri.parse("$baseUrl/api/auth/registration/");
  var res = await http.post(url, body: data);
  print("registererror:${res.body}");
  if (res.statusCode == 200 || res.statusCode == 201) {
    Map json = jsonDecode(res.body);
    String token = json['key'];
    User? user = await getUser(token);
    return user;
  } else {
    Map json = jsonDecode(res.body);
    if (json.containsKey("username")) {
      return json["username"][0];
    }
    if (json.containsKey("password1")) {
      return json["password1"][0];
    }
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
