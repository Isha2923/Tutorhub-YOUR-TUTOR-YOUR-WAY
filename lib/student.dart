import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorhub/Myhomepage.dart';
import 'package:tutorhub/page2.dart';
import 'package:flutter/material.dart';
import 'package:tutorhub/profile.dart';
//import 'dart:js' show JSObject;


void main() {
  User user = User(userType: 'Student', name: 'Your Student Name');
  runApp(MaterialApp(home: StudentForm(user: user)));
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

class StudentForm extends StatefulWidget {
  final User user;
  StudentForm({required this.user});
  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _standard = TextEditingController();
  final TextEditingController _board = TextEditingController();
  final TextEditingController _school = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Check for existing student profile data
    checkExistingProfile();
  }

  Future<void> checkExistingProfile() async {
    try {
      CollectionReference studentCollection =
      firestore.collection('student users');

      // Check if the student profile already exists
      QuerySnapshot existingProfiles = await studentCollection
          .where('name', isEqualTo: widget.user.name)
          .limit(1)
          .get();

      if (existingProfiles.docs.isNotEmpty) {
        print('Student profile already exists');

        var existingProfileData = existingProfiles.docs.first.data();

        // Check if the data is not null and is of type Map<String, dynamic>
        if (existingProfileData != null &&
            existingProfileData is Map<String, dynamic>) {
          setState(() {
            _name.text = existingProfileData['name'] ?? '';
            _standard.text = existingProfileData['standard'] ?? '';
            _board.text = existingProfileData['board'] ?? '';
            _school.text = existingProfileData['school'] ?? '';
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Student Form",
            style: TextStyle(
              fontFamily: 'Salsa',
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0xff7F9A5B),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/bg2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Name",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _name,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Standard",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _standard,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Board",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _board,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "School",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _school,
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: addUser,
                style: TextButton.styleFrom(
                    backgroundColor: Color(0xff7F9A5B), foregroundColor: Colors.white),
                child: const Text("Create Profile",style:TextStyle(fontSize:21, fontFamily: 'Salsa')),
              ),
            ],
          ),
        )
    );
  }

  void addUser() async {
    try {
      if (_name.text.isEmpty ||
          _board.text.isEmpty ||
          _standard.text.isEmpty ||
          _school.text.isEmpty) {
        print("Fill in all the details");
        return;
      }

      CollectionReference coursesCollection = firestore.collection('student users');

      QuerySnapshot existingProfiles = await coursesCollection
          .where('name', isEqualTo: _name.text)
          .limit(1)
          .get();

      if (existingProfiles.docs.isNotEmpty) {
        print('Student profile already exists');

        var existingProfileData = existingProfiles.docs.first.data();

        // Check if the data is not null and is of type Map<String, dynamic>
        if (existingProfileData != null &&
            existingProfileData is Map<String, dynamic>) {
          // Redirect to student profile screen with existing data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentProfileScreen(
                name: existingProfileData['name'] ?? '',
                standard: existingProfileData['standard'] ?? '',
                board: existingProfileData['board'] ?? '',
                school: existingProfileData['school'] ?? '',
              ),
            ),
          );
        }
        return;
      }

      // Add a new document with an automatically generated ID
      DocumentReference newCourseRef = await coursesCollection.add({
        'id': '', //Firestore will generate a unique ID
        'name': _name.text,
        'standard': _standard.text,
        'board': _board.text,
        'school': _school.text,
    });

      // Update the 'id' field with the document ID
      await newCourseRef.update({'id': newCourseRef.id});

      print('Student profile created');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudentProfileScreen(
            name: _name.text,
            standard: _standard.text,
            board: _board.text,
            school: _school.text,
          ),
        ),
      );
    } catch (e) {
      print(e);

    }
  }

}





