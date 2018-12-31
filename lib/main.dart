import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yana/SplashScreen.dart';
import 'package:yana/NotesScreen.dart';
import 'package:yana/LoginScreen.dart';
import 'package:yana/AuthProvider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yet Another Notes App',
      theme: ThemeData(
        primaryColorDark: Color(0xFFD32F2F),
        primaryColorLight: Color(0xFFFFCDD2),
        primaryColor: Color(0xFFF44336),
        accentColor: Color(0xFFFF5722),
        dividerColor: Color(0xFFBDBDBD),
      ),
      home: MainPage(),
    );
  }
}

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
