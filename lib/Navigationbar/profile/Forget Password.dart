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
  static const String RouteName='Forget_Password';


  @override
  State<Forget_Password> createState() => _Forget_PasswordState();
}

class _Forget_PasswordState extends State<Forget_Password> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.forget_password,
        style: Fontspath.w400Inter20(color:AppColors.blackcolor),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(ImagePath.forget_password),
          SizedBox(height: 10,),
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
                onPressed: (){
                  Navigator.pushNamed(context, login.RouteName);
                },
                child: Text(AppLocalizations.of(context)!.reset_password,style: Fontspath.w500Inter20(color: AppColors.whitecolor),)),
          ),
        ],
      ),
    );
  }
}
