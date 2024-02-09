import 'package:flutter/material.dart';
import 'package:tutorhub/login.dart';
import 'package:tutorhub/student.dart';
import 'package:tutorhub/tutor.dart';
import 'package:tutorhub/profile.dart';

class User {
  final String userType;
  final String name;

  User({required this.userType, required this.name});
}

class ProfileScreen extends StatelessWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile',style: TextStyle(color:Colors.white,fontFamily: 'Salsa'),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Name: ${user.name}'),
            Text('User Type: ${user.userType}'),
          ],
        ),
      ),
    );
  }
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserTypeSelectionScreen(),
    );
  }
}

class UserTypeSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select User Type',style: TextStyle(color:Colors.white,fontFamily: 'Salsa'),),
        backgroundColor: Color(0xff7F9A5B),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  "images/tutor.png",
                  height: 200,
                  width: 150,
                ),
                ElevatedButton(
                  onPressed: () {
                    _navigateToProfile(context, User(userType: 'Tutor', name: 'Tutor Name'));
                  },
                  child: Text(
                    'Tutor',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xff7F9A5B),
                      fontFamily: 'Salsa',
                      fontSize: 18,
                    ),
                  ),
                ),
                Image.asset(
                  "images/student.png",
                  height: 200,
                  width: 150,
                ),
                ElevatedButton(
                  onPressed: () {
                    _navigateToProfile(context, User(userType: 'Student', name: 'Student Name'));
                  },
                  child: Text(
                    'Student',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xff7F9A5B),
                      fontSize: 18,
                      fontFamily: 'Salsa',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToProfile(BuildContext context, User user) {
    if (user.userType == 'Tutor') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TutorForm(user: user)),
      );
    } else if (user.userType == 'Student') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StudentForm(user: user)),
      );
    }
  }
}

void main() {
  runApp(MyPage());
}


