import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/Navigationbar/Home_Screen/EditDeleteEventPage.dart';
import 'package:evently/Navigationbar/Home_Screen/eventItemWidght.dart';
import 'package:evently/Navigationbar/Home_Screen/tabwidght.dart';
import 'package:evently/assets/AppColors.dart';
import 'package:evently/assets/Fontspath.dart';
import 'package:evently/assets/ImagePath.dart';
import 'package:evently/providers/Theme_provider.dart';
import 'package:evently/providers/language_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class Home_Screen extends StatefulWidget {
  static const String RouteName = 'Home_Screen';

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  int selectindex = 0;

  @override
  Widget build(BuildContext context) {
    var providerLanguage = Provider.of<Applanguageprovider>(context);
    var providerTheme = Provider.of<Appthemeprovider>(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user?.uid ?? '';

    List<String> eventsNameList = [
      AppLocalizations.of(context)!.all,
      AppLocalizations.of(context)!.sport,
      AppLocalizations.of(context)!.birthday,
      AppLocalizations.of(context)!.meeting,
      AppLocalizations.of(context)!.gaming,
      AppLocalizations.of(context)!.workshop,
      AppLocalizations.of(context)!.bookClub,
      AppLocalizations.of(context)!.exhibition,
      AppLocalizations.of(context)!.holiday,
      AppLocalizations.of(context)!.eating,
    ];

    return Scaffold(
      body: Column(
        children: [
          _buildHeaderSection(context, providerLanguage, providerTheme, width, height, userId, eventsNameList),
          Expanded(
            child: StreamBuilder(
              stream: _getFilteredStream(eventsNameList[selectindex]),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No events found.'));
                }

                final events = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditDeleteEventPage(
                              eventId: event.id,
                              initialDescription: event['description'],
                              initialDate: event['time'],
                              initialPathImage: event['path'],
                              initialEventName: event['eventname'],
                            ),
                          ),
                        );
                      },
                      child: eventItemWidght(
                        description: event['description'],
                        date: event['time'],
                        islove: event['islove'] as bool,
                        pathImage: event['path'],
                        eventId: event.id,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(
      BuildContext context,
      Applanguageprovider providerLanguage,
      Appthemeprovider providerTheme,
      double width,
      double height,
      String userId,
      List<String> eventsNameList,
      ) {
    return Container(
      padding: EdgeInsets.only(
          left: width * 0.03, right: width * 0.03, top: width * 0.09),
      height: height * 0.33,
      decoration: BoxDecoration(
        color: AppColors.primarycolor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(45),
          bottomRight: Radius.circular(45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.welcome_back,
            style: Fontspath.w400Inter14(color: AppColors.whitecolor),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildUserName(userId),
              Row(
                children: [
                  providerTheme.apptheme == ThemeMode.light
                      ? Image.asset(ImagePath.sun)
                      : Image.asset(ImagePath.moon, color: AppColors.whitecolor),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.whitecolor),
                    child: providerLanguage.applanguage == 'en'
                        ? Text(
                      'EN',
                      style: Fontspath.w700Inter14(
                          color: AppColors.primarycolor),
                    )
                        : Text(
                      'AR',
                      style: Fontspath.w700Inter14(
                          color: AppColors.primarycolor),
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Image.asset(ImagePath.map),
              Text('${AppLocalizations.of(context)!.cairo} , ',
                  style: Fontspath.w500Inter14(color: AppColors.whitecolor)),
              Text('${AppLocalizations.of(context)!.egypt}',
                  style: Fontspath.w500Inter14(color: AppColors.whitecolor))
            ],
          ),
          SizedBox(height: 20),
          DefaultTabController(
            length: eventsNameList.length,
            child: TabBar(
              tabAlignment: TabAlignment.start,
              labelPadding: EdgeInsets.zero,
              indicatorColor: AppColors.transparent,
              dividerColor: AppColors.transparent,
              isScrollable: true,
              onTap: (index) {
                setState(() {
                  selectindex = index;
                });
              },
              tabs: eventsNameList.map((eventName) {
                return TabWidget(
                  isSelected: selectindex == eventsNameList.indexOf(eventName),
                  evenname: eventName,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserName(String userId) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('user').doc(userId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('No data available'));
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;
        String userName = userData['name'] ?? 'Unknown';

        return Text(
          userName,
          style: Fontspath.w700Inter24(color: AppColors.whitecolor),
        );
      },
    );
  }

  Stream<QuerySnapshot> _getFilteredStream(String selectedEvent) {
    final eventCollection = FirebaseFirestore.instance.collection('Event');

    if (selectedEvent == AppLocalizations.of(context)!.all) {
      return eventCollection.snapshots();
    } else {
      return eventCollection.where('eventname', isEqualTo: selectedEvent).snapshots();
    }
  }
}
