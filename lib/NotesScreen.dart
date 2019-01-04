import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yana/AuthProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yana/NoteEditor.dart';
import 'package:yana/Models/Note.dart';
import 'package:yana/NoteTile.dart';

class NotesScreen extends StatefulWidget {
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  FirebaseUser user;
  GlobalKey scaffoldKey = GlobalKey(debugLabel: "Scaffold key");

  @override
  Widget build(BuildContext context) {
    user = AuthProvider.of(context).user;

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("YANA"),
        ),
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
                        (DocumentSnapshot document) => Dismissible(
                              key: Key(document.documentID),
                              background: Container(
                                  color: Colors.red,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left:16.0),
                                        child: Icon(Icons.delete,color: Colors.white,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right:16.0),
                                        child: Icon(Icons.delete,color: Colors.white,),
                                      )
                                    ],
                                  )),
                              child: NoteTile(
                                title: document.data["title"] ?? "<No title>",
                                subtitle: document.data["text"] ?? "<No text>",
                                onTap: () => editNote(document),
                              ),
                              onDismissed: (_) async {
                                Note deletedNote = await deleteNote(document);
                                final SnackBar snackBar = SnackBar(
                                  content: Text("Deleted"),
                                  action: SnackBarAction(
                                    label: "UNDO",
                                    onPressed: () {
                                      Firestore.instance
                                          .collection(
                                              AuthProvider.of(context).user.uid)
                                          .document(deletedNote.uid)
                                          .setData(deletedNote.toMap());
                                    },
                                  ),
                                );

                                Scaffold.of(context).showSnackBar(snackBar);
                                setState(() {});
                              },
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
        builder: (context) => AuthProvider(child: NoteEditor(), user: user)));
  }

  void editNote(DocumentSnapshot document) {
    Note note = Note.fromMap(document.data);
    note.uid = document.reference.documentID;

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AuthProvider(
            child: NoteEditor(
              noteReference: document.documentID,
            ),
            user: user)));
  }

  Future<Note> deleteNote(DocumentSnapshot document) async {
    Note deletedNote = Note(
        uid: document.documentID,
        title: document.data["title"],
        text: document.data["text"]);

    await Firestore.instance
        .collection(AuthProvider.of(context).user.uid)
        .document(document.documentID)
        .delete()
        .catchError((error) => Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(error.toString()),
              ),
            ));

    return deletedNote;
  }
}
