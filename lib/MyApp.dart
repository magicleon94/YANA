import 'package:flutter/material.dart';
import 'package:yana/MainPage.dart';

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
        iconTheme: IconThemeData(color: Colors.white),
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black),
          body2: TextStyle(color: Colors.black),
          title: TextStyle(color: Colors.black),
          subtitle: TextStyle(color: Colors.black),
        )
      ),
      home: MainPage(),
    );
  }
}