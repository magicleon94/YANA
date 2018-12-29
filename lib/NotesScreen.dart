import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yana/AuthProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yana/NoteEditor.dart';
import 'package:yana/Models/Note.dart';

class NotesScreen extends StatefulWidget {
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    user = AuthProvider.of(context).user;

    return Scaffold(
      appBar: AppBar(title: Text("YANA"),),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection(user.uid).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("There was an error :("),
              );
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                return ListView(
                  children: snapshot.data.documents
                      .map<Widget>(
                        (DocumentSnapshot document) => new ListTile(
                              title:
                                  Text(document.data["title"] ?? "<No title>"),
                              subtitle: Text(
                                document.data["text"] ?? "<No text>",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              onTap: () =>
                                  editNote(document),
                            ),
                      )
                      .toList(),
                );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: createNote,
        ));
  }

  void createNote() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AuthProvider(
            child: NoteEditor(
              model: Note(),
            ),
            user: user)));
  }

  void editNote(DocumentSnapshot document) {
    Note note = Note.fromMap(document.data);
    note.uid = document.reference.documentID;

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            AuthProvider(child: NoteEditor(model: note), user: user)));
  }
}
