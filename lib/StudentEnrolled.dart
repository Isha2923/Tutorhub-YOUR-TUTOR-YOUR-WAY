import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorhub/page2.dart';
//import 'dart:js' show JSObject;


class StudentEnrolledCourses extends StatefulWidget {
  final User user;

  StudentEnrolledCourses({required this.user});

  @override
  _StudentEnrolledCoursesState createState() =>
      _StudentEnrolledCoursesState();
}

class _StudentEnrolledCoursesState extends State<StudentEnrolledCourses> {
  late Future<List<Map<String, dynamic>>> enrolledCourses;

  @override
  void initState() {
    super.initState();
    enrolledCourses = fetchEnrolledCourses();
  }

  Future<List<Map<String, dynamic>>> fetchEnrolledCourses() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('student Enrollments')
          .where('studentName', isEqualTo: widget.user.name)
          .get();
      return querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Demo Sessions",
            style: TextStyle(fontFamily: 'Salsa', color: Colors.white)),
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
        child: Center(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'images/bg2.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: enrolledCourses,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text("There is some error fetching the data"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("You have not booked any demo sessions"));
                  } else {
                    print(snapshot.data!);
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var registration = snapshot.data![index];
                        return Card(
                          elevation: 5,
                          margin: EdgeInsets.all(8.0),
                          color: Color(0xffF5ECCD),
                          child: ListTile(
                            title: Text(
                              "Course: ${registration['courseName']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff3F4D2D)),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Standard: ${registration['standard']}"),
                                Text("Board: ${registration['board']}"),
                                Text("Location: ${registration['location']}"),

                              ],
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
        ),
      ),
    );
  }
}
