import 'dart:convert';

class Admins {
  final String userName;
  final String password;

  Admins({
    required this.userName,
    required this.password,
  });

  factory Admins.fromMap(Map<String, dynamic> json) => Admins(
        userName: json["userName"],
        password: json["password"],
      );

  Map<String, dynamic> toMap() => {
        "userName": userName,
        "password": password,
      };
}

// JSON serialization and deserialization functions
Admins adminsFromMap(String str) => Admins.fromMap(json.decode(str));

String adminsToMap(Admins data) => json.encode(data.toMap());
