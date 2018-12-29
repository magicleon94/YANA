import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:yana/Models/Note.dart';
import 'package:yana/NoteEditor.dart';


var newNoteHandler = Handler(handlerFunc: (BuildContext context, Map<String,dynamic> params){
  return NoteEditor(model: Note());
});

var editNoteHandler = Handler(handlerFunc: (BuildContext context, Map<String,dynamic> params){
  return NoteEditor(model: params["note"]);
});
