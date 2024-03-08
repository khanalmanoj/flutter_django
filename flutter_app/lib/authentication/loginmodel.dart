class User {
  String? token;
  String? email;
  int? id;
  String? username;
  bool? isStaff;

  User(
      {this.token, this.email,this.id, this.username, this.isStaff});

  factory User.fromJson(json) {
    return User(
      token: json['token'],
      email: json['email'],
      id: json['pk'],
      username: json['username'],
      isStaff: json['is_staff']
    );
  }
}
