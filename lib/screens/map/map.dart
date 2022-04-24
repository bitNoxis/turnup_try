import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:turnup_try/screens/map/markers.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoibHVjYXNtYXR6ZSIsImEiOiJjbDI4dmtjcHAwYm95M2ptZXM1N3c4dGt3In0._6J67UkB6tn-o_z6quqSkg';
const MARKER_COLOR = Color(0xFF3DC5A7);
const URL_TEMPLATE =
    'https://api.mapbox.com/styles/v1/lucasmatze/cl28vr80f000415l1guw9ojlx/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibHVjYXNtYXR6ZSIsImEiOiJjbDI4dmtjcHAwYm95M2ptZXM1N3c4dGt3In0._6J67UkB6tn-o_z6quqSkg';

final _myLocation = LatLng(53.4529399, 9.9733788);

class AnimatedMarkersMap extends StatefulWidget {
  const AnimatedMarkersMap({Key? key}) : super(key: key);

  @override
  _AnimatedMarkersMapState createState() => _AnimatedMarkersMapState();
}

class _AnimatedMarkersMapState extends State<AnimatedMarkersMap> {
  final _pageController = PageController();

  List<Marker> _buildMarkers() {
    final _markerList = <Marker>[];
    for (int i = 0; i < mapMarkers.length; i++) {
      final mapItem = mapMarkers[i];
      _markerList.add(
        Marker(
          height: 40,
          width: 40,
          point: mapItem.location,
          builder: (_) {
            return GestureDetector(
              onTap: () {
                print('Selected: ${mapItem.title}');
              },
              child: Image.asset('assets/mapmarker.png'),
            );
          },
        ),
      );
    }
    return _markerList;
  }

  @override
  Widget build(BuildContext context) {
    final _markers = _buildMarkers();
    return Scaffold(
      appBar: AppBar(
        title: Text('Animated Markers'),
        backgroundColor: Color.fromARGB(255, 24, 24, 24),
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
              interactiveFlags:
                  InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              center: _myLocation,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: URL_TEMPLATE,
                additionalOptions: {
                  'accessToken': MAPBOX_ACCESS_TOKEN,
                  'id': 'mapbox.mapbox-streets-v8',
                },
              ),
              MarkerLayerOptions(
                markers: _markers,
              ),
              MarkerLayerOptions(markers: [
                Marker(
                    point: _myLocation,
                    builder: (_) {
                      return _MyLocationMarker();
                    })
              ])
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            height: MediaQuery.of(context).size.height * 0.3,
            child: PageView.builder(
              itemCount: mapMarkers.length,
              itemBuilder: (context, index) {
                final item = mapMarkers[index];
                return _MapItemDetails(
                  mapMarker: item,
                );
              },
            ),
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
          color: MARKER_COLOR,
          shape: BoxShape.circle,
        ));
  }
}

class _MapItemDetails extends StatelessWidget {
  const _MapItemDetails({
    Key? Key,
    required this.mapMarker,
  }) : super(key: Key);

  final MapMarker mapMarker;

  @override
  Widget build(BuildContext context) {
    final _styleTitle = TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
    final _styleAddress = TextStyle(color: Colors.grey[800], fontSize: 14);
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10.0,
                spreadRadius: 1.0,
                offset: Offset(4.0, 4.0),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Row(children: [
                  Expanded(
                    child: Image.asset(mapMarker.image),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        mapMarker.title,
                        style: _styleTitle,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        mapMarker.address,
                        style: _styleAddress,
                      ),
                    ],
                  ))
                ]),
              ),
              ElevatedButton(
                child: const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: Text(
                    "Call",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
                onPressed: () {},
              ),
            ],
          ),
        ));
  }
}
