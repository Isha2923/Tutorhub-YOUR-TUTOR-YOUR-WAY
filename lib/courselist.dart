import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tutorhub/coursePage.dart';
import 'package:tutorhub/page2.dart';
//import 'dart:js' show JSObject;


class CourseListPage extends StatefulWidget {
  final User user;

  CourseListPage({required this.user});
  @override
  _CourseListPageState createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  late Future<List<Map<String, dynamic>>> courses;

  @override
  void initState() {
    super.initState();
    courses = fetchCourses();
  }

  // fetches data from the firestore
  Future<List<Map<String, dynamic>>> fetchCourses() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('courses')
      //.where('tutor', isEqualTo: 'Lean In')
          .get();
      return querySnapshot.docs.map((doc) {
        // converting entire document data into a map and finally returning a list of all the maps
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
        title: Text("Course List",style: TextStyle(fontFamily: 'Salsa',color: Colors.white),),
        backgroundColor:  Color(0xff7F9A5B),
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
            future: courses,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("There is some error fetching the data"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No courses are available"));
              } else {
                print(snapshot.data!);
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var course = snapshot.data![index];
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.all(8.0),
                      color: Color(0xffFFF0D6),
                      child: ListTile(
                        title: Text(
                          (course['name'] ?? '') + ' by ' + (course['tutor'] ?? ''),
                          style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xff3F4D2D),fontFamily: 'Salsa'),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Start Date: " + course['date'],style: TextStyle(fontWeight: FontWeight.w500,fontFamily: 'Salsa',color: Color(
                                0xff6a8850))),
                            Text("Subject: " + course['subject'],style: TextStyle(fontWeight: FontWeight.w500,fontFamily: 'Salsa',color: Color(
                                0xff6a8850))),
                            Text("Language Spoken: " + course['language'],style: TextStyle(fontWeight: FontWeight.w500,fontFamily: 'Salsa',color: Color(
                                0xff6a8850))),
                            Text("Board: " + course['board'],style: TextStyle(fontWeight: FontWeight.w500,fontFamily: 'Salsa',color: Color(
                                0xff6a8850))),
                          ],
                        ),
                        hoverColor: Color(0xffded4bb),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoursePage(
                              data: course,
                              index: index + 1,
                                user: widget.user
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


