import 'package:flutter/material.dart';

class AlertWidget extends StatelessWidget {
  final String title, body;

  AlertWidget({this.title, this.body});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
      },
      child: AlertDialog(
          backgroundColor: Color(0xFFFFFFFF),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Text(title,
              style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                  fontWeight: FontWeight.bold, color: Color(0xff314B8C))),
          content: Text(body,
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle2
                  .copyWith(fontWeight: FontWeight.w600, color: Colors.black)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('OK',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .button
                      .copyWith(color: Colors.black)),
            ),
          ]),
    );
  }
}
