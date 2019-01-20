import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yana/AuthProvider.dart';
import 'package:yana/LoginScreen.dart';
import 'package:yana/NotesScreen.dart';
import 'package:yana/SplashScreen.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new SplashScreen();
        } else {
          if (snapshot.hasData) {
            return AuthProvider(child: NotesScreen(), user: snapshot.data);
          }
          return LoginScreen();
        }
      },
    );
  }
}
