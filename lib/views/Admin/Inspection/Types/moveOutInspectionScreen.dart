import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';

class MoveOutInspectionScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  const MoveOutInspectionScreen({this.propertyElement});
  @override
  _MoveOutInspectionScreenState createState() =>
      _MoveOutInspectionScreenState();
}

class _MoveOutInspectionScreenState extends State<MoveOutInspectionScreen> {
  PropertyElement propertyElement;

  TextEditingController maintainanceController = TextEditingController();
  TextEditingController commonAreaController = TextEditingController();
  TextEditingController electricitySocietyController = TextEditingController();
  TextEditingController electricityAuthorityController =
      TextEditingController();
  TextEditingController powerController = TextEditingController();
  TextEditingController pngController = TextEditingController();
  TextEditingController clubController = TextEditingController();
  TextEditingController waterController = TextEditingController();
  TextEditingController propertyTaxController = TextEditingController();
  TextEditingController anyOtherController = TextEditingController();

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
                        text: "Move out\n",
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
                    ])),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                titleWidget(context, 'Maintenance Charges or CAM'),
                inputWidget(maintainanceController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                titleWidget(context, 'Common Area Electricity (CAE)'),
                inputWidget(commonAreaController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                titleWidget(context, 'Electricity (Society)'),
                inputWidget(electricitySocietyController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                titleWidget(context, 'Electricity (Authority)'),
                inputWidget(electricityAuthorityController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                titleWidget(context, 'Power Back-Up'),
                inputWidget(powerController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                titleWidget(context, 'PNG/LPG'),
                inputWidget(pngController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                titleWidget(context, 'Club'),
                inputWidget(clubController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                titleWidget(context, 'Water'),
                inputWidget(waterController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                titleWidget(context, 'Property Tax'),
                inputWidget(propertyTaxController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                titleWidget(context, 'Any other'),
                inputWidget(anyOtherController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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

  Widget inputWidget(TextEditingController textEditingController) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        controller: textEditingController,
        obscureText: false,
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
