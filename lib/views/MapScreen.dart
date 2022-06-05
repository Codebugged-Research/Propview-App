import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:propview/config.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/gpsService.dart';

class MapScreen extends StatefulWidget {
  final User user;
  const MapScreen({Key key, this.user}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  dateFormatter() {
    var date = DateTime.now();
    return '${date.day.toString().padLeft(2, "0")}-${date.month.toString().padLeft(2, "0")}-${DateTime.now().year}';
  }

  bool loading = true;
  List<LatLng> points = [];
  getLocation(date) async {
    setState(() {
      loading = true;
    });
    List gpsList = await GPSService.getLocation(widget.user.userId, date);
    setState(() {
      print("updated");
      points = gpsList;
      loading = false;
    });
  }

  MapController mapController = MapController();
  String date = "";
  @override
  void initState() {
    super.initState();
    date = dateFormatter();
    getLocation(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GPS Logs", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month, color: Colors.black),
            onPressed: () async {
              final DateTime picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2021),
                lastDate: DateTime(2055),
              );
              setState(() {
                date =
                    '${picked.day.toString().padLeft(2, "0")}-${picked.month.toString().padLeft(2, "0")}-${picked.year}';
              });
              getLocation(date);
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              getLocation(date);
            },
          )
        ],
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : points.isEmpty
              ? Center(
                  child: Text("No GPS DATA!!!"),
                )
              : FlutterMap(
                  options: MapOptions(
                    center: LatLng(points[0].latitude, points[0].longitude),
                    zoom: 5.0,
                    onLongPress: (tapPostition, latLang) {
                      print(latLang.latitude);
                      print(latLang.longitude);
                    },
                  ),
                  layers: [
                    TileLayerOptions(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c']),
                    PolylineLayerOptions(
                      polylines: [
                        Polyline(
                            points: points,
                            strokeWidth: 4.0,
                            color: Colors.purple),
                      ],
                    ),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 34.0,
                          height: 34.0,
                          point: LatLng(
                              points.first.latitude, points.first.longitude),
                          builder: (ctx) => Container(
                            child: Icon(
                              Icons.flag,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Marker(
                          width: 34.0,
                          height: 34.0,
                          point: LatLng(
                              points.last.latitude, points.last.longitude),
                          builder: (ctx) => Container(
                            child: CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 15,
                              child: ClipOval(
                                child: FadeInImage.assetNetwork(
                                  height: 30,
                                  width: 30,
                                  fit: BoxFit.cover,
                                  placeholder: "assets/loader.gif",
                                  image:
                                      "${Config.STORAGE_ENDPOINT}${widget.user.userId}.jpeg",
                                  imageErrorBuilder: (BuildContext context,
                                      Object exception, StackTrace stackTrace) {
                                    return CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 15,
                                      backgroundImage: AssetImage(
                                        "assets/dummy.png",
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}
