// mapbox Map with markers and info card
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;

class OurMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlutterMap(
      options: MapOptions(
        center: latlng.LatLng(53.5, 9.99),
        zoom: 13.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate:
              "https://api.mapbox.com/styles/v1/lucasmatze/cl28vr80f000415l1guw9ojlx/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibHVjYXNtYXR6ZSIsImEiOiJjbDI4dmtjcHAwYm95M2ptZXM1N3c4dGt3In0._6J67UkB6tn-o_z6quqSkg",
          additionalOptions: {
            'accessToken':
                'pk.eyJ1IjoibHVjYXNtYXR6ZSIsImEiOiJjbDI4dmtjcHAwYm95M2ptZXM1N3c4dGt3In0._6J67UkB6tn-o_z6quqSkg',
            'id': 'mapbox.mapbox-streets-v8'
          },
          attributionBuilder: (_) {
            return Text("© OpenStreetMap contributors");
          },
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 40.0,
              height: 40.0,
              point: latlng.LatLng(53.4528864, 9.9734488),
              builder: (ctx) => Container(
                child: FlutterLogo(),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
