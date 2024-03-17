import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Sign up with email and password
  Future<User?> registerWithEmailAndPassword(String fullName, String email, String password) async {
    try {
      UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      User? user = result.user;

      if (user != null) {

        await DatabaseService(uid: user.uid).savingUserData(email, fullName);

      }

      return user;
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      User? user = result.user;
      return user;
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool?> signOut() async {
    try{
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserEmailSF("");
      await HelperFunction.saveUserNameSF("");

      await firebaseAuth.signOut();

      return true;
    }
    catch (e) {
      return null;
    }
  }
}