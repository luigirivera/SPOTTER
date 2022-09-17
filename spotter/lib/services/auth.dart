import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotter/services/database.dart';

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? uid;

  //gets the uid of current logged in User
  String? getUID() {
    uid ??= _auth.currentUser!.uid;

    return uid;
  }

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
  Future signInEP(String email, String password) async {
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCred.user;
      return _user(user);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        return 'The email is not in use';
      } else if (error.code == 'wrong-password') {
        return 'Incorrect password';
      }
    } catch (error) {
      debugPrint('Not FirebaseAuthException: $error');
      return null;
    }
  }

  //register with email & password
  Future registerEP(String email, String password) async {
    try {
      /** previously AuthResult */
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = userCred.user;

      /** Creating a document for the user */
      await DatabaseService(uid: user!.uid)
          .initiateTaskData('Add your first task here');

      return _user(user);
    } on FirebaseAuthException catch (error) {
      //This is the specific error catching method found on documentation
      if (error.code == 'weak-password') {
        return 'The password provided is too weak';
      } else if (error.code == 'email-already-in-use') {
        return 'The email is already in use';
      }
    } catch (error) {
      debugPrint('Not FirebaseAuthException: $error');
      return null;
    }
  }

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
