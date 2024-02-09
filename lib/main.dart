import 'package:tutorhub/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';



Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(

          //for android
          // apiKey: "AIzaSyBAqU_QPd2p3gOD5q1_pKiehbK30CcReek",
          // appId: "1:476636634080:android:e7fd45a336b997db84a985",
          // messagingSenderId: "476636634080",
          // projectId: "tutorhub-cf3f7"));

          //for web-
            //Import the functions you need from the SDKs you need
            // import { initializeApp } from "firebase/app";
            // TODO: Add SDKs for Firebase products that you want to use
            // https://firebase.google.com/docs/web/setup#available-libraries
            //Your web app's Firebase configuration
            //const firebaseConfig = {
            apiKey: "AIzaSyAX5RKB8EvycIilq2hlGZR0JxWOGfOv3P4",
            //"AIzaSyBAqU_QPd2p3gOD5q1_pKiehbK30CcReek",
            //"AIzaSyAX5RKB8EvycIilq2hlGZR0JxWOGfOv3P4",
            //authDomain: "tutorhub-cf3f7.firebaseapp.com",
            projectId: "tutorhub-cf3f7",
            //storageBucket: "tutorhub-cf3f7.appspot.com",
            messagingSenderId: "476636634080",
            appId: "1:476636634080:web:0873c1868a71a26184a985"));
  }

// Initialize Firebase
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tutor Hub",
      home: AnimatedSplashScreen(
        splash: Container(
          width: 400,
          height: 350,
          child:Image.asset('images/logo4.png',fit: BoxFit.contain,),
        ),
        nextScreen: SignUp(),
        splashTransition: SplashTransition.slideTransition,
        backgroundColor: Color(0xff7F9A5B),
        duration:2500,

      ),
      debugShowCheckedModeBanner: false,
    );
  }
}