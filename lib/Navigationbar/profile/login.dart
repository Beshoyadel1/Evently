import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/Navigationbar/Home_Screen/Home_Screen.dart';
import 'package:evently/Navigationbar/Navigationbar.dart';
import 'package:evently/Navigationbar/profile/CreateAccount.dart';
import 'package:evently/Navigationbar/profile/Forget%20Password.dart';
import 'package:evently/Navigationbar/profile/Profile.dart';
import 'package:evently/assets/AppColors.dart';
import 'package:evently/assets/Fontspath.dart';
import 'package:evently/assets/ImagePath.dart';
import 'package:evently/providers/language_provider.dart';
import 'package:evently/signUpWithGoogle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class login extends StatefulWidget {
  static const String RouteName='login';

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _emailError = false;
  bool _passwordError = false;
  void _validateInput() async {
    setState(() {
      _emailError = _emailController.text.isEmpty || !_emailController.text.contains('@gmail.com');
      _passwordError = _passwordController.text.isEmpty;
    });

    if (!_emailError && !_passwordError) {
      try {
        // Access the Firestore collection
        final users = FirebaseFirestore.instance.collection('user');
        final querySnapshot = await users
            .where('email', isEqualTo: _emailController.text)
            .where('password', isEqualTo: _passwordController.text)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Login successful
          _showMessage('Login Successful!');
          Navigator.pushNamed(context, Navigationbar.RouteName);
        } else {
          // Invalid credentials
          _showMessage('Invalid email or password. Please try again.');
        }
      } catch (e) {
        _showMessage('Error: $e');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    var providerlanguage=Provider.of<Applanguageprovider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(ImagePath.evently,height: height*0.3),
            SizedBox(
              height: height*0.05,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child:TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.username,
                  prefixIcon:Icon(Icons.email),
                  errorText: _emailError ? 'Please enter a valid email' : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                ),
              ),
            ),
        
            Container(
              padding: EdgeInsets.all(10),
              child:TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  errorText: _passwordError ? 'Please enter a password' : null,
                  labelText: AppLocalizations.of(context)!.password,
                  prefixIcon:Icon(Icons.lock),
                  suffixIcon: IconButton(onPressed: (){
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },icon:Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, Forget_Password.RouteName);
              },
              child: Text(
                AppLocalizations.of(context)!.forget_password,textAlign: TextAlign.right,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primarycolor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                  fontStyle: FontStyle.italic,
                  color: AppColors.primarycolor
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding:const EdgeInsets.all(10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:AppColors.primarycolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // No rounded corners
                    ),
                  ),
                  onPressed: _validateInput,
                  child: Text(AppLocalizations.of(context)!.login,style: Fontspath.w500Inter20(color: AppColors.whitecolor),)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.dont_have_account,style: Fontspath.w500Inter16(color: AppColors.blackcolor),),
                InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, CreateAccount.RouteName);
                  },
                  child: Text(AppLocalizations.of(context)!.create_account,style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                      color: AppColors.primarycolor,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primarycolor,
        
                  ),
                  ),
                ),
        
              ],
            ),
            SizedBox(height: height*0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width*0.3, // Set a specific width for the left line
                  child: Divider(
                    color: AppColors.primarycolor,
                    thickness: 2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8), // Adjust spacing
                  child: Text(
                    AppLocalizations.of(context)!.or,
                    style: TextStyle(
                      fontSize: 14,  // Smaller font size
                      color: AppColors.primarycolor,
                    ),
                  ),
                ),
                Container(
                  width: width*0.3, // Set a specific width for the right line
                  child: Divider(
                    color: AppColors.primarycolor,
                    thickness: 2,
                  ),
                ),
              ],
            ),
            SizedBox(height: height*0.01),
            Container(

              padding:const EdgeInsets.all(10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:AppColors.whitecolor,
                    side: BorderSide(
                      color: AppColors.primarycolor
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // No rounded corners
                    ),
                  ),
                  onPressed: () => handleGoogleSignIn(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(ImagePath.google),
                      SizedBox(width: 10,),
                      Text(AppLocalizations.of(context)!.login_with_google,style: Fontspath.w500Inter20(color: AppColors.primarycolor),),
                    ],
                  )),
        
            ),
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
                      InkWell(
                        onTap: (){
                          providerlanguage.chagelanguage('en');
                          setState(() {
        
                          });
                        },
                        child: Image.asset(
                          ImagePath.usa,
                        ),
                      ),
                      SizedBox(width: 15), // Adjust spacing between the flags
                      InkWell(
                        onTap: (){
                          providerlanguage.chagelanguage('ar');
                          setState(() {
        
                          });
                        },
                        child: Image.asset(
                          ImagePath.egypt,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
        
          ],
        ),
      ),
    );
  }
}
