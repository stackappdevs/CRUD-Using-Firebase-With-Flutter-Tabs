import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/screen/data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseHelper {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseHelper._();

  static final FirebaseHelper instance = FirebaseHelper._();

  Future<UserCredential> registrationWithEmail(
      String email, String password) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    return userCredential;
  }

  Future<UserCredential> loginWithEmail(String email, String password) async {
    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);

    return userCredential;
  }

  void logOut() {
    auth.signOut();
  }
}

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference _collectionReference =
    FirebaseFirestore.instance.collection('Users');

UserData? availableUser;

Future<void> addUser(String name, String email, String date, String password) {
  return _collectionReference
      .add({'name': name, 'email': email, 'dob': date, 'password': password});
}

Future<void> updateUser(
    String id, String name, String email, String date, String password) {
  return _collectionReference.doc(id).update({
    'name': name,
    'email': email,
    'dob': date,
    'password': password
  }).catchError((error) => print('update error $error'));
}

Future<void> deleteUser(id) {
  return _collectionReference.doc(id).delete();
}

Future isUserAvailable() {
  print('datain');
  return _collectionReference.get().then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((element) {
      availableUser = UserData(
          name: element['name'],
          email: element['email'],
          password: element['password'],
          dob: element['dob']);
      userList.add(availableUser);
    });
    print(userList.length);
  });
}
