import 'package:evently/assets/AppColors.dart';
import 'package:evently/assets/Fontspath.dart';
import 'package:flutter/cupertino.dart';

class TabWidget extends StatelessWidget {
  final bool isSelected;
  final String evenname;

  TabWidget({required this.isSelected, required this.evenname});

  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(vertical: height*0.008,horizontal: width*0.05),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.whitecolor : AppColors.transparent,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppColors.whitecolor,
          width: 2,
        ),
      ),
      child: Text(
        evenname,
        style: isSelected
            ? Fontspath.w500Inter16(color: AppColors.primarycolor)
            : Fontspath.w500Inter16(color: AppColors.whitecolor),
      ),
    );
  }
}
