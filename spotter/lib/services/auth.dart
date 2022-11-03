import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spotter/main.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth.signInWithCredential(credential);
    await objectbox.initTaskCollection();
    await objectbox.initSessionCollection();
  }

  Future deleteGivenUser(User userToDelete) async {
    await userToDelete.delete();
  }

  Future deleteUser() async {
    await _auth.currentUser!.delete();
  }

  ///create user object based on User
  SpotterUser _createSpotterUser(User? user) {
    return SpotterUser(uid: user?.uid, isAnon: user?.isAnonymous);
  }

  User? currentAuthUser() {
    return _auth.currentUser;
  }

  SpotterUser? get currentUser => _createSpotterUser(_auth.currentUser);

  //auth change user stream
  Stream<SpotterUser> get user {
    //return _auth.authStateChanges().map((User? user) => _user(user!));
    //Same thing
    return _auth.authStateChanges().map(_createSpotterUser);
  }

  //sign in anon
  Future anonSignIn() async {
    try {
      /** These class names are different than the demonstration due to updates in API*/
      UserCredential userCred = await _auth.signInAnonymously();
      User? user = userCred.user;
      await objectbox.initTaskCollection();
      await objectbox.initSessionCollection();
      SpotterUser spotterUser = _createSpotterUser(user);
      objectbox.users.put(spotterUser);
      return spotterUser;
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
      SpotterUser spotterUser = _createSpotterUser(user);
      objectbox.users.put(spotterUser);
      return spotterUser;
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
      await objectbox.initTaskCollection();
      await objectbox.initSessionCollection();
      return _createSpotterUser(user);
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
