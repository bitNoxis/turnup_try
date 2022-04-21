// mapbox Map with markers and info card
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoibHVjYXNtYXR6ZSIsImEiOiJjbDI4dmtjcHAwYm95M2ptZXM1N3c4dGt3In0._6J67UkB6tn-o_z6quqSkg';
const MARKER_COLOR = Color(0xFF3DC5A7);
const URL_TEMPLATE =
    'https://api.mapbox.com/styles/v1/lucasmatze/cl28vr80f000415l1guw9ojlx/tiles/{z}/{y}/{x}?access_token={accessToken}';

final _myLocation = LatLng(53.45, 9.97);

class AnimatedMarkersMap extends StatelessWidget {
  const AnimatedMarkersMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animated Markers'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_outlined),
            onPressed: () => null,
          )
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              minZoom: 5,
              maxZoom: 16,
              zoom: 11.8,
              center: LatLng(53.45, 9.97),
            ),
            nonRotatedLayers: [
              TileLayerOptions(
                urlTemplate: URL_TEMPLATE,
                additionalOptions: {
                  'accessToken': MAPBOX_ACCESS_TOKEN,
                },
              ),
              MarkerLayerOptions(markers: [
                Marker(
                    point: _myLocation,
                    builder: (_) {
                      return Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: MARKER_COLOR,
                          shape: BoxShape.circle,
                        ),
                      );
                    })
              ])
            ],
          ),
        ],
      ),
    );
  }
}

class _MyLocationMarker extends StatelessWidget {
  const _MyLocationMarker({Key? Key}) : super(key: Key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 44, 170, 107),
          shape: BoxShape.circle,
        ));
  }
}
