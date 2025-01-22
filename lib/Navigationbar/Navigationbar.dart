import 'package:evently/Navigationbar/AddEvent/AddEventHome.dart';
import 'package:evently/Navigationbar/Home_Screen/Home_Screen.dart';
import 'package:evently/Navigationbar/Love/LoveScreen.dart';
import 'package:evently/Navigationbar/map/mapscreen.dart';
import 'package:evently/Navigationbar/profile/Profile.dart';
import 'package:evently/assets/AppColors.dart';
import 'package:evently/assets/ImagePath.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Navigationbar extends StatefulWidget {
  static const String RouteName='Navigationbar';

  @override
  State<Navigationbar> createState() => _NavigationbarState();
}

class _NavigationbarState extends State<Navigationbar> {
  @override
  int selectindex=0;
  List<Widget>tabs=[Home_Screen(),Mapscreen(),Lovescreen(),Profile()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[selectindex],
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        shape: CircularNotchedRectangle(),
        notchMargin: 4,
        child: BottomNavigationBar(
          selectedItemColor:Colors.white,
          unselectedItemColor:Colors.white,
          backgroundColor: AppColors.primarycolor,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectindex,
          onTap: (index){
            selectindex=index;
            setState(() {
            });
          },
          items:[
            BottomNavigationBarItem(icon:selectindex==0 ?
            const ImageIcon(
                AssetImage(ImagePath.home_select))
                :
            const ImageIcon(
                AssetImage(ImagePath.home)),
                label: AppLocalizations.of(context)!.home,backgroundColor:Colors.white),
            BottomNavigationBarItem(icon:selectindex==1?
            const ImageIcon(
                AssetImage(ImagePath.map_select))
                :
            const ImageIcon(
                AssetImage(ImagePath.map)),
                label: AppLocalizations.of(context)!.map),
            BottomNavigationBarItem(icon: selectindex==2?
            const ImageIcon(
                AssetImage(ImagePath.love_select))
                :
            const ImageIcon(
                AssetImage(ImagePath.love)),
                label: AppLocalizations.of(context)!.love),
            BottomNavigationBarItem(icon: selectindex==3?
            const ImageIcon(
                AssetImage(ImagePath.profile_select))
                :
            const ImageIcon(
                AssetImage(ImagePath.profile)),
                label: AppLocalizations.of(context)!.profile),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            //AddEventHome
            Navigator.pushNamed(context, AddEventHome.RouteName);

          },
        backgroundColor: AppColors.primarycolor,
        shape: RoundedRectangleBorder(
        side:BorderSide(
          color: Colors.white,
          width: 6
        ) ,
        borderRadius:BorderRadius.circular(30)
        ),
        child: Icon(Icons.add,color: Colors.white,size:35,),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
