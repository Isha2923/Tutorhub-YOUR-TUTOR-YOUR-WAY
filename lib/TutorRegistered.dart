import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tutorhub/coursePage.dart';
import 'package:tutorhub/Myhomepage.dart';
import 'package:tutorhub/page2.dart';
//import 'dart:js' show JSObject;


class TutorCoursesPage extends StatefulWidget {
  final User user;

  TutorCoursesPage({required this.user});

  @override
  _TutorCoursesPageState createState() => _TutorCoursesPageState();
}

class _TutorCoursesPageState extends State<TutorCoursesPage> {
  late Future<List<Map<String, dynamic>>> tutorCourses;
  late Map<String, int> enrollmentCounts;


  @override
  void initState() {
    super.initState();
    tutorCourses = fetchTutorCourses();
    enrollmentCounts = {}; // Initialize an empty map
  }

  Future<List<Map<String, dynamic>>> fetchTutorCourses() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .where('tutor', isEqualTo: widget.user.name)
          .get();
      return querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
  Future<int> fetchEnrollmentCount(String courseName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('student enrollments')
          .where('courseName', isEqualTo: courseName)
          .get();
      return querySnapshot.size; // Num of registered students
    } catch (e) {
      print("Error fetching enrollment count: $e");
      return 0;
    }
  }
  Future<void> fetchEnrollmentCounts() async {
    for (var course in (await tutorCourses)) {
      String courseName = course['name'];
      int enrollmentCount = await fetchEnrollmentCount(courseName);
      setState(() {
        enrollmentCounts[courseName] = enrollmentCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Courses", style: TextStyle(fontFamily: 'Salsa', color: Colors.white)),
        backgroundColor: Color(0xff7F9A5B),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () {
            Navigator.pop(
                context);
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/bg2.jpg',
              fit: BoxFit.cover,
            ),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: tutorCourses,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("There is some error fetching the data"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No courses are available of the tutor"));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var course = snapshot.data![index];
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.all(8.0),
                      color: Color(0xffF5ECCD),
                      child: ListTile(
                        title: Text(
                          course['name'],
                          style: TextStyle(fontWeight: FontWeight.w400, color: Color(0xff3F4D2D)),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date: " + course['date']),
                            Text("Subject: " + course['subject']),
                            Text("Language: " + course['language']),
                            Text("Board: " + course['board']),
                          ],
                        ),
                        hoverColor: Color(0xffE8DBC5),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoursePage(
                              data: course,
                              index: index + 1,
                              user: widget.user,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
