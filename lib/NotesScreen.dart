import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yana/AuthProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yana/MyApp.dart';
import 'package:yana/NoteEditor.dart';
import 'package:yana/Models/Note.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yana/Views/DismissibleTile.dart';

class NotesScreen extends StatefulWidget {
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  SharedPreferences prefs;
  FirebaseUser user;
  GlobalKey scaffoldKey = GlobalKey(debugLabel: "Scaffold key");
  bool isGrid = false;

  @override
  void initState() {
    super.initState();
    _getPrefs();
  }

  void _signOut() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn = new GoogleSignIn();

    await firebaseAuth.signOut();
    await googleSignIn.signOut();

    runApp(MyApp());
  }

  @override
  Widget build(BuildContext context) {
    user = AuthProvider.of(context).user;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("YANA"),
        actions: <Widget>[
          IconButton(
            icon: Icon(isGrid ? Icons.view_list : Icons.grid_on),
            onPressed: () => _toggleGrid(),
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _signOut(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
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
              case ConnectionState.active:
                List<Widget> noteWidgets = snapshot.data.documents
                    .map<Widget>(
                      (DocumentSnapshot document) => DismissibleTile(
                          documentID: document.documentID,
                          title: document.data["title"] ?? "<No title>",
                          subtitle: document.data["text"] ?? "<No text>",
                          onTapTile: () => editNote(context, document),
                          onDismiss: (_) {
                            _deleteNote(context, document);
                          }),
                    )
                    .toList();
                return isGrid
                    ? GridView.count(
                        children: noteWidgets,
                        crossAxisCount: 2,
                        childAspectRatio: 2,
                      )
                    : ListView(
                        children: noteWidgets,
                      );
              case ConnectionState.done:
                return Center(
                  child: Text("Connection was closed."),
                );
              case ConnectionState.none:
                return Center(
                  child: Text("There's no connection."),
                );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Theme.of(context).iconTheme.color,
        ),
        onPressed: () => createNote(context),
      ),
    );
  }

  void createNote(BuildContext buildContext) {
    Navigator.of(buildContext).push(MaterialPageRoute(
        builder: (context) => AuthProvider(child: NoteEditor(), user: user)));
  }

  void editNote(BuildContext buildContext, DocumentSnapshot document) {
    Note note = Note.fromMap(document.data);
    note.uid = document.reference.documentID;

    Navigator.of(buildContext).push(MaterialPageRoute(
        builder: (context) => AuthProvider(
            child: NoteEditor(
              noteReference: document.documentID,
            ),
            user: user)));
  }

  void _deleteNote(BuildContext buildContext, DocumentSnapshot document) async {
    Note deletedNote = Note(
        uid: document.documentID,
        title: document.data["title"],
        text: document.data["text"]);

    await Firestore.instance
        .collection(AuthProvider.of(buildContext).user.uid)
        .document(document.documentID)
        .delete()
        .catchError((error) => Scaffold.of(buildContext).showSnackBar(
              SnackBar(
                content: Text(error.toString()),
              ),
            ));
    final SnackBar snackBar = SnackBar(
      content: Text("Note deleted"),
      action: SnackBarAction(
        label: "UNDO",
        onPressed: () {
          Firestore.instance
              .collection(AuthProvider.of(buildContext).user.uid)
              .document(deletedNote.uid)
              .setData(deletedNote.toMap());
        },
      ),
    );

    Scaffold.of(buildContext).showSnackBar(snackBar);
    setState(() {});
  }

  void _toggleGrid() {
    setState(() {
      isGrid = !isGrid;
      prefs.setBool("IS_GRID", isGrid);
    });
  }

  Future<Null> _getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    if (!prefs.getKeys().contains("IS_GRID")) {
      prefs.setBool("IS_GRID", false);
    } else {
      setState(() {
        isGrid = prefs.getBool("IS_GRID");
      });
    }
  }
}
