import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/Navigationbar/Navigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> handleGoogleSignIn(BuildContext context) async {
  try {
    // Trigger the Google authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Get the signed-in user
      final User? user = userCredential.user;

      if (user != null) {
        // Reference to the Firestore 'users' collection
        final usersCollection = FirebaseFirestore.instance.collection('user');

        // Check if the user exists in Firestore
        final userDoc = await usersCollection.doc(user.uid).get();

        if (!userDoc.exists) {
          // If user does not exist, create a new user document
          await usersCollection.doc(user.uid).set({
            'name': user.displayName,
            'email': user.email,
            'photoURL': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-Up Successful! Welcome, ${user.displayName}!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-In Successful! Welcome back, ${user.displayName}!')),
          );
        }

        // Navigate to the next screen after the sign-in/signup
        Navigator.pushNamed(context, Navigationbar.RouteName);
      }
    }
  } catch (e) {
    // Handle errors
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
