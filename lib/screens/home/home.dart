import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turnup_try/screens/map/map.dart';
import 'package:turnup_try/screens/users/test.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Eventueller HomeScreen"),
      ),
      body: Center(
        child: ButtonBar(
          children: <Widget>[
            ElevatedButton(
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 80),
                child: Text(
                  "Zur Map",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0),
                ),
              ),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AnimatedMarkersMap()));
              },
            ),
            ElevatedButton(
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 80),
                child: Text(
                  "Test ",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0),
                ),
              ),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const OurUsers()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
