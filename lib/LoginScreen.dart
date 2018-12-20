import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn(); 

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  void _authenticateWithGoogle() async {
    final GoogleSignInAccount googleUser = await widget.googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    await widget.firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Login"),
      ),
      body: new Center(
        child: new RaisedButton(
          onPressed: _authenticateWithGoogle,
          child: new Text("Login with Google"),
        ),
      ),
    );
  }
}