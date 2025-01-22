import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Mapscreen extends StatefulWidget {
  static const String RouteName = 'mapscreen';

  const Mapscreen({super.key});

  @override
  State<Mapscreen> createState() => _MapscreenState();
}

class _MapscreenState extends State<Mapscreen> {
  late Location location;
  LocationData? currentLocation;
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    location = Location();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    PermissionStatus permissionStatus = await location.hasPermission();

    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
    }

    if (permissionStatus == PermissionStatus.granted) {
      currentLocation = await location.getLocation();
      setState(() {});
    } else {
      print("Location permission denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Current Location on Map"),
      ),
      body: currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId('current_location'),
            position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            infoWindow: InfoWindow(title: 'Your Location'),
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}
