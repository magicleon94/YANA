import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:yana/AuthProvider.dart';
import 'package:yana/NoteEditor.dart';


var newNoteHandler = Handler(handlerFunc: (BuildContext context, Map<String,dynamic> params){
  return AuthProvider(child: NoteEditor(), user: params["user"]);
});

var editNoteHandler = Handler(handlerFunc: (BuildContext context, Map<String,dynamic> params){
  return AuthProvider(child: NoteEditor(noteReference: params["noteReference"]), user: params["user"]);
});
