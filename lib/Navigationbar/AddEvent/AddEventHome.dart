import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/Navigationbar/Home_Screen/tabwidght.dart';
import 'package:evently/Navigationbar/AddEvent/tabwidghtCreateEvent.dart';
import 'package:evently/Navigationbar/Navigationbar.dart';
import 'package:evently/assets/AppColors.dart';
import 'package:evently/assets/Fontspath.dart';
import 'package:evently/assets/ImagePath.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddEventHome extends StatefulWidget{
  static const String RouteName='AddEventHome';

  @override
  State<AddEventHome> createState() => _AddEventHomeState();
}

class _AddEventHomeState extends State<AddEventHome> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Get user's current location on startup
  }

  // Get current location to center the map
  _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _controller?.animateCamera(CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
  }

  // Save the selected location
  _saveLocation(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _markers.add(Marker(
        markerId: MarkerId('selected_location'),
        position: location,
        infoWindow: InfoWindow(title: 'Selected Location'),
      ));
    });
    print("Selected Location: ${location.latitude}, ${location.longitude}");
  }
   bool islove=false;
  String choosedate='';
  String chosenTime = '';
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _titleError = false;
  bool _descriptionError = false;
  bool eventdateerror=false;
  bool eventtimeerror=false;
  void _validateInput() async {
    setState(() {
      _titleError = _titleController.text.isEmpty;
      _descriptionError = _descriptionController.text.isEmpty;
      eventdateerror=choosedate.isEmpty;
      eventtimeerror=chosenTime.isEmpty;
    });

    if (!_titleError && !_descriptionError && !eventdateerror && !eventtimeerror) {
      try {
        // Attempt to upload data to Firestore
        await FirebaseFirestore.instance.collection('Event').add({
          'title': _titleController.text.trim(),
          'description': _descriptionController.text.trim(),
          'path':ListImage[selectindex],
          'eventname':eventsNameList[selectindex],
          'date':choosedate,
          'time':chosenTime,
          'latitude': _selectedLocation?.latitude,
          'timestamp': FieldValue.serverTimestamp(),
          'islove':islove
        }).then((DocumentReference doc) {
          // Successful upload
          Navigator.pushNamed(context, Navigationbar.RouteName);
        }).catchError((error) {
          // Error during upload
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create account: $error')),
          );
        });
      } catch (e) {
        // Handle unexpected exceptions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }

  }
  int selectindex=0;
  List<String> eventsNameList = [];
  List<String> ListImage = [];
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    eventsNameList=[
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
    ListImage=[
      ImagePath.sport,
      ImagePath.birthday,
      ImagePath.meeting,
      ImagePath.gaming,
      ImagePath.work_shop,
      ImagePath.book_club,
      ImagePath.exhibition,
      ImagePath.holiday,
      ImagePath.eating,
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.pushNamed(context, Navigationbar.RouteName);
            },
            icon: Icon(Icons.arrow_back,color: AppColors.primarycolor,)
        ),
        title: Text(AppLocalizations.of(context)!.create_account,style: Fontspath.w400Inter20(color:AppColors.primarycolor),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              height: height*0.3,
              decoration: BoxDecoration(
                  image: DecorationImage(image:AssetImage(ListImage[selectindex]),fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                      color: AppColors.primarycolor,
                      width: 3
                  )
              ),
            ),
            SizedBox(
              height: height*0.01,
            ),
              // DefaultTabController
              DefaultTabController(
        length: eventsNameList.length,
        child: TabBar(
          onTap: (index) {
            selectindex = index;
            setState(() {});
          },
          tabAlignment: TabAlignment.start,
          labelPadding: EdgeInsets.zero,
          indicatorColor: AppColors.transparent,
          dividerColor: AppColors.transparent,
          isScrollable: true,
          tabs: eventsNameList.map((eventsName) {
            return tabwidghtCreateEvent(
              isSelected: selectindex == eventsNameList.indexOf(eventsName),
              evenname: eventsName,
            );
          }).toList(),
        ),
              ),
              SizedBox(
              height: height*0.01,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(AppLocalizations.of(context)!.title,
                style: Fontspath.w500Inter16(color: AppColors.blackcolor),),
                  SizedBox(
                    height: height*0.01,
                  ),
                  TextField(
                    controller:_titleController,
                    decoration: InputDecoration(
                      errorText: _titleError ? 'Please enter a valid title' : null,
                      label:Row(
                        children: [
                          Image.asset(ImagePath.edit),
                          SizedBox(
                            width: width*0.015,
                          ),
                          Text(AppLocalizations.of(context)!.event_title)
                        ],
                      ),
                      labelStyle: TextStyle(color: AppColors.blackcolor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primarycolor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primarycolor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height*0.03,
                  ),
                  Text(AppLocalizations.of(context)!.description,style: Fontspath.w500Inter16(color: AppColors.blackcolor),),
                  SizedBox(
                    height: height*0.01,
                  ),
                  TextField(
                controller:_descriptionController,
                maxLines: 5, // Makes the TextField larger to accommodate multiple lines
                decoration: InputDecoration(
                  errorText: _descriptionError ? 'Please enter a valid description' : null,
                  labelText: AppLocalizations.of(context)!.event_description,
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(color: AppColors.blackcolor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primarycolor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primarycolor),
                  ),
                ),
              ),
                  SizedBox(
                    height: height*0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            ImagePath.calendar,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Text(
                            AppLocalizations.of(context)!.event_date,
                            style: Fontspath.w500Inter16(color: AppColors.blackcolor),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          // Show the date picker when tapped
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(), // Initial date
                            firstDate: DateTime(1900), // First selectable date
                            lastDate: DateTime(2101), // Last selectable date
                          );

                          if (pickedDate != null) {
                            // Update the chosen date with the selected date
                            setState(() {
                              choosedate = "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                            });
                          }
                        },
                        child: Text(
                          choosedate.isEmpty
                              ? AppLocalizations.of(context)!.choose_date // If no date chosen, show "choose date"
                              : choosedate, // Otherwise, show the chosen date
                          style: Fontspath.w500Inter16(color: AppColors.primarycolor),
                        ),
                      ),
                    ],
                  ),
    SizedBox(
                    height: height*0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            ImagePath.clock,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Text(
                            AppLocalizations.of(context)!.event_time,
                            style: Fontspath.w500Inter16(color: AppColors.blackcolor),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          // Show the time picker when tapped
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(), // Initial time (current time)
                          );

                          if (pickedTime != null) {
                            // Update the chosen time with the selected time
                            setState(() {
                              // Format the selected time to hh:mm AM/PM format
                              chosenTime = "${pickedTime.format(context)}";
                            });
                          }
                        },
                        child: Text(
                          chosenTime.isEmpty
                              ? AppLocalizations.of(context)!.choose_time // If no time chosen, show "choose time"
                              : chosenTime, // Otherwise, show the chosen time
                          style: Fontspath.w500Inter16(color: AppColors.primarycolor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height*0.02,
                  ),
                  Text(AppLocalizations.of(context)!.location,
                    style: Fontspath.w500Inter16(color: AppColors.blackcolor),),
                  SizedBox(
                    height: height*0.01,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: AppColors.whitecolor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: AppColors.primarycolor, width: 2),
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                   onPressed: (){},
                   /* onPressed: () async {
                      // Open Google Maps
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Pick a Location"),
                          content: Container(
                            height: 400,
                            width: 300,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(37.7749, -122.4194), // Default location (San Francisco)
                                zoom: 14,
                              ),
                              onMapCreated: (GoogleMapController controller) {
                                _controller = controller;
                              },
                              onTap: (LatLng location) {
                                _saveLocation(location); // Save location when user taps
                              },
                              markers: _markers,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: Text('Cancel'),
                            ),
                          ],
                        ),
                      );
                    },*/
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.primarycolor,
                                ),
                                child: Image.asset(ImagePath.location),
                              ),
                              Text(
                                _selectedLocation == null
                                    ? AppLocalizations.of(context)!.choose_event_location
                                    : "Location: ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}",
                                style: Fontspath.w500Inter14(color: AppColors.primarycolor),
                              ),
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, color: AppColors.primarycolor),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height*0.02,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor:AppColors.primarycolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13), // No rounded corners
                        ),
                      ),
                        onPressed: _validateInput,

                      child: Container(
                        padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          child: Text(AppLocalizations.of(context)!.add_event,
                            style: Fontspath.w500Inter20(color: AppColors.whitecolor),)
                      )
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
