import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorhub/page2.dart';
//import 'dart:js' show JSObject;


class RegistrationPage extends StatefulWidget {
  final Map<String, dynamic> courseData;
  final User user;

  RegistrationPage({required this.courseData, required this.user});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late TextEditingController nameController;
  late TextEditingController standardController;
  late TextEditingController boardController;
  late TextEditingController contactController;
  late TextEditingController locationController;
  late TextEditingController datetimeController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    standardController = TextEditingController();
    boardController = TextEditingController();
    contactController = TextEditingController();
    locationController = TextEditingController();
    datetimeController=TextEditingController();
  }

  void checkRegistration() async {
    // Check if the student has already enrolled for the course
    var registrationQuery = await FirebaseFirestore.instance
        .collection('student Enrollments')
        .where('courseName', isEqualTo: widget.courseData['name'])
        .where('studentName', isEqualTo: nameController.text)
        .get();

    if (registrationQuery.docs.isNotEmpty) {
      // Student has already enrolled
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Already Enrolled'),
          content: Text('You have already enrolled for this course.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Proceed with registration
      register();
    }
  }

  void register() async {
    try {
      if (nameController.text.isEmpty ||
          standardController.text.isEmpty ||
          boardController.text.isEmpty ||
          contactController.text.isEmpty ||
          datetimeController.text.isEmpty ||
          locationController.text.isEmpty) {
        print("Fill in all the details");
        return;
      }
      // Create a new document in the attendeeRegistrations collection
      await FirebaseFirestore.instance.collection('student Enrollments').add({
        'courseName': widget.courseData['name'],
        'studentName': nameController.text,
        'standard': standardController.text,
        'board': boardController.text,
        'contact': contactController.text,
        'location': locationController.text,
        'slot' :datetimeController.text,
      });

      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Session booked Successfully'),
          content: Text('Thanks for enrolling!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog

              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error during booking: $e');

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Offline Demo Session ", style: TextStyle(fontFamily: 'Salsa',color: Colors.white)),
        backgroundColor: Color(0xff7F9A5B),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child:Center(
                    child:Image.asset(
                    "images/demo.jpg",
                    height: 110,
                    width: 300,
                  ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Container(
                  height: 50,
                  child:TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                  controller: nameController,
                ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  child:TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Standard",
                    border: OutlineInputBorder(),
                  ),
                  controller: standardController,
                ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                   height: 50,
                    child:TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Board",
                    // icon: Icon(Icons.label),
                    border: OutlineInputBorder(),
                  ),
                  controller: boardController,
                ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  child:TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Preferred slot(date and time)",
                    border: OutlineInputBorder(),
                  ),
                  controller: datetimeController,
                ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  child: TextFormField(
                  decoration: const InputDecoration(
                  labelText: 'Contact No.',
                  border: OutlineInputBorder(),
                  ),
                  controller: contactController,
                ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  child:TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Location.',
                    border: OutlineInputBorder(),
                  ),
                  controller: locationController,
                ),
                ),
                SizedBox(height: 12.0),
                 ElevatedButton(
                  onPressed: checkRegistration,
                  //register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff7F9A5B),
                    //onPrimary: Colors.white,
                    foregroundColor: Colors.white, // Set the text color
                    minimumSize: const Size(30, 40),
                  ),
                  child: Text('Book Demo Session',style: TextStyle(fontFamily: 'Salsa',color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





