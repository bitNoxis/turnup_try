import 'package:flutter/material.dart';
import 'package:turnup_try/currently_logged_in.dart';
import 'package:turnup_try/screens/map/map.dart';
import 'package:turnup_try/screens/users/test.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initialize().then((value) => debugPrint('finished'));
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Eventueller HomeScreen ${loggedInUser!.name}"),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  child: Ink.image(
                    image: const AssetImage('assets/logo.png'),
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Stack(children: <Widget>[
          Center(
            child: IntrinsicWidth(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AnimatedMarkersMap()));
                    },
                    child: const Text(
                      "Zur Map",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const OurUsers()));
                    },
                    child: const Text(
                      "User",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        debugPrint(loggedInUser?.name);
                        debugPrint(userLocation.toString());
                      },
                      child: const Text("Das hier ist jetzt ein langer Text")),
                ],
              ),
            ),
          )
        ]));
  }
}
