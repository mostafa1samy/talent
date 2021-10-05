import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String photoUrl;
  final String talent;
  final String phone;
  final String password;


  UserModel({this.id,
    this.username,
    this.email,
    this.photoUrl,
    this.talent,
    this.phone,
    this.password
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
        id: doc["useruid"],
        username: doc["username"],
        email: doc["useremail"],
        photoUrl: doc["userimage"],
        talent: doc["talent"],
      phone: doc["phone"],
      password: doc["userpassword"],
        );
  }
}
