import 'package:flutter/material.dart';
import 'package:turnup_try/currently_logged_in.dart';
import 'package:turnup_try/screens/map/map.dart';
import 'package:turnup_try/screens/leaderboard/user_leaderboard.dart';
import 'package:turnup_try/screens/profile/profile.dart';
import 'package:turnup_try/screens/testDate/date_test.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OurHomeScreen();
}

class OurHomeScreen extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() async {
    await initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (loggedInUser != null) {
      debugPrint('is getting build');
      return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(loggedInUser!.name),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Material(
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ProfileView()));
                    },
                    child: Ink.image(
                      image: (() {
                        if (loggedInUser == null) {
                          return const NetworkImage(
                              'https://image.shutterstock.com/image-vector/user-login-authenticate-icon-human-260nw-1365533969.jpg');
                        } else {
                          return NetworkImage(loggedInUser!.photoUrl);
                        }
                      }()),
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
                    buildElevatedButton(
                        context, 'Zur Map', const AnimatedMarkersMap()),
                    buildElevatedButton(
                        context, 'Start Event', const DateTest()),
                    buildElevatedButton(
                        context, 'Leaderboard', const OurUsers()),
                    buildElevatedButton(context, 'Das hier ist ein langer Text',
                        const ProfileView())
                  ],
                ),
              ),
            )
          ]));
    } else {
      return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: const Center(child: CircularProgressIndicator()),
      );
    }
  }

  ElevatedButton buildElevatedButton(
      BuildContext context, String textName, Widget widget) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => widget));
      },
      child: Text(
        textName,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),
      ),
    );
  }
}
