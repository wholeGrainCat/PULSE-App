import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Create user with email, password, and username (with role)
  Future<User?> createUserWithEmailAndPassword(
      String username, String email, String password,
      {String role = 'student'}) async {
    try {
      // Create the authentication user
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      if (userCredential.user != null) {
        // Determine the subcollection
        final subcollection = role == 'counsellor' ? 'counsellors' : 'students';

        // Add the user document to the appropriate subcollection
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .collection(subcollection)
            .doc('profile')
            .set({
          'uid': userCredential.user!.uid,
          'username': username,
          'email': email,
          'role': role,
          'profileImageUrl': null,
          'createdAt': FieldValue.serverTimestamp(),
        });

        await _firestore.collection('usernames').doc(username).set({
          'uid': userCredential.user!.uid,
        });

        print("User document created successfully in $subcollection");
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

  // Sign in with Google and create/update user document with role
  Future<UserCredential?> loginWithGoogle(
      {String defaultRole = 'student'}) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print("Google Sign-In aborted by user.");
        return null;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final subcollection =
            defaultRole == 'counsellor' ? 'counsellors' : 'students';

        final userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .collection(subcollection)
            .doc('profile')
            .get();

        if (!userDoc.exists) {
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .collection(subcollection)
              .doc('profile')
              .set({
            'uid': userCredential.user!.uid,
            'username': userCredential.user!.displayName ??
                'User${userCredential.user!.uid.substring(0, 5)}',
            'email': userCredential.user!.email,
            'role': defaultRole,
            'profileImageUrl': userCredential.user!.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }

      return userCredential;
    } catch (e) {
      print("Error in Google Sign-In: $e");
      throw Exception('Google sign-in error: $e');
    }
  }

  // Get user role
  Future<String?> getUserRole() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final studentDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('students')
            .doc('profile')
            .get();

        if (studentDoc.exists) {
          return 'student';
        }

        final counsellorDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('counsellors')
            .doc('profile')
            .get();

        if (counsellorDoc.exists) {
          return 'counsellor';
        }
      }
    } catch (e) {
      throw Exception("Failed to get user role: $e");
    }
    return null;
  }

  // Login with email and password
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          throw Exception("Invalid email or password");
        case 'invalid-email':
          throw Exception("Please enter a valid email address");
        case 'user-disabled':
          throw Exception("This account has been disabled");
        default:
          throw Exception("Login failed. Please try again");
      }
    } catch (e) {
      throw Exception("Login failed. Please try again");
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
// Fetch current user's data from Firestore
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Fetch the main user document to determine the role
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          final userData = userDoc.data();
          final role = userData?['role']; // Determine the user's role

          // Fetch data from the appropriate subcollection
          final subcollection =
              role == 'counsellor' ? 'counsellors' : 'students';
          final profileDoc = await _firestore
              .collection('users')
              .doc(user.uid)
              .collection(subcollection)
              .doc('profile')
              .get();

          return profileDoc.exists ? profileDoc.data() : null;
        }
      }
      return null;
    } catch (e) {
      throw Exception("Failed to get user data: $e");
    }
  }
}
