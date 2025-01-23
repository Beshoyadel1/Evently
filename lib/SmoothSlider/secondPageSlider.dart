import 'package:evently/assets/AppColors.dart';
import 'package:evently/assets/Fontspath.dart';
import 'package:evently/assets/ImagePath.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class secondPageSlider extends StatefulWidget {

  @override
  State<secondPageSlider> createState() => _TsecondPageSliderState();
}
class _TsecondPageSliderState extends State<secondPageSlider> {
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
        
            Image.asset(ImagePath.page3),
            Text('Connect with Friends & Share Moments',
              style: Fontspath.w700Inter20(color: AppColors.primarycolor),),
            SizedBox(height: height * 0.02,),
            Text('Make every event memorable by sharing the experience with others. Our platform lets you invite friends, keep everyone in the loop, and celebrate moments together. Capture and share the excitement with your network, so you can relive the highlights and cherish the memories.',
              style: Fontspath.w500Inter16(color: AppColors.blackcolor),),
        
          ],
        ),
      ),
    );
  }
}
