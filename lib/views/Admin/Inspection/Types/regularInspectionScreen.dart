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

  String object = "";
  int count = 0;

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
                            .copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                      )
                    ],
                  ),
                ),
                ListView.builder(
                    itemCount: count,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          titleWidget(context, 'Maintenance Charges or CAM'),
                          inputWidget(object),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          titleWidget(context, 'Maintenance Charges or CAM'),
                          inputWidget(object),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          titleWidget(context, 'Maintenance Charges or CAM'),
                          inputWidget(object),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          titleWidget(context, 'Maintenance Charges or CAM'),
                          inputWidget(object),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          titleWidget(context, 'Maintenance Charges or CAM'),
                          inputWidget(object),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ],
                      ));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleWidget(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .primaryTextTheme
          .subtitle1
          .copyWith(fontWeight: FontWeight.w700, color: Colors.black),
    );
  }

  Widget inputWidget(object) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        onChanged: (value) {
          setState(() {
            object = value;
          });
        },
        obscureText: false,
        keyboardType: TextInputType.number,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[300],
          labelStyle: TextStyle(fontSize: 15.0, color: Color(0xFF000000)),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(12.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(12.0)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(12.0)),
        ),
      ),
    );
  }
}
