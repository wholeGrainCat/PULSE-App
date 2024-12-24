import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log("The password is too weak.");
      } else if (e.code == 'email-already-in-use') {
        log("The account already exists for that email.");
      }
    } catch (e) {
      log("Something went wrong: $e");
    }
    return null;
  }

  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        log("Wrong password provided.");
      }
    } catch (e) {
      log("Something went wrong: $e");
    }
    return null;
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Something went wrong: $e");
    }
  }
}
