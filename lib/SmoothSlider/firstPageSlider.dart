import 'package:evently/assets/AppColors.dart';
import 'package:evently/assets/Fontspath.dart';
import 'package:evently/assets/ImagePath.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class firstPageSlider extends StatefulWidget {

  @override
  State<firstPageSlider> createState() => _firstPageSliderState();
}

class _firstPageSliderState extends State<firstPageSlider> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: height * 0.05,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(ImagePath.rowEvently, width: width * 0.5,)
              ],
            ),
        
            Image.asset(ImagePath.page2),
            Text('Effortless Event Planning',
              style: Fontspath.w700Inter20(color: AppColors.primarycolor),),
            SizedBox(height: height * 0.02,),
            Text('Take the hassle out of organizing events with our all-in-one planning tools. From setting up invites and managing RSVPs to scheduling reminders and coordinating details, we’ve got you covered. Plan with ease and focus on what matters – creating an unforgettable experience for you and your guests.',
              style: Fontspath.w500Inter16(color: AppColors.blackcolor),),
        
        
          ],
        ),
      ),
    );
  }
}
