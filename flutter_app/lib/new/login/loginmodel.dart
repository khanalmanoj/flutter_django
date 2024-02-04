// class Login {
//   String? status;
//   int? statusCode;
//   Data? data;
//   String? message;

//   Login({this.status, this.statusCode, this.data, this.message});

//   Login.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     statusCode = json['status_code'];
//     data = json['data'] != null ? Data.fromJson(json['data']) : null;
//     message = json['message'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['status_code'] = statusCode;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     data['message'] = message;
//     return data;
//   }
// }

// class Data {
//   String? name;
//   String? mobileno;

//   Data({this.name, this.mobileno});

//   Data.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     mobileno = json['mobileno'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = name;
//     data['mobileno'] = mobileno;
//     return data;
//   }
// }

class User {
  String? token;
  String? email;
  int? id;
  String? username, first_name, last_name;

  User(
      {this.token, this.email,this.id, this.username, this.first_name, this.last_name});

  factory User.fromJson(json) {
    return User(
      token: json['token'],
      email: json['email'],
      id: json['pk'],
      username: json['username'],
      first_name: json['first_name'],
      last_name: json['last_name'],
    );
  }
}
