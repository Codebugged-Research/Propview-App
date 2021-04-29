import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget circularProgressWidget() {
  return Platform.isAndroid
      ? CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff314B8C)))
      : CupertinoActivityIndicator(
          animating: true,
          radius: 20,
        );
}