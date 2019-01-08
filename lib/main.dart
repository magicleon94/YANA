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
        primaryColorDark: Color(0xFF388E3C),
        primaryColorLight: Color(0xFFC8E6C9),
        primaryColor: Color(0xFF4CAF50),
        accentColor: Color(0xFF8BC34A),
        dividerColor: Color(0xFFBDBDBD),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white)
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
