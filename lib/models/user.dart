class User {
  final String? id;
  final String name;
  final String username;
  final String email;
  final String? noHp;
  final String? password;

  User(
      {this.id,
      required this.name,
      required this.username,
      required this.email,
      this.noHp,
      this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      noHp: json['no_hp'],
      password: json['password'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'no_hp': noHp,
      'password': password,
    };
  }
}
