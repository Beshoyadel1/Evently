import 'package:evently/assets/AppColors.dart';
import 'package:evently/assets/Fontspath.dart';
import 'package:flutter/cupertino.dart';

class tabwidghtCreateEvent extends StatelessWidget {
  final bool isSelected;
  final String evenname;

  tabwidghtCreateEvent({required this.isSelected, required this.evenname});

  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(vertical: height*0.008,horizontal: width*0.05),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primarycolor : AppColors.whitecolor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppColors.primarycolor,
          width: 2,
        ),
      ),
      child: Text(
        evenname,
        style: isSelected
            ? Fontspath.w500Inter16(color: AppColors.whitecolor)
            : Fontspath.w500Inter16(color: AppColors.primarycolor),
      ),
    );
  }
}
