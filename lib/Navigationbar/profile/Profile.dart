import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/Navigationbar/profile/language_botton_sheet.dart';
import 'package:evently/Navigationbar/profile/login.dart';
import 'package:evently/Navigationbar/profile/theme_botton_sheet.dart';
import 'package:evently/assets/AppColors.dart';
import 'package:evently/assets/Fontspath.dart';
import 'package:evently/assets/ImagePath.dart';
import 'package:evently/providers/Theme_provider.dart';
import 'package:evently/providers/language_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
class Profile extends StatefulWidget {
  static const String RouteName='Profile';

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user?.uid ?? '';
    var provider=Provider.of<Applanguageprovider>(context);
    var providertheme=Provider.of<Appthemeprovider>(context);
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: height * 0.3,
                decoration: BoxDecoration(
                  color: AppColors.primarycolor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(75),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03,
                    vertical: height * 0.05,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            ImagePath.route,
                            height: height*0.15,
                          ),

                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('user') // Assuming collection is 'users'
                                .doc(userId) // Using the current user's UID to get their document
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator()); // Show loading indicator
                              }

                              if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              }

                              if (!snapshot.hasData || !snapshot.data!.exists) {
                                return Center(child: Text('No data available'));
                              }

                              // Accessing the user's data
                              var userData = snapshot.data!.data() as Map<String, dynamic>;
                              String userName = userData['name'] ?? 'Unknown';
                              String email = userData['email'] ?? 'Unknown';// Replace 'name' with the field you want to display

                              // Display the user's data
                              return Column(
                                children: [
                                  Text(
                                    userName,
                                    style: Fontspath.w700Inter12(color: Colors.white),
                                  ),
                                  Text(
                                    email,
                                    style: Fontspath.w700Inter12(color: Colors.white),
                                  ),
                                ],
                              );
                            },
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.language,
                      style: Fontspath.w700Inter20(color: AppColors.blackcolor),
                    ),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        showLanguagebottomsheet();
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primarycolor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              provider.applanguage == 'ar'
                                  ? AppLocalizations.of(context)!.arabic
                                  : AppLocalizations.of(context)!.english,
                              style: Fontspath.w700Inter20(
                                  color: AppColors.primarycolor),
                            ),
                            Icon(
                              Icons.arrow_drop_down_sharp,
                              color: AppColors.primarycolor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.theme,
                      style: Fontspath.w700Inter20(color: AppColors.blackcolor),
                    ),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        showThemebottomsheet();
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primarycolor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              providertheme.apptheme == ThemeMode.light
                                  ? AppLocalizations.of(context)!.light
                                  : AppLocalizations.of(context)!.dark,
                              style: Fontspath.w700Inter20(
                                  color: AppColors.primarycolor),
                            ),
                            Icon(
                              Icons.arrow_drop_down_sharp,
                              color: AppColors.primarycolor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, login.RouteName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context)!.logout,
                      style: Fontspath.w400Inter20(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showLanguagebottomsheet() {
    showModalBottomSheet(
        context: context,
        builder: (context)=>language_botton_sheet()
    );
  }
  void showThemebottomsheet() {
    showModalBottomSheet(
        context: context,
        builder: (context)=>theme_botton_sheet()
    );
  }
}
