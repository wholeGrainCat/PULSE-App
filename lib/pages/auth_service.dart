import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  // Send password reset link with context parameter for showing dialogs
  Future<void> sendPasswordResetLink(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  Future<UserCredential?> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // The user canceled the login
        return null;
      }
      final googleAuth = await googleUser.authentication;
      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      return await _auth.signInWithCredential(cred);
    } catch (e) {
      print('Google sign-in error: $e');
    }
    return null;
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print("The password is too weak.");
      } else if (e.code == 'email-already-in-use') {
        print("The account already exists for that email.");
      }
    } catch (e) {
      print("Something went wrong: $e");
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
        print("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        print("Wrong password provided.");
      }
    } catch (e) {
      print("Something went wrong: $e");
    }
    return null;
  }

  Future<void> signout() async {
    try {
      print("Sign out initiated...");
      await _auth.signOut();
      print("User signed out successfully.");
    } catch (e) {
      throw Exception("Failed to sign out: $e");
    }
  }
}
