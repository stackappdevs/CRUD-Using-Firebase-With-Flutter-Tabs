
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/constants/string_constrants.dart';
import 'package:demoapp/model/user_item.dart';

class UserService{

  CollectionReference collectionReference = FirebaseFirestore.instance.collection('$table_user');

  UserData? availableUser;

  Future<void> addUser(String name, String email, String date, String password) {
    return collectionReference
        .add({'name': name, 'email': email, 'dob': date, 'password': password});
  }

  Future<void> updateUser(
      String id, String name, String email, String date, String password) {
    return collectionReference.doc(id).update({
      'name': name,
      'email': email,
      'dob': date,
      'password': password
    }).catchError((error) => print('update error $error'));
  }

  Future<void> deleteUser(id) {
    return collectionReference.doc(id).delete();
  }

  Future isUserAvailable() {
    return collectionReference.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        availableUser = UserData(
            name: element['name'],
            email: element['email'],
            password: element['password'],
            dob: element['dob']);
        userList.add(availableUser);

      });
      print("=====>${userList.length}");
    });
  }

}