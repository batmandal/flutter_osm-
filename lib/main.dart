import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/input.dart';
// import 'package:flutter_application_1/models/service_model.dart';
import 'package:flutter_application_1/sheets/sheet_draggable.dart';
import 'package:flutter_application_1/widgets/buttons/button_current_location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? currentAddress;
  Position? currentPosition;

  final start = TextEditingController();
  final end = TextEditingController();

  // 45.249755,101.187022
  List<LatLng> routpoints = const [LatLng(52.05884, -1.345583)];

  double? _distance;

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width *
    //     MediaQuery.of(context).devicePixelRatio;
    // double screenHeight = MediaQuery.of(context).size.height *
    //     MediaQuery.of(context).devicePixelRatio;

    // double middleX = screenWidth / 2;
    // double middleY = screenHeight / 2;

    // ScreenCoordinate screenCoordinate =
    //     ScreenCoordinate(x: middleX.round(), y: middleY.round());
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
                initialZoom: 16, initialCenter: LatLng(51.519413, -0.126957)),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              PolylineLayer(polylines: [
                Polyline(points: routpoints, color: Colors.blue, strokeWidth: 9)
              ])
            ],
          ),
          SafeArea(
            child: Column(
              children: [
                Input(controller: start, hint: "Enter Starting Postcode"),
                Input(controller: end, hint: "Enter Ending Postcode"),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    List<Location> startL =
                        await locationFromAddress(start.text);
                    List<Location> endL = await locationFromAddress(end.text);

                    var v1 = startL[0].latitude;
                    var v2 = startL[0].longitude;
                    var v3 = endL[0].latitude;
                    var v4 = endL[0].longitude;

                    // Calculate the distance using Geolocator
                    _distance = Geolocator.distanceBetween(v1, v2, v3, v4);

                    var url = Uri.parse(
                        'http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
                    var response = await http.get(url);
                    print(response.body);
                    setState(() {
                      routpoints = [];

                      var ruter = jsonDecode(response.body)['routes'][0]
                          ['geometry']['coordinates'];
                      for (int i = 0; i < ruter.length; i++) {
                        var reep = ruter[i].toString();
                        reep = reep.replaceAll("[", "");
                        reep = reep.replaceAll("]", "");
                        var lat1 = reep.split(',');
                        var long1 = reep.split(",");
                        routpoints.add(
                          LatLng(
                            double.parse(lat1[1]),
                            double.parse(long1[0]),
                          ),
                        );
                      }

                      print(routpoints);
                    });
                  },
                  child: const Text("press"),
                ),
                const SizedBox(height: 10),
                Text('Distance: ${_distance?.toStringAsFixed(2) ?? ""} meters'),
              ],
            ),
          ),
          const Center(
            child: Icon(
              Icons.location_pin,
              size: 30,
              color: Colors.red,
            ),
          ),
          Positioned(
            right: 16,
            bottom: 300,
            child: ButtonCurrentLocation(
              onPressed: () async {
                currentPosition = await LocationHandler.getCurrentPosition();
                currentAddress = await LocationHandler.getAddressFromLatLng(
                    currentPosition!);
                setState(() {});
                print(currentPosition ?? "");
                print(currentAddress ?? "");
              },
            ),
          ),
          // const SheetDraggable()
        ],
      ),
    );
  }
}

abstract class LocationHandler {
  static Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  static Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await handleLocationPermission();
      if (!hasPermission) return null;
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placeMarks[0];
      return "${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}";
    } catch (e) {
      return null;
    }
  }
}
