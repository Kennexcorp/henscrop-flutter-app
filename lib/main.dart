import 'package:flutter/material.dart';
import 'package:henscrop/pages/documents.dart';
import 'package:henscrop/pages/home.dart';
import 'package:henscrop/pages/landing.dart';
import 'package:henscrop/pages/login.dart';
import 'package:henscrop/pages/photos.dart';
import 'package:henscrop/pages/register.dart';
import 'package:henscrop/pages/videos.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Henscrop',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (BuildContext btx) => LandingPage(),
        '/login': (BuildContext btx) => LoginPage(),
        '/register': (BuildContext btx) => RegisterPage(),
        '/home': (BuildContext btx) => HomePage(),
        '/photos': (BuildContext btx) => PhotoPage(),
        '/documents': (BuildContext btx) => DocumentPage(),
        '/videos': (BuildContext btx) => VideoPage(),
      },
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
