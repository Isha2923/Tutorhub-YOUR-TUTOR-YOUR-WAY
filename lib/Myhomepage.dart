import 'package:tutorhub/courselist.dart';
import 'package:tutorhub/addcourse.dart';
import 'package:flutter/material.dart';
import 'package:tutorhub/student.dart';
import 'package:tutorhub/page2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorhub/StudentEnrolled.dart';
import 'package:tutorhub/TutorRegistered.dart';
import 'package:tutorhub/Chatbot.dart';



void main() {
  User user = User(userType: 'user', name: 'Your user Name');
  runApp(MaterialApp(home: MyHomePage(user: user)));
}

class MyHomePage extends StatelessWidget {
  final User user;
  MyHomePage({required this.user});


  Future<int> fetchEnrollmentCount(String courseName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('student Enrollments')
          .where('courseName', isEqualTo: courseName)
          .get();
      return querySnapshot.size; // Number of enrolled students
    } catch (e) {
      print("Error fetching enrollment count: $e");
      return 0;
    }
  }
  Future<List<Map<String, dynamic>>> fetchTutorCourses() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .where('tutor', isEqualTo: user.name)
          .get();
      return querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  TextButton buildEnrollmentInfoButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        if (user.userType == 'Tutor') {
          // Get the tutor's courses
          List<Map<String, dynamic>> tutCourses = await fetchTutorCourses();

          if (tutCourses.isNotEmpty) {
            String courseName = tutCourses[0]['name']; // Assuming the first course
            int enrollmentCount = await fetchEnrollmentCount(courseName);

            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('Enrollment Info'),
                content: user.userType == 'Tutor'
                    ? Text(
                    "Congratulations! Your $courseName course has $enrollmentCount booked demo sessions.")
                    : Text(
                    "This particular course has $enrollmentCount booked demo sessions."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('Error'),
                content: Text('No sessions booked for your courses.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        }
      },
      style: user.userType == 'Student'
          ? ButtonStyle() // Empty ButtonStyle to hide the button
          : TextButton.styleFrom(
        backgroundColor: Color(0xff7F9A5B),
        foregroundColor: Colors.white,
      ),
      child: user.userType == 'Student'
          ? Container() // Empty container to hide the child text
          : const Text("Show Enrollment Info", style: TextStyle(fontFamily: 'Salsa')),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Tutor Hub", style: TextStyle(
          fontWeight: FontWeight.w200,
          fontFamily: 'Salsa',
          color: Colors.white,)
        ),
        backgroundColor:Color(0xff7F9A5B),
        shadowColor: Color(0xffb7d0a4),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
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
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 48,
              ),
              const Text(
                "tutorhub",
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Salsa',fontSize: 50, color: Color(0xff6A814B)),
              ),
              const Text(
                "Find your Tutor, Find Your Way!",
                style: TextStyle(fontWeight: FontWeight.w900,fontFamily: 'Salsa', fontSize: 18, color: Color(0xff6A814B)),
              ),
              const SizedBox(
                height: 20,
              ),
              CircleAvatar(
                backgroundImage: AssetImage('images/logo_new.png'),
                backgroundColor: Colors.transparent,
                radius: 55,
              ),
              const SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.elliptical(50,60)),
                child: Image.asset(
                  "images/theme2.jpg",
                  height: 220,
                  width: 300,
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildEnrollmentInfoButton(context),

                      if (user.userType == 'Tutor') // Show this button only if userType is 'Tutor'
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MyForm(user: user)));
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xff7F9A5B),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Add courses", style: TextStyle(fontFamily: 'Salsa')),

                        ),
                ],
              ),

              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CourseListPage(user: user)));
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Color(0xff7F9A5B), foregroundColor: Colors.white),
                    child: const Text("Find Tutor",style:TextStyle(fontFamily: 'Salsa',)),
                  ),
                  if (user.userType == 'Student')
                    TextButton(
                     onPressed: () {
                    // Allow only students to view booked sessions
                        Navigator.push(context,MaterialPageRoute(builder: (context) => StudentEnrolledCourses(
                                  user: user)),
                        );
                    },
                    style: TextButton.styleFrom(backgroundColor: Color(0xff7F9A5B),
                    foregroundColor: Colors.white),
                    child: const Text("View Booked Sessions",style: TextStyle(fontFamily: 'Salsa',)),
                    ),

                  if (user.userType == 'Tutor')
                    TextButton(
                      onPressed: () {
                        // Allow only tutors to view their courses
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => TutorCoursesPage(user: user)),);
                      },
                      style: TextButton.styleFrom(backgroundColor: Color(0xff7F9A5B),
                          foregroundColor: Colors.white),
                      child: const Text("View Their Courses",style: TextStyle(fontFamily: 'Salsa')),
                    ),

                  TextButton(
                      onPressed: () {
                        // Open email app to contact support
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatBotApp(user: user)),
                        );
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Color(0xff7F9A5B),
                          foregroundColor: Colors.white),
                      child: Row(
                        children: [
                          Icon(Icons.help,color: Colors.white,size:10,),
                          //SizedBox(height: 0.5), // Adjust the spacing between the icon and text
                          Text(
                            'Need Help',
                            style: TextStyle(color: Colors.white, fontFamily: 'Salsa'),
                          ),
                        ],
                      ),
                ),
            ],
          ),
          ],
        ),
      ),
      ),
    );
  }
}
