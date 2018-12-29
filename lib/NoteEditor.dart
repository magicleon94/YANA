import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yana/AuthProvider.dart';
import 'package:yana/Models/Note.dart';
import 'package:yana/Utils.dart';

class NoteEditor extends StatefulWidget {
  const NoteEditor({Key key, @required this.model}) : super(key: key);
  _NoteEditorState createState() => _NoteEditorState();
  final Note model;
}

class _NoteEditorState extends State<NoteEditor> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (!StringUtils.isNullOrEmpty(widget.model.title)) {
      _titleController.text = widget.model.title;
    }

    if (!StringUtils.isNullOrEmpty(widget.model.text)) {
      _textController.text = widget.model.text;
    }
  }

  Future<Null> saveNote() async {
    String title = _titleController.text;
    String text = _textController.text;

    if (!StringUtils.isNullOrEmpty(title) && !StringUtils.isNullOrEmpty(text)) {
      widget.model.text = text;
      widget.model.title = title;
      CollectionReference userNotes =
          Firestore.instance.collection(AuthProvider.of(context).user.uid);

      DocumentReference noteReference =
          StringUtils.isNullOrEmpty(widget.model.uid)
              ? userNotes.document()
              : userNotes.document(widget.model.uid);

      await noteReference.setData(widget.model.toMap());
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TextField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "Title",
                  border: InputBorder.none,
                ),
                controller: _titleController,
              ),
            ),
            Expanded(
              flex: 10,
              child: TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Body",
                  border: InputBorder.none,
                ),
                controller: _textController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
