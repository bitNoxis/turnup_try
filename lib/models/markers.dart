import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class MapMarker {

  static const _path = 'assets/';

  final String image;
  final String title;
  final String address;
  final LatLng location;

  const MapMarker ({
    this.image = '${_path}logo.png',
    required this.title,
    required this.address,
    required this.location,
  });

  static MapMarker fromJson(Map<String, dynamic> json) {
    MapMarker marker = MapMarker(
        title: json['title'],
        address: json['address'],
        location: latLngFromGeoPoint(json['LatLng'])
    );
    return marker;
  }

  dynamic toJson() => {
    'LatLng' : GeoPoint(location.latitude, location.longitude),
    'address': address,
    'title': title,
  };

  @override
  String toString() {
    return toJson().toString();
  }

  static LatLng latLngFromGeoPoint(GeoPoint point) {
    return LatLng(point.latitude, point.longitude);
  }
}

