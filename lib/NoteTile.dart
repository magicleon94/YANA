import 'package:flutter/material.dart';

class NoteTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function onTap;

  const NoteTile({Key key, this.title, this.subtitle, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Center(
        child: ListTile(
            title: Text(title),
            subtitle: Text(
              subtitle,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            onTap: () => onTap),
      ),
    );
  }
}
