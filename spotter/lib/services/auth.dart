import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //sign in anon
  Future anonSignIn() async{
    try{
      /** These class names are different than the demonstration */
      UserCredential userCred = await _auth.signInAnonymously();
      User? user = userCred.user;
      return user;
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //sign in with email & password
  //register with email & password
  //sign out
}