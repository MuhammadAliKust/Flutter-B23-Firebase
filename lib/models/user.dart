// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));


class UserModel {
  final String? docId;
  final String? name;
  final String? address;
  final String? phone;
  final String? email;
  final int? createdAt;

  UserModel({
    this.docId,
    this.address,
    this.name,
    this.phone,
    this.email,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    docId: json["docID"],
    name: json["name"],
    address: json["address"],
    phone: json["phone"],
    email: json["email"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson(String userID) => {
    "docID": userID,
    "name": name,
    "phone": phone,
    "email": email,
    "address": address,
    "createdAt": createdAt,
  };
}
