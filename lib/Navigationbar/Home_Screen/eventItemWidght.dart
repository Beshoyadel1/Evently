import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/Navigationbar/Love/LoveScreen.dart';
import 'package:evently/assets/AppColors.dart';
import 'package:evently/assets/Fontspath.dart';
import 'package:evently/assets/ImagePath.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class eventItemWidght extends StatefulWidget {
  final String pathImage;
  final String date;
  final String description;
  bool islove;
  final String eventId; // Add event ID to uniquely identify each event

  eventItemWidght({
    required this.pathImage,
    required this.date,
    required this.description,
    required this.islove,
    required this.eventId, // Initialize eventId
  });

  @override
  State<eventItemWidght> createState() => _eventItemWidghtState();
}

class _eventItemWidghtState extends State<eventItemWidght> {
  Future<void> _toggleLove() async {
    try {
      setState(() {
        widget.islove = !widget.islove; // Toggle UI state
      });

      // Update the specific event based on the eventId
      await FirebaseFirestore.instance
          .collection('Event')
          .doc(widget.eventId) // Get the event by its unique ID
          .update({'islove': widget.islove});

    } catch (e) {
      // Handle errors, optionally revert UI state
      setState(() {
        widget.islove = !widget.islove; // Revert UI state
      });
      print("Error updating islove: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: height * 0.26,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(widget.pathImage), fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(35),
          border: Border.all(
            color: AppColors.primarycolor,
            width: 3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.whitecolor,
              ),
              child: Column(
                children: [
                  Text(
                    widget.date,
                    style: Fontspath.w700Inter20(color: AppColors.primarycolor),
                  ),
                ],
              ),
            ),
            Container(
              height: height * 0.05,
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.whitecolor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.description,
                    style: Fontspath.w700Inter14(color: AppColors.blackcolor),
                  ),
                  InkWell(
                    onTap: _toggleLove,
                    child: Image.asset(
                      widget.islove ? ImagePath.love_select : ImagePath.love,
                      color: AppColors.primarycolor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
