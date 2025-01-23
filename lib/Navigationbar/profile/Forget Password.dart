import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:evently/Navigationbar/profile/login.dart';
import 'package:evently/assets/AppColors.dart';
import 'package:evently/assets/Fontspath.dart';
import 'package:evently/assets/ImagePath.dart';
import 'package:evently/providers/Theme_provider.dart';
import 'package:evently/providers/language_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class Forget_Password extends StatefulWidget {
  static const String RouteName = 'Forget_Password';

  @override
  State<Forget_Password> createState() => _Forget_PasswordState();
}

class _Forget_PasswordState extends State<Forget_Password> {
  TextEditingController emailController = TextEditingController();
  String errorMessage = '';

  // Function to handle email verification and reset password
  Future<void> resetPassword() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        errorMessage = 'Please enter your email address.';
      });
      return;
    }

    // Check if the email exists in Firestore
    final userRef = FirebaseFirestore.instance.collection('user');
    final querySnapshot = await userRef.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isEmpty) {
      setState(() {
        errorMessage = 'Email not found in our records.';
      });
    } else {
      // Send a password reset email using Firebase Authentication
      try {

        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('A password reset link has been sent to your email.')),
        );
        Navigator.pushNamed(context, login.RouteName);
      } catch (e) {
        setState(() {
          errorMessage = 'Failed to send reset email. Please try again later.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.forget_password,
          style: Fontspath.w400Inter20(color: AppColors.blackcolor),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(ImagePath.forget_password),
          SizedBox(height: 10),
          // Email input field
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Enter your email',
                errorText: errorMessage.isNotEmpty ? errorMessage : null,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primarycolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: resetPassword,
              child: Text(
                AppLocalizations.of(context)!.reset_password,
                style: Fontspath.w500Inter20(color: AppColors.whitecolor),
              ),
            ),
          ),
          // Show a text message when email is verified or not found
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}
