import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/Navigationbar/Home_Screen/eventItemWidght.dart';
import 'package:evently/assets/AppColors.dart';
import 'package:evently/assets/ImagePath.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Lovescreen extends StatefulWidget {
  static const String RouteName = 'Lovescreen';

  @override
  State<Lovescreen> createState() => _LovescreenState();
}

class _LovescreenState extends State<Lovescreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          // Container with red border for TextField
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'search for Event',
                labelStyle: TextStyle(color:AppColors.primarycolor),
                prefixIcon: Icon(Icons.search,color:AppColors.primarycolor,),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: AppColors.primarycolor), // Red border when not focused
                ),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Event')
                  .where('islove', isEqualTo: true)
                  .snapshots(), // Get only events with 'islove' = true
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No loved events found.'));
                }

                final events = snapshot.data!.docs.where((event) {
                  // Filter the events based on the search query
                  return event['description']
                      .toString()
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return eventItemWidght(
                      eventId: event.id,
                      description: event['description'],
                      date: event['time'],
                      islove: event['islove'] as bool,
                      pathImage: ImagePath.book_club, // Replace with your image logic
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
}
