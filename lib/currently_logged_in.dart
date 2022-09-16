import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:turnup_try/models/user.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

User? loggedInUser;
late LatLng userLocation;
Position? _position;
LocationSettings locationSettings = const LocationSettings(distanceFilter: 5);

Future initialize() async {
  await onLogin();
  await getUserLocation();
}

Future onLogin() async {
  if (loggedInUser == null) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String test = auth.currentUser!.uid;
    var docUsers = FirebaseFirestore.instance.collection('Users').doc(test);
    var user = await docUsers.get();

    if (user.exists) {
      loggedInUser = User.fromJson(user.data()!);
    }
  }
}

Future<LatLng> getUserLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location wurde nicht aktiviert');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Erlaubnis wurde abgelehnt');
    }
  }

  _position = await Geolocator.getCurrentPosition();
  userLocation = positionToLatLng(_position!);
  return userLocation;
}

LatLng positionToLatLng(Position position) {
  return LatLng(position.latitude, position.longitude);
}
