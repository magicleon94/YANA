import 'package:flutter/material.dart';

class NoteTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function onTap;

  const NoteTile({Key key, this.title, this.subtitle, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0x33000000)),
          borderRadius: BorderRadius.circular(5)
        ),
        child: ListTile(
            title: Text(title),
            subtitle: Text(
              subtitle,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            onTap: onTap),
      ),
    );
  }
}
