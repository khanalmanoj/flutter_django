class User {
  String? token;
  String? email;
  int? id;
  String? username;

  User(
      {this.token, this.email,this.id, this.username});

  factory User.fromJson(json) {
    return User(
      token: json['token'],
      email: json['email'],
      id: json['pk'],
      username: json['username']
    );
  }
}
