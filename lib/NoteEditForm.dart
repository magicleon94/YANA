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
    return Column(
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
            controller: widget._titleController,
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
            controller: widget._textController,
          ),
        ),
      ],
    );
  }
}
