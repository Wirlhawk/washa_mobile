import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:iconsax/iconsax.dart';
import 'package:washa_mobile/data/notifiers.dart';
import 'package:washa_mobile/data/style.dart';

class MapOverlay extends StatefulWidget {
  final String label;
  final double lat;
  final double long;
  const MapOverlay(
      {super.key, this.label = "", required this.lat, required this.long});

  @override
  MapOverlayState createState() => MapOverlayState();
}

class MapOverlayState extends State<MapOverlay> {
  late LatLng _currentLocation;
//   bool _locationFetched = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentLocation = LatLng(widget.lat, widget.long);
    });
  }

//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         locationSettings: LocationSettings(
//           accuracy: LocationAccuracy.high,
//           distanceFilter: 100,
//         ),
//       );

//       setState(() {
//         _currentLocation = LatLng(position.latitude, position.longitude);
//         _locationFetched = true;
//       });

//       _getAddressFromCoordinates(position.latitude, position.longitude);
//     } catch (e) {
//       debugPrint("$e");
//     }
//   }

//   Future<void> _getAddressFromCoordinates(
//     double latitude,
//     double longitude,
//   ) async {
//     try {
//       List<Placemark> placemarks =
//           await placemarkFromCoordinates(latitude, longitude);

//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];
//         addresNotifier.value = "${place.street}";
//       }
//     } catch (e) {
//       debugPrint("erorrrrr : $e");
//     }
//   }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        height: 250,
        child: Column(
          children: [
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: _currentLocation,
                  initialZoom: 16,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                    subdomains: ['a', 'b', 'c', 'd'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 200,
                        height: 100,
                        point: _currentLocation,
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(83, 68, 137, 255),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                Iconsax.location5,
                                color: Style.primary, // Style.primary or your
                              ),
                            ),
                            Text(
                              widget.label,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}
