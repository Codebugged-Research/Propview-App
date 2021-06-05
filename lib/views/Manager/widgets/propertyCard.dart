import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/views/Manager/Property/PropertyDetailScreen.dart';

class PropertyCard extends StatefulWidget {
  final PropertyElement propertyElement;
  const PropertyCard({this.propertyElement});

  @override
  _PropertyCardState createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        propertyOptionWidget(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 2.5,
                  spreadRadius: 0.0,
                ),
                BoxShadow(
                  color: Colors.grey,
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 2.5,
                  spreadRadius: 0.0,
                ),
              ]),
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                "assets/house.png",
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget(context, "Property Name: ",
                          '${widget.propertyElement.tblSociety.socname} ,  ${widget.propertyElement.tableproperty.unitNo}'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget textWidget(BuildContext context, String label, String data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          data,
          softWrap: true,
          // overflow: TextOverflow.ellipsis,
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  optionCard(label, image, onClick) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200],
                offset: const Offset(
                  0.0,
                  0.0,
                ),
                blurRadius: 2.0,
                spreadRadius: 0.0,
              ), //BoxShadow
              BoxShadow(
                color: Colors.grey,
                offset: const Offset(0.0, 0.0),
                blurRadius: 2.0,
                spreadRadius: 0.0,
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/$image.png",
              height: 35,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  propertyOptionWidget(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      backgroundColor: Color(0xFFFFFFFF),
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Choose Action',
                    style: Theme.of(context).primaryTextTheme.headline6,
                  )),
              Align(
                  alignment: Alignment.center,
                  child: Divider(
                    color: Color(0xff314B8C),
                    thickness: 2.5,
                    indent: 100,
                    endIndent: 100,
                  )),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  optionCard("Inspection", "task", () {}),
                  optionCard("Edit\nProperty", "renovation", () {}),
                  optionCard("Property\nDetails", "house", () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PropertyDetailScreen(
                          propertyId: widget
                              .propertyElement.tableproperty.propertyId
                              .toString(),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  optionCard(
                    "Assign\nproperty",
                    "owner",
                    () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
