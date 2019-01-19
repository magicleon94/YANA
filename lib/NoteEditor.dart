import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yana/AuthProvider.dart';
import 'package:yana/Models/Note.dart';
import 'package:yana/NoteEditForm.dart';
import 'package:yana/Utils.dart';

class NoteEditor extends StatefulWidget {
  const NoteEditor({Key key, this.noteReference}) : super(key: key);
  _NoteEditorState createState() => _NoteEditorState();
  final String noteReference;
  bool get isNewNote => StringUtils.isNullOrEmpty(noteReference);
}

class _NoteEditorState extends State<NoteEditor> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _textController = TextEditingController();

  Future<Null> saveNote() async {
    String title = _titleController.text;
    String text = _textController.text;

    if (StringUtils.isNullOrEmpty(title) && StringUtils.isNullOrEmpty(text)) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Error"),
                content: Text("Cannot add an empty note!"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Close"),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));
    } else {
      Note note = Note(text: text, title: title);
      note.uid = widget.noteReference;

      await Firestore.instance
          .collection(AuthProvider.of(context).user.uid)
          .document(note.uid)
          .setData(note.toMap());

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.isNewNote ? "New note" : "Edit note"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveNote,
          )
        ],
      ),
      body: FutureBuilder(
        future: Firestore.instance
            .collection(AuthProvider.of(context).user.uid)
            .document(widget.noteReference)
            .snapshots()
            .first,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null &&
                !StringUtils.isNullOrEmpty(widget.noteReference)) {
              _titleController.text = snapshot.data["title"];
              _textController.text = snapshot.data["text"];
            }
            return NoteEditForm(
              titleController: _titleController,
              textController: _textController,
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
