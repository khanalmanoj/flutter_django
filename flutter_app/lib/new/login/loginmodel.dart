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
