import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Verify if user has correct role
  Future<bool> verifyUserRole(String uid, String expectedRole) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (!userDoc.exists) return false;

      final subcollection =
          expectedRole == 'counsellor' ? 'counsellors' : 'students';
      final profileDoc = await _firestore
          .collection('users')
          .doc(uid)
          .collection(subcollection)
          .doc('profile')
          .get();

      return profileDoc.exists;
    } catch (e) {
      return false;
    }
  }

  // Create user with email, password, and username (with role)
  Future<User?> createUserWithEmailAndPassword(
      String username, String email, String password, String role) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      if (userCredential.user != null) {
        final subcollection = role == 'counsellor' ? 'counsellors' : 'students';

        // Create the main user document
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
        });

        // Add profile to the appropriate subcollection
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

  // Login with email and password
  Future<User?> loginWithEmailAndPassword(
      String email, String password, String expectedRole) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user != null) {
        // Verify user has the correct role
        final hasRole =
            await verifyUserRole(userCredential.user!.uid, expectedRole);
        if (!hasRole) {
          await _auth.signOut();
          throw Exception("This account does not have access to this portal.");
        }
        return userCredential.user;
      }
      return null;
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
      throw Exception(e.toString());
    }
  }

  // Google Sign In
  Future<UserCredential?> loginWithGoogle(String expectedRole) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Check if user exists with the correct role
        final hasRole =
            await verifyUserRole(userCredential.user!.uid, expectedRole);

        // If user doesn't exist or doesn't have the role, create new profile
        if (!hasRole) {
          final subcollection =
              expectedRole == 'counsellor' ? 'counsellors' : 'students';

          // Create main user document
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'email': userCredential.user!.email,
          });

          // Create profile in appropriate subcollection
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
            'role': expectedRole,
            'profileImageUrl': userCredential.user!.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
        return userCredential;
      }
      return null;
    } catch (e) {
      throw Exception('Authentication failed: $e');
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
        // First try to fetch from admin collection
        final adminDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('counsellors') // Add admin subcollection
            .doc('profile')
            .get();

        if (adminDoc.exists) {
          return adminDoc.data();
        }

        // If not admin, proceed with existing student/counsellor logic
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          final userData = userDoc.data();
          final role = userData?['role'];

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
