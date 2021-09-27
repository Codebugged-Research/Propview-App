import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/PropertyOwner.dart';
import 'package:propview/services/propertyOwnerService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Admin/Home/OwnerPropertyListScreen.dart';
import 'package:propview/views/Admin/widgets/propertyCard.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    // search();
  }

  List<PropertyOwnerElement> propertyOwners = [];
  List<PropertyElement> properties = [];
  bool loading = false;

  TabController _tabController;

  searchOwner() async {
    setState(() {
      loading = true;
      propertyOwners.clear();
    });
    propertyOwners = await PropertyOwnerService.searchOwner(_controller.text);
    setState(() {
      loading = false;
    });
  }

  searchProperty() async {
    setState(() {
      loading = true;
      propertyOwners.clear();
    });
    properties = await PropertyOwnerService.searchProperty(_controller.text);
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
          child: Column(
            children: [
              
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: TabBar(
                  controller: _tabController,
                  indicator: UnderlineTabIndicator(
                    borderSide:
                        BorderSide(color: Color(0xff314B8C), width: 4.0),
                  ),
                  labelStyle: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff314B8C),
                  ),
                  unselectedLabelStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  unselectedLabelColor: Colors.black.withOpacity(0.4),
                  labelColor: Color(0xff314B8C),
                  tabs: [
                    Text(
                      "Owner",
                    ),
                    Text(
                      "Property",
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  // physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                await searchOwner();
                              },
                              cursorColor: Colors.black,
                              textCapitalization: TextCapitalization.words,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () => _controller.clear(),
                                      icon: Icon(Icons.clear),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await searchOwner();
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
                                    itemCount: propertyOwners.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == propertyOwners.length - 1 &&
                                          index == 0)
                                        return Text("No Owners Found");
                                      else
                                        return propertyOwnerCard(
                                            propertyOwners[index]);
                                    },
                                  ),
                          ),
                          flex: 9,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                await searchProperty();
                              },
                              cursorColor: Colors.black,
                              textCapitalization: TextCapitalization.words,
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Enter Property Name",
                                suffixIcon: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () => _controller.clear(),
                                      icon: Icon(Icons.clear),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await searchProperty();
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
                                    itemCount: properties.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == properties.length - 1 &&
                                          index == 0)
                                        return Text("No Properties Found");
                                      else
                                        return PropertyCard(
                                          propertyElement: properties[index],
                                        );
                                    },
                                  ),
                          ),
                          flex: 9,
                        ),
                      ],
                    ),
                  ],
                ),
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
