import 'package:flutter/material.dart';
import 'package:yana/Views/NoteTile.dart';

class DismissibleTile extends StatelessWidget {
  final String documentID;
  final String title;
  final String subtitle;
  final Function onTapTile;
  final Function onDismiss;

  const DismissibleTile(
      {Key key,
      this.documentID,
      this.title,
      this.subtitle,
      this.onTapTile,
      this.onDismiss})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        direction: DismissDirection.endToStart,
        background: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.delete,
                color: Colors.black,
              ),
            )
          ],
        ),
        key: Key(documentID),
        child: NoteTile(
          title: title,
          subtitle: subtitle,
          onTapTile: onTapTile,
        ),
        onDismissed: onDismiss);
  }
}
