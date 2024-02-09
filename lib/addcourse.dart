import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorhub/Myhomepage.dart';
import 'package:tutorhub/page2.dart';
import 'package:flutter/material.dart';
import 'package:tutorhub/courselist.dart';
//import 'dart:js' show JSObject;


void main() {
  User user = User(userType: 'user', name: 'Your user Name');
  runApp(MaterialApp(home: MyForm(user:user)));
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

class MyForm extends StatefulWidget {
  final User user;

  MyForm({required this.user});
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _language = TextEditingController();
  final TextEditingController _board = TextEditingController();
  final TextEditingController _tutor = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Course",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Salsa',
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
        children: [
          Padding(padding: EdgeInsets.only(top:50)),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Course Name",
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
              labelText: "Tutor Name",
              icon: Icon(Icons.label),
              border: OutlineInputBorder(),
            ),
            controller: _tutor,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            onTap: () => _selectDate(context),
            readOnly: true,
            decoration: const InputDecoration(
              labelText: "Start Date",
              icon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(),
            ),
            controller: _selectedDate != null
                ? TextEditingController(text: _formatDate(_selectedDate!))
                : TextEditingController(),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Subject",
              icon: Icon(Icons.label),
              border: OutlineInputBorder(),
            ),
            controller: _subject,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Languages Spoken",
              icon: Icon(Icons.label),
              border: OutlineInputBorder(),
            ),
            controller: _language,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Board ",
              icon: Icon(Icons.work),
              border: OutlineInputBorder(),
            ),
            controller: _board,
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: addCourse,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff7F9A5B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: const Size(80, 40),
            ),
            child: const Text(
              "Add Course",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Salsa',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      )
    );
  }
  void addCourse() async {
    try {
      if (_name.text.isEmpty ||
          _selectedDate == null ||
          _tutor.text.isEmpty ||
          _subject.text.isEmpty ||
          _language.text.isEmpty ||
          _board.text.isEmpty) {
        print("Fill in all the details");
        return;
      }

      CollectionReference coursesCollection = firestore.collection('courses');

      // Add a new document with automatically generated ID
      DocumentReference newCourseRef = await coursesCollection.add({
        'id': '',  // Leave it empty; Firestore will generate a unique ID
        'name': _name.text,
        'tutor':_tutor.text,
        'date': _formatDate(_selectedDate!),
        'subject': _subject.text,
        'language': _language.text,
        'board': _board.text,
      });

      // Update the 'id' field with the document ID
      await newCourseRef.update({'id': newCourseRef.id});

      print('Course added');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CourseListPage(user: widget.user)),
      );
    } catch (e) {
      print(e);
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}





