import 'package:flutter/material.dart';

class NoteEditForm extends StatefulWidget {
  const NoteEditForm({
    Key key,
    @required TextEditingController titleController,
    @required TextEditingController textController,
  }) : _titleController = titleController, _textController = textController, super(key: key);

  final TextEditingController _titleController;
  final TextEditingController _textController;

  @override
  NoteEditFormState createState() {
    return new NoteEditFormState();
  }
}

class NoteEditFormState extends State<NoteEditForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TextField(
                textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: 25,color: Theme.of(context).textTheme.title.color),
                decoration: InputDecoration(
                  hintText: "Title",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Color(0x44000000))
                ),
                controller: widget._titleController,
              ),
            ),
            Expanded(
              flex: 10,
              child: TextField(
                maxLines: null,
                autofocus: true,
                keyboardType: TextInputType.multiline,
                style: TextStyle(fontSize: 18,color: Theme.of(context).textTheme.body1.color),
                decoration: InputDecoration(
                  hintText: "Note",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Color(0x44000000))
                ),
                controller: widget._textController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
