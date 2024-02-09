import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tutorhub/enroll_page.dart';
import 'package:tutorhub/page2.dart';
//import 'dart:js' show JSObject;


class CoursePage extends StatefulWidget {
  final Map<String, dynamic> data;
  final int index;
  final User user;

  CoursePage({required this.data, required this.index,required this.user});

  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  late TextEditingController name;
  late TextEditingController subject;
  late TextEditingController date;
  late TextEditingController language;
  late TextEditingController board;
  late TextEditingController education;
  late TextEditingController experience;

  late String documentId = ''; // Initialize with  empty string

  bool isUpdating = false;

  void initState() {
    super.initState();
    name = TextEditingController(text: widget.data['name']);
    date = TextEditingController(text: widget.data['date']);
    subject = TextEditingController(text: widget.data['subject']);
    language= TextEditingController(text: widget.data['language']);
    board = TextEditingController(text: widget.data['board']);
    education =TextEditingController(text: widget.data['education']);
    experience =TextEditingController(text: widget.data['experience']);

    // Fetch and store the document ID
    documentId = widget.data['id'] ?? '';
  }

  Future<void> updateData() async {
    try {
      if (widget.user.userType == 'Tutor') {
        if (documentId.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('courses')
              .doc(documentId)
              .update({
            'name': name.text,
            'subject': subject.text,
            'date': date.text,
            'language': language.text,
            'board': board.text,
            'education':education.text,
            'experience':experience.text,
          });

          print("Data updated");
          setState(() {
            isUpdating = false;
          });
        } else {
          print("Document ID is empty");
        }
      } else {
        // Attendee cannot update data
        print(widget.user.userType);
        showErrorMessage("Only tutors can update data.");
      }
    } catch (e) {
      //print('$e');
      print('Error updating document: $e');
    }
  }

  // // New function to fetch document ID and data
  // Future<void> fetchData() async {
  //   try {
  //     DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
  //         .collection('courses')
  //         .doc(widget.data['id'])
  //         .get();
  //
  //     if (documentSnapshot.exists) {
  //       // Access document data
  //       Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
  //
  //       // Access document ID
  //       String fetchedDocumentId = documentSnapshot.id;
  //
  //       // Now you can use data and fetchedDocumentId as needed
  //       print('Fetched Document ID: $fetchedDocumentId, Fetched Data: $data');
  //     } else {
  //       print('Document does not exist');
  //     }
  //   } catch (e) {
  //     print('Error fetching data: $e');
  //   }
  // }

  Future<void> deleteData() async {
    try {
      print(widget.user.userType);
      if (widget.user.userType == 'Tutor') {
        if (documentId.isNotEmpty) {
          bool confirmDelete = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Confirm Deletion'),
                content: Text('Are you sure you want to delete this data?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Delete'),
                  ),
                ],
              );
            },
          );

          if (confirmDelete == true) {
            await FirebaseFirestore.instance
                .collection('courses')
                .doc(documentId)
                .delete();

            print('Document deleted successfully');
            Navigator.pop(context); // Go back to the previous screen
          }
        } else {
          print("Document ID is empty");
        }
      } else {
        // Attendee cannot delete data
        showErrorMessage("Only tutors can delete data.");
      }
    } catch (e) {
      print('Error deleting document: $e');
    }

  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Course Details",style: TextStyle(fontFamily: 'Salsa',color: Colors.white),),
        backgroundColor:  Color(0xff6A814B),
      ),
      body:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg2.jpg'), // Replace with your image asset path
            fit: BoxFit.cover,
          ),
        ),
      child:Center(
        //padding: EdgeInsets.all(130.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top:100,)
            ),
            userState("Name", name),
            userState("Start Date", date),
            userState("Subject", subject),
            userState("Language", language),
            userState("Board", board),
            userState("Academic Qualification",education),
            userState("Teaching Experience",experience),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    // Check if the user is an attendee
                    if (widget.user.userType == 'Student') {
                      // Allow student to book demo session
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegistrationPage(courseData: widget.data, user: widget.user)),
                      );
                    } else {
                      // Display an error message because only students can book session
                      showErrorMessage("Only students can book demo sessions.");
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xff7F9A5B),
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Book Demo Session", style: TextStyle(fontFamily: 'Salsa')),
                ),

                TextButton(
               onPressed: (){
                 if (widget.user.userType == 'Tutor'){
                   if (isUpdating) {
                     updateData();
                   } else {
                     setState(() {
                       isUpdating = true;
                     });
                   }
                 }else{
                   print(widget.user.userType);
                   updateData();
                 }
               },
               style: TextButton.styleFrom(
                  backgroundColor: Color(0xff7F9A5B), foregroundColor: Colors.white),
               child: Text("Update Course"),
               ),
               TextButton(
                onPressed: deleteData,
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xff7F9A5B), foregroundColor: Colors.white),
                child: Text("Delete Course",style:TextStyle(fontFamily: 'Salsa',)),
            ),
            ],
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget userState(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: isUpdating
          ? TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      )
          : Text(
        '$label: ${controller.text}',
        style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w600,fontFamily: 'Salsa', color: Color(0xff6A814B)),
      ),
    );
  }
}


