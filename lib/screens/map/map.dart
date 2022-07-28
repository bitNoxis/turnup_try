import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:turnup_try/models/markers.dart';
import 'package:turnup_try/utils/firebase.dart';

import '../../widgets/hero_dialog_route.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoibHVjYXNtYXR6ZSIsImEiOiJjbDI4dmtjcHAwYm95M2ptZXM1N3c4dGt3In0._6J67UkB6tn-o_z6quqSkg';
const MARKER_COLOR = Color(0xFF3DC5A7);
const URL_TEMPLATE =
    'https://api.mapbox.com/styles/v1/lucasmatze/cl28vr80f000415l1guw9ojlx/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibHVjYXNtYXR6ZSIsImEiOiJjbDI4dmtjcHAwYm95M2ptZXM1N3c4dGt3In0._6J67UkB6tn-o_z6quqSkg';

const MARKER_SIZE_EXPANDED = 55.0;
const MARKER_SIZE_SHRINKED = 35.0;

final _myLocation = LatLng(53.4529399, 9.9733788);

final nameController = TextEditingController();
final addressController = TextEditingController();

/// Der Stream von Daten, welche aus der Datenbank gelesen wird
Stream<List<MapMarker>> streamMapMarkers = readLocations();
List<MapMarker> mapMarkers = <MapMarker>[];
List<Marker> markers = <Marker>[];

class AnimatedMarkersMap extends StatefulWidget {
  const AnimatedMarkersMap({Key? key}) : super(key: key);

  @override
  _AnimatedMarkersMapState createState() => _AnimatedMarkersMapState();
}

class _AnimatedMarkersMapState extends State<AnimatedMarkersMap>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController();
  late final AnimationController _animationController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    mapMarkers = [];
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Markers'),
        backgroundColor: const Color.fromARGB(255, 24, 24, 24),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              // TODO should create at the current Location a new Marker
              onPressed: () async {
                CollectionReference locations =
                    FirebaseFirestore.instance.collection('Locations');
                MapMarker marker = MapMarker(
                    title: 'Test',
                    address: 'Test Street 123',
                    location: _myLocation);
                await locations.doc(marker.title).set(marker.toJson());
              }),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () async {
              debugPrint('this button currently does not do anything');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          /// StreamBuilder bekommt den Stream aus der Datenbank
          /// und wandelt diesen in zwei Listen um
          /// returns immer eine FlutterMap, evtl. ohne Marker
          StreamBuilder<List<MapMarker>>(
              stream: streamMapMarkers,
              builder: (context, snapshot) {
                markers = [];
                mapMarkers = [];
                if (snapshot.hasData) {
                  final markersData = snapshot.data;
                  for (int i = 0; i < markersData!.length; i++) {
                    mapMarkers.add(markersData[i]);
                    markers.add(buildMarker(markersData[i], i));
                  }
                }

                /// Hier werden die aus dem StreamBuilder gebauten
                /// Marker dargestellt.
                return FlutterMap(
                  options: MapOptions(
                    minZoom: 5,
                    maxZoom: 16,
                    zoom: 11.8,
                    interactiveFlags:
                        InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                    center: _myLocation,
                    onLongPress: (tapPosition, latLng) {
                  Navigator.push(
                    context,
                    HeroDialogRoute(
                      builder: (BuildContext context) {
                        return Center(
                          child: AlertDialog(
                            title: const Text('Add a new Marker'),
                            content: Container(
                              child: Hero(
                                tag: 'developer-hero',
                                child: Container(
                                  height: 300.0,
                                  width: 300.0,
                                  child: ListView(children: [
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        hintText: 'Name'
                                      ),
                                      controller: nameController,
                                    ),
                                    const Divider(height: 20, color: Colors.transparent,),
                                    TextFormField(
                                      decoration: const InputDecoration(hintText: 'Address'),
                                      controller: addressController,
                                    )
                                  ],)
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                child: const Text('Add Marker'),
                                onPressed: () async {
                                  CollectionReference locations = FirebaseFirestore.instance.collection('Locations');
                                  MapMarker marker = MapMarker(
                                      title: nameController.text,
                                      address: addressController.text,
                                      location: LatLng(latLng.latitude, latLng.longitude)
                                  );
                                  await locations.doc(marker.title).set(marker.toJson());
                                  Navigator.pop(context);
                                  return;
                                },
                              ),
                              CupertinoDialogAction(
                                child: const Text('Never Mind'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  return;
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
                  ),
                  layers: [
                    TileLayerOptions(
                        urlTemplate: URL_TEMPLATE,
                        additionalOptions: {
                          'accessToken': MAPBOX_ACCESS_TOKEN,
                          'id': 'mapbox.mapbox-streets-v8',
                        }),
                    MarkerLayerOptions(markers: markers),
                    MarkerLayerOptions(markers: [
                      Marker(
                          height: 60,
                          width: 60,
                          point: _myLocation,
                          builder: (_) {
                            return _MyLocationMarker(_animationController);
                          })
                    ]),
                  ],
                );
              }),

          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            height: MediaQuery.of(context).size.height * 0.3,
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
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

  Marker buildMarker(MapMarker marker, int i) => Marker(
        height: MARKER_SIZE_EXPANDED,
        width: MARKER_SIZE_EXPANDED,
        point: marker.location,
        builder: (_) {
          return GestureDetector(
            onTap: () {
              _selectedIndex = i;
              setState(() {
                _pageController.animateToPage(i,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastLinearToSlowEaseIn);
                debugPrint('Selected: ${marker.title}');
              });
            },
            child: _LocationMarker(
              selected: _selectedIndex == i,
            ),
          );
        },
      );
}

class _LocationMarker extends StatelessWidget {
  const _LocationMarker({Key? key, this.selected = false}) : super(key: key);

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final size = selected ? MARKER_SIZE_EXPANDED : MARKER_SIZE_SHRINKED;
    return Center(
      child: AnimatedContainer(
        height: size,
        width: size,
        duration: const Duration(milliseconds: 400),
        child: Image.asset('assets/mapmarker.png'),
      ),
    );
  }
}

class _MyLocationMarker extends AnimatedWidget {
  const _MyLocationMarker(Animation<double> animation, {Key? Key})
      : super(
          key: Key,
          listenable: animation,
        );

  @override
  Widget build(BuildContext context) {
    final value = (listenable as Animation<double>).value;
    final newValue = lerpDouble(0.5, 1.0, value)!;
    const size = 40.0;
    return Center(
        child: Stack(
      children: [
        Center(
          child: Container(
            height: size * newValue,
            width: size * newValue,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MARKER_COLOR.withOpacity(0.5),
            ),
          ),
        ),
        Center(
          child: Container(
            height: 20,
            width: 20,
            decoration: const BoxDecoration(
              color: MARKER_COLOR,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
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
    const _styleTitle = TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);
    final _styleAddress = TextStyle(color: Colors.grey[800], fontSize: 14);
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
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
                  padding: EdgeInsets.symmetric(horizontal: 80),
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
