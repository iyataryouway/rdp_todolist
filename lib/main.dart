//code submitted by: Iyanah Camille Taryouway

//import Dart packages to be used in main.dart file

import 'package:flutter/material.dart'; // for essential elements for building mobile app UI in Flutter
import 'package:firebase_core/firebase_core.dart'; //to connect to noSQL database called Firebase
import 'package:rdp_todolist/screens/home_page.dart';
import 'firebase_options.dart';

void main() async {
  //Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize Firebase with the current platform's default options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

//Read the home page state file, set the home page to be the initial screen
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
