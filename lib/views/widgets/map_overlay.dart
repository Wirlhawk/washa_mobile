import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:iconsax/iconsax.dart';
import 'package:washa_mobile/data/notifiers.dart';

class MapOverlay extends StatefulWidget {
  const MapOverlay({super.key});

  @override
  MapOverlayState createState() => MapOverlayState();
}

class MapOverlayState extends State<MapOverlay> {
  late LatLng _currentLocation;
  bool _locationFetched = false;

  @override
  void initState() {
    super.initState();
    _currentLocation = LatLng(1.31, 103.8666);
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _locationFetched = true;
      });

      debugPrint("$position");

      _getAddressFromCoordinates(position.latitude, position.longitude);
    } catch (e) {
      debugPrint("$e");
    }
  }

  // Get address from latitude and longitude using geocoding
  Future<void> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        addresNotifier.value = "${place.street}";
      }
    } catch (e) {
      debugPrint("erorrrrr : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 250,
      child: _locationFetched
          ? Column(
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
                            point: _currentLocation,
                            width: 60,
                            height: 60,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(83, 68, 137, 255),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                Iconsax.location5,
                                color:
                                    Colors.blue, // Style.primary or your color
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ), // Show loading indicator until location is fetched
    );
  }
}
