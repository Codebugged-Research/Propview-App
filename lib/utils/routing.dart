import 'package:flutter/material.dart';

class Routing {
  static makeRouting(BuildContext context,
      {String routeMethod = 'push', Widget newWidget}) async {
    try {
      switch (routeMethod) {
        case 'push':
          return await Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => newWidget));
          break;
        case 'pushReplacement':
          return await Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => newWidget));
          break;
        case 'pushAndRemoveUntil':
          return await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => newWidget),
              (Route<dynamic> route) => false);
          break;
        case 'pop':
          return Navigator.of(context).pop();
          break;
        default:
          return await Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => newWidget));
      }
    } catch (e) {
      print(e);
    }
  }
}
