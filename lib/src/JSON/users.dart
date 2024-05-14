import 'dart:convert';

class Users {
  final int? usrId;
  final String? fullName;
  final String? email;
  final String usrName;
  final String password;
  final String? phoneNumber; 
  final String? address;

  Users({
    this.usrId,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.address,
    required this.usrName,
    required this.password,
  });

  factory Users.fromMap(Map<String, dynamic> json) => Users(
        usrId: json["usrId"],
        fullName: json["fullName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        address: json["address"],
        usrName: json["usrName"],
        password: json["usrPassword"],
      );

  Map<String, dynamic> toMap() => {
        "usrId": usrId,
        "fullName": fullName,
        "email": email,
        "phoneNumber": phoneNumber,
        "address": address,
        "usrName": usrName,
        "usrPassword": password,
      };
}

// JSON serialization and deserialization functions
Users usersFromMap(String str) => Users.fromMap(json.decode(str));

String usersToMap(Users data) => json.encode(data.toMap());
