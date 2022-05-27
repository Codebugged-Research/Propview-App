import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:propview/config.dart';
import 'package:propview/models/User.dart';

class MapScreen extends StatefulWidget {
  final User user;
  const MapScreen({Key key, this.user}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool loading = true;
  List<LatLng> points = [];
  Position position = Position(latitude: 0, longitude: 0);
  getLocation() async {
    setState(() {
      loading = true;
    });
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      Geolocator.openAppSettings();
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      print("updated");
      points = <LatLng>[
        LatLng(position.latitude, position.longitude),
        LatLng(position.latitude + 1, position.longitude - 1),
        LatLng(position.latitude + 1, position.longitude + 1),
        LatLng(position.latitude - 1, position.longitude + 1),
      ];
      loading = false;
    });
  }

  MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : FlutterMap(
              options: MapOptions(
                center: LatLng(position.latitude, position.longitude),
                zoom: 5.0,
                onLongPress: (tapPostition, latLang) {
                  print(latLang.latitude);
                  print(latLang.longitude);
                },
                // onTap: (tapPosition, point) {
                //   setState(() {
                //     debugPrint('onTap');
                //     polylines = getPolylines();
                //   });
                // },
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c']),
                PolylineLayerOptions(
                  polylines: [
                    Polyline(
                        points: points, strokeWidth: 4.0, color: Colors.purple),
                  ],
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 34.0,
                      height: 34.0,
                      point:
                          LatLng(points.first.latitude, points.first.longitude),
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
                      point:
                          LatLng(points.last.latitude, points.last.longitude),
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
