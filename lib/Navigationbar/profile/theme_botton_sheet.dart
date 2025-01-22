import 'package:evently/assets/AppColors.dart';
import 'package:evently/assets/Fontspath.dart';
import 'package:evently/providers/Theme_provider.dart';
import 'package:evently/providers/language_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class theme_botton_sheet extends StatefulWidget {

  @override
  State<theme_botton_sheet> createState() => _theme_botton_sheetState();
}

class _theme_botton_sheetState extends State<theme_botton_sheet> {
  @override
  Widget build(BuildContext context) {
    var provider=Provider.of<Appthemeprovider>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () {
              provider.chagetheme(ThemeMode.light);
            },
            child: provider.apptheme ==ThemeMode.light?
                getselected(AppLocalizations.of(context)!.light):
                ungetselected(AppLocalizations.of(context)!.light)
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              provider.chagetheme(ThemeMode.dark);
            },
            child:provider.apptheme ==ThemeMode.dark?
            getselected(AppLocalizations.of(context)!.dark):
            ungetselected(AppLocalizations.of(context)!.dark)
            )
        ],
      ),
    );
  }

  Widget getselected(String txt){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(txt,style: Fontspath.w700Inter20(color: AppColors.primarycolor),),
        Icon(Icons.check,color: AppColors.primarycolor,)
      ],
    );
  }
  Widget ungetselected(String txt){
    return Text(txt,
        style: Fontspath.w700Inter20(color: AppColors.blackcolor));
  }
}
