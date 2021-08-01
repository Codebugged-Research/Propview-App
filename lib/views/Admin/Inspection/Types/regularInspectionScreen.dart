import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';

class RegularInspectionScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  const RegularInspectionScreen({this.propertyElement});
  @override
  _RegularInspectionScreenState createState() =>
      _RegularInspectionScreenState();
}

class _RegularInspectionScreenState extends State<RegularInspectionScreen> {
  PropertyElement propertyElement;

  @override
  void initState() {
    super.initState();
    propertyElement = widget.propertyElement;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                        text: "Regular\n",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline4
                            .copyWith(fontWeight: FontWeight.bold),
                        children: [
                      TextSpan(
                          text: "Inspection",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline3
                              .copyWith(fontWeight: FontWeight.normal))
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
