import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/PropertyOwner.dart';
import 'package:propview/services/propertyService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Admin/Home/searchPropertyCard.dart';

class OwnerPropertyListScreen extends StatefulWidget {
  final PropertyOwnerElement propertyElement;
  const OwnerPropertyListScreen({Key key, this.propertyElement})
      : super(key: key);

  @override
  _OwnerPropertyListScreenState createState() =>
      _OwnerPropertyListScreenState();
}

class _OwnerPropertyListScreenState extends State<OwnerPropertyListScreen> {
  @override
  void initState() {
    super.initState();
    getProperties();
  }

  bool loading = false;
  Property property;
  getProperties() async {
    setState(() {
      loading = true;
    });
    property = await PropertyService.getAllPropertiesByOwnerId(
        widget.propertyElement.ownerId);
    print(property.data.property.length);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: loading
            ? Center(
                child: circularProgressWidget(),
              )
            : Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RichText(
                        text: TextSpan(
                          text: widget.propertyElement.ownerName + "'s",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline5
                              .copyWith(fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: "\nProperty List",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline6
                                  .copyWith(fontWeight: FontWeight.normal),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Flexible(
                      child: Container(
                        child: ListView.builder(
                          itemCount: property.data.property.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == property.data.property.length &&
                                index == 0)
                              return Center(child: Text("No Properties Found"));
                            else
                              return SearchPropertyCard(
                                propertyElement: property.data.property[index],
                                propertyOwnerElement: widget.propertyElement,
                              );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
