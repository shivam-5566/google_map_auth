import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  LatLng _initialPosition = LatLng(25.5878, 83.5783);
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            locationSettings:
                LocationSettings(accuracy: LocationAccuracy.high));
        setState(() {
          _initialPosition = LatLng(position.latitude, position.longitude);
          _isLoading = false;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("Location permission not granted!");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
        actions: [
          IconButton(
            icon: Icon(Icons.login_outlined,color: Colors.red,),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 10,
              ),myLocationEnabled: true,
              mapType: MapType.satellite,
              myLocationButtonEnabled: true,
              onMapCreated: (controller) => mapController = controller,
            ),
    );
  }
}
