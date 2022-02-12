
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseHelper {
  FirebaseAuth auth = FirebaseAuth.instance;

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
