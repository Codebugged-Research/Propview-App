import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

versionErrorWiget(String version, BuildContext context, String uri) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text("New Version Available\n($version)"),
      content: Text("Please update the app!!!"),
      actions: [
        MaterialButton(
          child: Text(
            "Update",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            if (await canLaunch(uri)) {
              await launch(uri);
            } else {
              throw 'Could not launch $uri';
            }
          },
        ),
      ],
    ),
  );
}
