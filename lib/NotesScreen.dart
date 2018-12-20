import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yana/AuthProvider.dart';

class NotesScreen extends StatefulWidget {
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = AuthProvider.of(context).user;

    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Current user logged:${user.displayName}"),
        ),
      ),
    );
  }
}
