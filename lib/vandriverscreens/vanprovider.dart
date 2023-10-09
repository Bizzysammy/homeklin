

import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider with ChangeNotifier {
   String google_api_key = "AIzaSyCk0zu5LUecfoOpBQlfcqv1h5OIWIL1of0";
  // create a location varibale
  late Location _location;
  //create a getter so that its not exposed
  Location get location => _location;

  LatLng _locationPosition=const LatLng(28.5546,29.5546);

  LatLng get locationPosition => _locationPosition;

  bool locationServiceActive = true;
  LocationProvider() {
    _location = Location();
  }
  initialization() async {
    getuserLocation();
  }

  getuserLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }


    location.onLocationChanged.listen((LocationData currentlocation) {
      _locationPosition = LatLng(
        currentlocation.latitude!.toDouble(),
        currentlocation.longitude!.toDouble(),
      );
    });
    location.enableBackgroundMode(enable: true);
    print(_locationPosition);
    notifyListeners();
  }
}
