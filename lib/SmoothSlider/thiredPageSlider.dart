import 'package:evently/Navigationbar/profile/login.dart';
import 'package:evently/assets/AppColors.dart';
import 'package:evently/assets/Fontspath.dart';
import 'package:evently/assets/ImagePath.dart';
import 'package:evently/providers/Theme_provider.dart';
import 'package:evently/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class thiredPageSlider extends StatefulWidget {
  static const String RouteName='thiredPageSlider';
  @override
  State<thiredPageSlider> createState() => _FirstPageSliderState();
}

class _FirstPageSliderState extends State<thiredPageSlider> {
  bool language = true;
  bool theme=true;

  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    var providerlanguage=Provider.of<Applanguageprovider>(context);
    var providertheme=Provider.of<Appthemeprovider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: height*0.05,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(ImagePath.rowEvently,width: width*0.5,)
              ],
            ),
        
            Image.asset(ImagePath.page1),
            Text('Personalize Your Experience',style:Fontspath.w700Inter20(color: AppColors.primarycolor),),
            SizedBox(height: height*0.02,),
            Text('Choose your preferred theme and language '
                'to get started with a comfortable, tailored experience that suits your style.',style:Fontspath.w500Inter16(color: AppColors.blackcolor),),
            SizedBox(height: height*0.05,),
        
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.language,style:Fontspath.w500Inter20(color: AppColors.primarycolor),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Switch(
                      value: language,
                      onChanged: (value) {
                        setState(() {
                          language = value; // Toggle the state
                        });
                        if(language==true){
                          providerlanguage.chagelanguage('en');
                        }
                        else{
                          providerlanguage.chagelanguage('ar');
                        }
                      },
                      activeThumbImage: providerlanguage.applanguage =='en'?
                      AssetImage(ImagePath.usa,)
                      :AssetImage(ImagePath.egypt,),
                      inactiveThumbImage: providerlanguage.applanguage =='ar'?
                      AssetImage(ImagePath.egypt,)
                          :AssetImage(ImagePath.usa,),
                      activeTrackColor:AppColors.primarycolor,
                      inactiveTrackColor:AppColors.primarydark ,
                    ),
                  ],
                )
        
              ],
            ),
        
            SizedBox(height: height*0.02,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.theme,style:Fontspath.w500Inter20(color: AppColors.primarycolor),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Switch(
                      value: theme,
                      onChanged: (value) {
                        setState(() {
                          theme = value; // Toggle the state
                        });
                        if(theme==true){
                          providertheme.chagetheme(ThemeMode.light);
                        }
                        else{
                          providertheme.chagetheme(ThemeMode.dark);
                        }
                      },
                      activeThumbImage: providertheme.apptheme ==ThemeMode.light?
                      AssetImage(ImagePath.sun,)
                          :AssetImage(ImagePath.moon,),
                      inactiveThumbImage:providertheme.apptheme ==ThemeMode.dark?
                      AssetImage(ImagePath.moon,)
                          :AssetImage(ImagePath.sun,),
                      activeTrackColor:AppColors.primarycolor,
                      inactiveTrackColor:AppColors.primarydark ,
                      activeColor: Colors.black,
                    ),
                  ],
                )
        
              ],
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
                  onPressed: (){
                    Navigator.pushNamed(context, login.RouteName);
                  },
                  child: Text('Let’s Start',style: Fontspath.w500Inter20(color: AppColors.whitecolor),)),
            ),
            SizedBox(height: height*0.05,),
          ],
        ),
      ),
    );
  }
}
