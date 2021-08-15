import 'package:flutter/material.dart';

void showInSnackBar(BuildContext context, String value, int time) {
  ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
    content: new Text(value),
    duration: Duration(milliseconds: time),
  ));
}
