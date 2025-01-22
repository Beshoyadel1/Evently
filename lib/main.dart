import 'package:evently/Navigationbar/AddEvent/AddEventHome.dart';
import 'package:evently/Navigationbar/Home_Screen/Home_Screen.dart';
import 'package:evently/Navigationbar/profile/CreateAccount.dart';
import 'package:evently/Navigationbar/profile/Forget%20Password.dart';
import 'package:evently/Navigationbar/profile/Profile.dart';
import 'package:evently/Navigationbar/Navigationbar.dart';
import 'package:evently/assets/AppColors.dart';
import 'package:evently/firebase_options.dart';
import 'package:evently/providers/Theme_provider.dart';
import 'package:evently/providers/language_provider.dart';
import 'package:evently/SmoothSlider/SmoothSlider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'Navigationbar/Love/LoveScreen.dart';
import 'Navigationbar/map/mapscreen.dart';
import 'Navigationbar/profile/login.dart';
import 'SmoothSlider/thiredPageSlider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    await Firebase.initializeApp(); // Initialize Firebase
    debugPrint("Firebase initialized successfully.");
  } catch (e) {
    debugPrint("Error initializing Firebase: $e");
  }
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create:(context)=>Applanguageprovider()),
          ChangeNotifierProvider(create:(context)=>Appthemeprovider()),
        ],
          child: MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
   @override
  Widget build(BuildContext context) {
    var provider=Provider.of<Applanguageprovider>(context);
    var providertheme=Provider.of<Appthemeprovider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(provider.applanguage),
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white, // Light mode background
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.primarydark, // Dark mode background
      ),
      themeMode: providertheme.apptheme,
      initialRoute: SmoothSlider.RouteName,
      routes: {
        Home_Screen.RouteName:(context)=>Home_Screen(),
        Profile.RouteName:(context)=>Profile(),
        Navigationbar.RouteName:(context)=>Navigationbar(),
        login.RouteName:(context)=>login(),
        CreateAccount.RouteName:(context)=>CreateAccount(),
        Forget_Password.RouteName:(context)=>Forget_Password(),
        SmoothSlider.RouteName:(context)=>SmoothSlider(),
        AddEventHome.RouteName:(context)=>AddEventHome(),
        Lovescreen.RouteName:(context)=>Lovescreen(),
        Mapscreen.RouteName:(context)=>Mapscreen()
      },
    );
  }
}
