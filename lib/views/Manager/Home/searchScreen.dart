import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/PropertyOwner.dart';
import 'package:propview/services/propertyOwnerService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Admin/Home/OwnerPropertyListScreen.dart';
import 'package:propview/views/Admin/widgets/propertyCard.dart';

class SearchScreen extends StatefulWidget {
  final Property property;
  const SearchScreen({Key key, this.property}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    // search();
  }

  Property property;
  List<PropertyElement> resultProperty = [];
  bool loading = false;

  search() async {
    setState(() {
      loading = true;
      resultProperty.clear();
    });
    property = widget.property;
    property.data.property.forEach((element) {
      element.propertyOwner.ownerName.toLowerCase().contains(_controller.text)
          ? resultProperty.add(element)
          : print("skip");
    });
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RichText(
                  text: TextSpan(
                    text: "Search",
                    style: Theme.of(context)
                        .primaryTextTheme
                        .headline4
                        .copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: "\nProperty Owner",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline4
                            .copyWith(fontWeight: FontWeight.normal),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextFormField(
                    controller: _controller,
                    onChanged: (e) async {
                      await search();
                    },
                    cursorColor: Colors.black,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Enter Owner Name",
                      suffixIcon: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _controller.clear(),
                            icon: Icon(Icons.clear),
                          ),
                          IconButton(
                            onPressed: () async {
                              await search();
                            },
                            icon: Icon(Icons.search),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  color: Colors.white,
                  child: loading
                      ? Center(
                          child: circularProgressWidget(),
                        )
                      : ListView.builder(
                          itemCount: resultProperty.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == resultProperty.length - 1 &&
                                index == 0)
                              return Text("No Owners Found");
                            else
                              return PropertyCard(
                                propertyElement: resultProperty[index],
                              );
                          },
                        ),
                ),
                flex: 9,
              ),
            ],
          ),
        ),
      ),
    );
  }

  propertyOwnerCard(PropertyOwnerElement propertyOwner) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OwnerPropertyListScreen(
              propertyElement: propertyOwner,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset(
                  "assets/house.png",
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(propertyOwner.ownerName),
                      Text(propertyOwner.ownerEmail),
                      Text(propertyOwner.ownerNumber),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
