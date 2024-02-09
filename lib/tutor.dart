import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorhub/Myhomepage.dart';
import 'package:tutorhub/page2.dart';
import 'package:flutter/material.dart';
import 'package:tutorhub/profile.dart';
//import 'dart:js' show JSObject;


void main() {
  User user = User(userType: 'Tutor', name: 'Your Tutor Name');
  runApp(MaterialApp(home: TutorForm(user: user)));
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

class TutorForm extends StatefulWidget {
  final User user;

  TutorForm({required this.user});
  @override
  _TutorFormState createState() => _TutorFormState();
}

class _TutorFormState extends State<TutorForm> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _contact = TextEditingController();
  final TextEditingController _education = TextEditingController();
  final TextEditingController _experience = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _language = TextEditingController();


  @override
  void initState() {
    super.initState();

    // Check for existing tutor profile data
    checkExistingProfile();
  }
  Future<void> checkExistingProfile() async {
    try {
      CollectionReference tutorCollection = firestore.collection('tutor users');

      // Check if the tutor profile already exists
      QuerySnapshot existingProfiles = await tutorCollection
          .where('name', isEqualTo: widget.user.name)
          .limit(1)
          .get();

      if (existingProfiles.docs.isNotEmpty) {
        print('Tutor profile already exists');

        // Get the existing tutor profile data
        var existingProfileData = existingProfiles.docs.first.data();

        // Check if the data is not null and is of type Map<String, dynamic>
        if (existingProfileData != null &&
            existingProfileData is Map<String, dynamic>) {
          setState(() {
            // Populate the text controllers with existing data
            _name.text = existingProfileData['name'] ?? '';
            _contact.text = existingProfileData['contact'] ?? '';
            _education.text = existingProfileData['education'] ?? '';
            _experience.text = existingProfileData['experience'] ?? '';
            _location.text = existingProfileData['location'] ?? '';
            _language.text = existingProfileData['language'] ?? '';
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
          title: Text("Tutor Details form",
            style: TextStyle(
              fontFamily: 'Salsa',
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0xff7F9A5B),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.white),
            onPressed: () {
              Navigator.pop(
                  context);
            },
          ),
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
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Contact No.",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _contact,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Academic Qualification",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _education,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Years of Experience",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _experience,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Location",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _location,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Language Spoken",
                  icon: Icon(Icons.label),
                  border: OutlineInputBorder(),
                ),
                controller: _language,
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
          _contact.text.isEmpty ||
          _education.text.isEmpty ||
          _experience.text.isEmpty ||
          _location.text.isEmpty ||
          _language.text.isEmpty) {
        print("Fill in all the details");
        return;
      }

      CollectionReference eventsCollection = firestore.collection('tutor users');

      // Check if the tutor profile already exists
      QuerySnapshot existingProfiles = await eventsCollection
          .where('name', isEqualTo: _name.text)
          .limit(1)
          .get();

      if (existingProfiles.docs.isNotEmpty) {
        print('Tutor profile already exists');

        // Get the existing tutor profile data
        var existingProfileData = existingProfiles.docs.first.data();

        // Check if the data is not null and is of type Map<String, dynamic>
        if (existingProfileData != null &&
            existingProfileData is Map<String, dynamic>) {
          // Redirect to the tutor profile screen with existing data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TutorProfileScreen(
                name: existingProfileData['name'] ?? '',
                contact: existingProfileData['contact'] ?? '',
                education: existingProfileData['education'] ?? '',
                experience: existingProfileData['experience'] ?? '',
                location:existingProfileData['location'] ?? '',
                language:existingProfileData['language'] ?? '',
              ),
            ),
          );
        }

        return;
      }

      // Add a new document with an automatically generated ID
      DocumentReference newEventRef = await eventsCollection.add({
        'id': '', // Leave it empty; Firestore will generate a unique ID
        'name': _name.text,
        'contact': _contact.text,
        'education': _education.text,
        'experience': _experience.text,
        'language': _language.text,
        'location': _location.text,
      });

      // Update the 'id' field with the document ID
      await newEventRef.update({'id': newEventRef.id});

      print('Tutor profile created');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TutorProfileScreen(
            name: _name.text,
            contact: _contact.text,
            education: _education.text,
            experience: _experience.text,
            language: _language.text,
            location: _location.text,
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

}





