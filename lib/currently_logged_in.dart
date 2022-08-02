
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/cupertino.dart';
import 'package:turnup_try/models/user.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

User? loggedInUser;
late LatLng userLocation;
Position? _position;

Future initialize() async {
  onLogin();
  getUserLocation();
}

Future onLogin() async {
  if (loggedInUser == null) {
    debugPrint('yes it worked');
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
  if (!serviceEnabled){
    return Future.error('Location not enabled');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied){
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Permission denied');
    }
  }

  _position = await Geolocator.getCurrentPosition();

  userLocation = LatLng(_position!.latitude, _position!.longitude);
  return userLocation;
}

