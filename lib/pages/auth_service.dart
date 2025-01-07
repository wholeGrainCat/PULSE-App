import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Create user with email, password, and username
  Future<User?> createUserWithEmailAndPassword(
      String username, String email, String password) async {
    try {
      // Create the authentication user
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      if (userCredential.user != null) {
        // Create the user document in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'username': username,
          'email': email,
          'profileImageUrl': null,
          'createdAt': FieldValue.serverTimestamp(),
        });

        return userCredential.user;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception("The password is too weak.");
      } else if (e.code == 'email-already-in-use') {
        throw Exception("The account already exists for that email.");
      }
      throw Exception(e.message ?? "An unknown error occurred");
    } catch (e) {
      throw Exception("Failed to create account: $e");
    }
    return null;
  }

  // Sign in with Google and create/update user document
  Future<UserCredential?> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Create/update user document for Google sign-in
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set(
            {
              'uid': userCredential.user!.uid,
              'username': userCredential.user!.displayName ??
                  'User${userCredential.user!.uid.substring(0, 5)}',
              'email': userCredential.user!.email,
              'profileImageUrl': userCredential.user!.photoURL,
              'createdAt': FieldValue.serverTimestamp(),
            },
            SetOptions(
                merge: true)); // merge: true will only update specified fields
      }

      return userCredential;
    } catch (e) {
      throw Exception('Google sign-in error: $e');
    }
  }

  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        throw Exception("Wrong password provided.");
      }
      throw Exception(e.message ?? "An unknown error occurred");
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  // Send password reset link
  Future<void> sendPasswordResetLink(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(e.message ?? "An error occurred"),
        ),
      );
    }
  }

  // Sign out
  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Failed to sign out: $e");
    }
  }

  // Get current user data
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        return doc.data();
      }
      return null;
    } catch (e) {
      throw Exception("Failed to get user data: $e");
    }
  }
}
