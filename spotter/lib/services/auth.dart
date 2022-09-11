import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on User
  SpotterUser _user(User? user) {
    return SpotterUser(uid: user?.uid);
  }

  //auth change user stream
  Stream<SpotterUser> get user {
    //return _auth.authStateChanges().map((User? user) => _user(user!));
    //Same thing
    return _auth.authStateChanges().map(_user);
  }

  //sign in anon
  Future anonSignIn() async {
    try {
      /** These class names are different than the demonstration due to updates in API*/
      UserCredential userCred = await _auth.signInAnonymously();
      User? user = userCred.user;
      return _user(user!);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  //sign in with email & password
  //register with email & password
  //sign out
  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
