import 'package:tutorhub/Myhomepage.dart';
import 'package:flutter/material.dart';
import 'package:tutorhub/page2.dart' as page2;
//import 'dart:js' show JSObject;


class StudentProfileScreen extends StatelessWidget {
  final String name;
  final String standard;
  final String board;
  final String school;


  StudentProfileScreen({
    required this.name,
    required this.standard,
    required this.board,
    required this.school,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Profile', style: TextStyle(fontFamily: 'Salsa',color: Colors.white),),
        backgroundColor: Color(0xff7F9A5B),
        automaticallyImplyLeading: false,

      ),
      body: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage('images/bg2.jpg'),
        fit: BoxFit.cover,
        ),
        ),
      child:Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                top: 100,
                right: 20,
              ),
            ),
            // Profile Image
            Container(
              width: 150,
              height: 200,
              child :CircleAvatar(
                backgroundImage: AssetImage('images/studprofile.jpg'),
                backgroundColor: Colors.transparent,
                radius: 70,
              ),
            ),
            SizedBox(height: 20),
            // Profile Information
            Text('Name: $name',style: TextStyle(fontSize: 18, color: Color(0xff6A814B), fontFamily: 'Salsa',fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 20,
            ),
            Text('Standard: $standard',style: TextStyle(fontSize: 18, color: Color(0xff6A814B),fontFamily: 'Salsa',
                letterSpacing: 0.5, fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 20,
            ),
            Text('Board: $board',style: TextStyle(fontSize: 18,color:Color(0xff6A814B), fontFamily: 'Salsa',fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 20,
            ),
            Text('School: $school',style: TextStyle(fontSize: 18, color: Color(0xff6A814B), fontFamily: 'Salsa',fontWeight: FontWeight.w600)),
            // Add other profile information based on user type
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(user: page2.User(userType: 'Student', name: name)),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xff6A814B),
                foregroundColor: Colors.white,
              ),
              child: const Text("Go to Home", style: TextStyle(fontFamily: 'Salsa')),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class TutorProfileScreen extends StatelessWidget {
  final String name;
  final String contact;
  final String education;
  final String experience;
  final String location;
  final String language;

  TutorProfileScreen({
    required this.name,
    required this.contact,
    required this.education,
    required this.experience,
    required this.location,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor Profile', style: TextStyle(fontFamily: 'Salsa', color: Colors.white),),
        backgroundColor:Color(0xff7F9A5B),
        automaticallyImplyLeading: false,
      ),
      body: Container(
      decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('images/bg2.jpg'),
        fit: BoxFit.cover,
      ),
      ),
      child:Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 40,
                top: 100,
                right: 40,
              ),
            ),

            // Profile Image
            Container(
               width: 170,
               height: 150,
              child: CircleAvatar(
                backgroundImage: AssetImage('images/tutprofile.png'),
                backgroundColor: Colors.transparent, // Set a transparent background to make it a circle
                radius: 50,
              ),
            ),
            const SizedBox(height:10),
            // Profile Info
            Text('Name: $name',style: TextStyle(fontSize: 18, color: Color(0xff6A814B),fontFamily: 'Salsa', fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 10,
            ),
            Text('Contact No.: $contact',style: TextStyle(fontSize: 18, color: Color(0xff6A814B),fontFamily: 'Salsa', fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 10,
            ),
            Text('Academic Qualification: $education',style: TextStyle(fontSize: 18, color: Color(0xff6A814B),fontFamily: 'Salsa', fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 10,
            ),
            Text('Teaching Experience: $experience',style: TextStyle(fontSize: 18, color: Color(0xff6A814B),fontFamily: 'Salsa', fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 10,
            ),
            Text('Course Expertise: $location',style: TextStyle(fontSize: 18, color: Color(0xff6A814B),fontFamily: 'Salsa', fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 10,
            ),
            Text('Contact No.: $language',style: TextStyle(fontSize: 18, color: Color(0xff6A814B),fontFamily: 'Salsa', fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 25,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(user: page2.User(userType: 'Tutor', name: name)),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xff7F9A5B),
                foregroundColor: Colors.white,
              ),
              child: const Text("Go to Home", style: TextStyle(fontFamily: 'Salsa', fontSize: 18)),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

