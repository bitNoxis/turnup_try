import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class MapMarker {

  static const _path = 'assets/';

  final String image;
  final String title;
  final String address;
  final LatLng location;

  const MapMarker ({
    required this.image,
    required this.title,
    required this.address,
    required this.location,
  });

  static MapMarker fromJson(Map<String, dynamic> json) {
    MapMarker marker = MapMarker(
        image: '${_path}logo.png',
        title: json['title'],
        address: json['address'],
        location: latLngFromGeoPoint(json['LatLng'])
    );
    return marker;
  }

  dynamic toJson() => {'title': title,'address':address };

  @override
  String toString() {
    return toJson().toString();
  }

  static LatLng latLngFromGeoPoint(GeoPoint point) {
    print('please be calles');
    return LatLng(point.latitude, point.longitude);
  }
}

