// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:washa_mobile/auth/auth_service.dart';
import 'package:washa_mobile/data/style.dart';
import 'package:washa_mobile/views/widgets/appbar_title.dart';
import 'package:washa_mobile/views/widgets/header.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  // Initialized variables to null to handle null safety
  double? lat;
  double? long;
  String? address;
  final AuthService _authService = AuthService();

  Future<void> updateLocation() async {
    if (lat != null && long != null && address != null) {
      try {
        await _authService.updateAdress(lat!, long!, address!);
        Navigator.of(context).pop();
        _showSnackBar(context, "Adress updated sucessfully");
      } catch (e) {
        _showSnackBar(context, "Failed to update adress : $e");
      }
    } else {
      _showSnackBar(context, "Please select a location first!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: AppbarTitle("Select Address"),
      ),
      body: FlutterLocationPicker(
        initPosition: LatLong(23, 89),
        selectLocationButtonStyle: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.blue),
        ),
        selectedLocationButtonTextStyle: GoogleFonts.poppins(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
        selectLocationButtonText: 'Set Current Location',
        initZoom: 11,
        minZoomLevel: 5,
        maxZoomLevel: 30,
        trackMyPosition: true,
        searchbarBorderRadius: BorderRadius.circular(20),
        searchbarInputBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        searchbarInputFocusBorderp:
            OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        locationButtonBackgroundColor: Style.primary,
        markerIcon: Icon(
          Iconsax.location5,
          color: Style.primary,
          size: 35,
        ),
        urlTemplate:
            'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
        onError: (e) => _showSnackBar(context, e),
        onPicked: (pickedData) {
          inspect(pickedData);
          setState(() {
            lat = pickedData.latLong.latitude;
            long = pickedData.latLong.longitude;
            address = pickedData.address;
          });
          updateLocation();
        },
      ),
    );
  }

  void _showSnackBar(BuildContext context, label) {
    final snackbar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Header(
              label,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Style.primary,
      shape: StadiumBorder(side: BorderSide.none),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
