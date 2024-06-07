// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

// class CenterListener extends StatelessWidget {
//   // final Function(Map<String, double>) setCenter;

//   // CenterListener({required this.setCenter});

//   @override
//   Widget build(BuildContext context) {
//     MapController mapController = MapController();
//     Timer? timeoutId;

//     void updateCenter() {
//       if (timeoutId != null) {
//         timeoutId!.cancel();
//       }

//       timeoutId = Timer(Duration(milliseconds: 400), () {
//         LatLng newCenter = mapController.center;
//         setCenter({
//           'lat': newCenter.latitude,
//           'lng': newCenter.longitude,
//         });
//       });
//     }

//     void disposeTimer() {
//       if (timeoutId != null) {
//         timeoutId!.cancel();
//       }
//     }

//     return FlutterMap(
//       mapController: mapController,
//       options: MapOptions(
//         initialCenter: LatLng(51.5, -0.09), // Initial map center
//         initialZoom: 13.0,
//         onPositionChanged: (mapPosition, _) {
//           updateCenter();
//         },
//       ),
//       children: [
//         TileLayer(
//           urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//           subdomains: ['a', 'b', 'c'],
//         ),
//       ],
//     );
//   }
// }
