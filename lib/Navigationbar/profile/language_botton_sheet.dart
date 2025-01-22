import 'package:evently/assets/AppColors.dart';
import 'package:evently/assets/Fontspath.dart';
import 'package:evently/providers/language_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class language_botton_sheet extends StatefulWidget {

  @override
  State<language_botton_sheet> createState() => _language_botton_sheetState();
}

class _language_botton_sheetState extends State<language_botton_sheet> {
  @override
  Widget build(BuildContext context) {
      var provider=Provider.of<Applanguageprovider>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () {
              provider.chagelanguage('en');
            },
            child: provider.applanguage =='en'?
                getselected(AppLocalizations.of(context)!.english):
                ungetselected(AppLocalizations.of(context)!.english)
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              provider.chagelanguage('ar');
            },
            child:provider.applanguage =='ar'?
            getselected(AppLocalizations.of(context)!.arabic):
            ungetselected(AppLocalizations.of(context)!.arabic)
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
