import 'package:flutter/material.dart';
import 'package:propview/views/updateScreen.dart';

versionErrorWiget(String version, BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text("New Version Available\n${version.split('+')[1]}"),
      content: Text("Please update the app!!!"),
      actions: [
        MaterialButton(
          child: Text(
            "Update",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> UpdateScreen()));
          },
        ),
      ],
    ),
  );
}
