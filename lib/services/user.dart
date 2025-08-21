import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_b23_firebase/models/user.dart';

class UserServices {
  ///Create User
  Future createUser(UserModel model) async {
    return await FirebaseFirestore.instance
        .collection('userCollection')
        .doc(model.docId.toString())
        .set(model.toJson(model.docId.toString()));
  }

  ///Get User By ID
  Future<UserModel> getUserByID(String userID) {
    return FirebaseFirestore.instance
        .collection('userCollection')
        .doc(userID)
        .get()
        .then((userJson) => UserModel.fromJson(userJson.data()!));
  }

  ///Update Profile
  Future updateUser(UserModel model) async {
    return await FirebaseFirestore.instance
        .collection('userCollection')
        .doc(model.docId)
        .update({
          'name': model.name,
          'phone': model.phone,
          'address': model.address,
        });
  }
}
