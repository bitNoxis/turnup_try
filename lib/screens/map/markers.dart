import 'package:latlong2/latlong.dart';

class MapMarker {

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
}

final _locations = [
  LatLng(53.4452934, 9.9608823), //Josias
  LatLng(53.4673132, 9.9853174), //Yachtclub Hansa Harburg
  LatLng(53.4548382, 9.9359941), //Maxi
  LatLng(53.4667889, 9.9566378), //Pfaffe
  LatLng(53.4794747, 9.8914109), //Björn
];

const _path = 'assets/';

/// creates marker on the map
final mapMarkers = [
  MapMarker(
    image: '${_path}logo.png',
    title: 'Josias',
    address: 'Am großen Dahlen 30',
    location: _locations[0],
  ),
  MapMarker(
    image: '${_path}logo.png',
    title: 'Yachtclub Hansa Harburg',
    address: 'zitadellenstraße 10',
    location: _locations[1],
  ),
  MapMarker(
    image: '${_path}logo.png',
    title: 'Maxi',
    address: 'Ehesdorfer Weg 144',
    location: _locations[2],
  ),
  MapMarker(
    image: '${_path}logo.png',
    title: 'Pfaffe',
    address: 'Gildering 17',
    location: _locations[3],
  ),
  MapMarker(
    image: '${_path}logo.png',
    title: 'Bjarne',
    address: 'Ünner Brandheid 22A',
    location: _locations[4],
  ),
];
