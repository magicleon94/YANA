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
}

class _NoteEditorState extends State<NoteEditor> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _textController = TextEditingController();

  Future<Null> saveNote() async {
    String title = _titleController.text;
    String text = _textController.text;

    if (!StringUtils.isNullOrEmpty(title) && !StringUtils.isNullOrEmpty(text)) {
      Note note = Note(text: text, title: title);

      CollectionReference userNotes =
          Firestore.instance.collection(AuthProvider.of(context).user.uid);

      DocumentReference noteReference =
          StringUtils.isNullOrEmpty(widget.noteReference)
              ? userNotes.document()
              : userNotes.document(widget.noteReference);

      await noteReference.setData(note.toMap());
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("New note"),
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
            if (snapshot.data != null && !StringUtils.isNullOrEmpty(widget.noteReference)) {
              _titleController.text = snapshot.data["title"];
              _textController.text = snapshot.data["text"];
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: new NoteEditForm(
                  titleController: _titleController,
                  textController: _textController),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
