import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/assets/AppColors.dart';
import 'package:evently/assets/Fontspath.dart';
import 'package:evently/assets/ImagePath.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditDeleteEventPage extends StatefulWidget {
  final String eventId;
  final String initialDescription;
  final String initialDate;
  final String initialPathImage;
  final String initialEventName;

  EditDeleteEventPage({
    required this.eventId,
    required this.initialDescription,
    required this.initialDate,
    required this.initialPathImage,
    required this.initialEventName,
  });

  @override
  _EditDeleteEventPageState createState() => _EditDeleteEventPageState();
}

class _EditDeleteEventPageState extends State<EditDeleteEventPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late String _selectedImage;
  late String _selectedEventName;

  final List<String> _listImage = [
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
  List<String> eventsNameList = [];
  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _dateController = TextEditingController(text: widget.initialDate);
    _selectedImage = widget.initialPathImage;
    _selectedEventName=widget.initialEventName;// Initialize with the current image
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _updateEvent() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('Event').doc(widget.eventId).update({
          'description': _descriptionController.text,
          'time': _dateController.text,
          'path': _selectedImage,
          'eventname':_selectedEventName
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Event updated successfully!')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating event: $e')));
      }
    }
  }

  Future<void> _deleteEvent() async {
    try {
      await FirebaseFirestore.instance.collection('Event').doc(widget.eventId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Event deleted successfully!')));
      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting event: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
     eventsNameList = [
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
      appBar: AppBar(
        title: Text('Edit or Delete Event', style: Fontspath.w700Inter20(color: AppColors.whitecolor)),
        backgroundColor: AppColors.primarycolor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Select an Event Name:',
                  style: Fontspath.w700Inter16(color: AppColors.blackcolor),
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedEventName,
                  items: eventsNameList.map((nameEvent) {
                    return DropdownMenuItem<String>(
                      value: nameEvent,
                      child: Row(
                        children: [
                          Text(nameEvent.split('/').last), // Display file name
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedEventName = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Select an Image:',
                  style: Fontspath.w700Inter16(color: AppColors.blackcolor),
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedImage,
                  items: _listImage.map((imagePath) {
                    return DropdownMenuItem<String>(
                      value: imagePath,
                      child: Row(
                        children: [
                          Image.asset(imagePath, height: 40, width: 40, fit: BoxFit.cover),
                          SizedBox(width: 10),
                          Text(imagePath.split('/').last), // Display file name
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedImage = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Image.asset(_selectedImage, fit: BoxFit.cover),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _updateEvent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primarycolor,
                        
                      ),
                      child: Text('Update Event',style:Fontspath.w500Inter14(color: AppColors.whitecolor) ,),
                    ),
                    ElevatedButton(
                      onPressed: _deleteEvent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text('Delete Event',style:Fontspath.w500Inter14(color: AppColors.whitecolor)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
