import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:evently/Navigationbar/profile/Profile.dart';
import 'package:evently/Navigationbar/profile/login.dart';
import 'package:evently/assets/AppColors.dart';
import 'package:evently/assets/Fontspath.dart';
import 'package:evently/assets/ImagePath.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateAccount extends StatefulWidget {
  static const String RouteName = 'CreateAccount';

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _RepasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isRePasswordVisible = false;
  bool _nameError = false;
  bool _emailError = false;
  bool _passwordError = false;
  bool _RepasswordError = false;

  // Function to create a new account with Firebase Authentication
  Future<void> _createAccountWithEmailPassword() async {
    setState(() {
      _nameError = _nameController.text.isEmpty;
      _emailError = _emailController.text.isEmpty || !_emailController.text.contains('@gmail.com');
      _passwordError = _passwordController.text.isEmpty || (_passwordController.text != _RepasswordController.text);
      _RepasswordError = _RepasswordController.text.isEmpty || (_passwordController.text != _RepasswordController.text);
    });

    if (!_emailError && !_passwordError && !_nameError && !_RepasswordError) {
      try {
        // Create the user using Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // After creating the user, store the user info in Firestore
        User? user = userCredential.user;

        if (user != null) {
          // Add user data to Firestore
          await FirebaseFirestore.instance.collection('user').doc(user.uid).set({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'password':_passwordController.text.trim(),
            'created_at': DateTime.now(),
            'userId': user.uid, // Storing the user ID from Firebase Auth
          });

          // Successful account creation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account created successfully with User ID: ${user.uid}')),
          );
          Navigator.pushNamed(context, login.RouteName);
        }
      } on FirebaseAuthException catch (e) {
        // Handle authentication errors
        String errorMessage = 'An error occurred';
        if (e.code == 'weak-password') {
          errorMessage = 'The password is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The email is already in use.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Invalid email format.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        // Handle unexpected exceptions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(ImagePath.evently, height: height * 0.2),
            SizedBox(height: height * 0.05),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  errorText: _nameError ? 'Please enter a valid name' : null,
                  labelText: AppLocalizations.of(context)!.name,
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  errorText: _emailError ? 'Please enter a valid email' : null,
                  labelText: AppLocalizations.of(context)!.email,
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  errorText: _passwordError != _RepasswordError
                      ? 'Password and Repassword do not match'
                      : (_passwordError ? 'Please enter a valid password' : null),
                  labelText: AppLocalizations.of(context)!.password,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _RepasswordController,
                obscureText: !_isRePasswordVisible,
                decoration: InputDecoration(
                  errorText: _passwordError != _RepasswordError
                      ? 'Password and Repassword do not match'
                      : (_RepasswordError ? 'Please enter a valid Repassword' : null),
                  labelText: AppLocalizations.of(context)!.re_password,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isRePasswordVisible = !_isRePasswordVisible;
                      });
                    },
                    icon: Icon(_isRePasswordVisible ? Icons.visibility : Icons.visibility_off),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
            SizedBox(height: height * 0.01),
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
                onPressed: _createAccountWithEmailPassword,
                child: Text(
                  AppLocalizations.of(context)!.create_account,
                  style: Fontspath.w500Inter20(color: AppColors.whitecolor),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.already_have_account,
                  style: Fontspath.w500Inter16(color: AppColors.blackcolor),
                ),
                Text(
                  AppLocalizations.of(context)!.login,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    color: AppColors.primarycolor,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primarycolor,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: AppColors.primarycolor,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(ImagePath.usa),
                      SizedBox(width: 15),
                      Image.asset(ImagePath.egypt),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
