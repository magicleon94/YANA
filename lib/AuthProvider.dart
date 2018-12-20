import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends InheritedWidget {
  final Widget child;
  final FirebaseUser user;
  AuthProvider({Key key, @required this.child,this.user}) : super(key: key, child: child);

  static AuthProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AuthProvider) as AuthProvider);
  }

  @override
  bool updateShouldNotify( AuthProvider oldWidget) {
    return true;
  }
}