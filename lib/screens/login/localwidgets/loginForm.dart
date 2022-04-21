import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turnup_try/screens/map/map.dart';
import 'package:turnup_try/screens/signup/signup.dart';

import '../../../widgets/ourContainer.dart';

class OurLoginForm extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return OurContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: Text(
              "Einloggen",
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.alternate_email),
              hintText: "E-Mail",
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outline_rounded),
              hintText: "Passwort",
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 80),
              child: Text(
                "Einloggen",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            )),
            onPressed: () {
              if (emailController.text == "user" &&
                  passwordController.text == "password") {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AnimatedMarkersMap()),
                );
              } else {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("Something went wrong try again pls"),
                      );
                    });
              }
              // showDialog(
              //   context: context,
              //   builder: (context){
              //     return AlertDialog(
              //       content: Text(myController.text),
              //     );
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => OurMap(),
              // )
              // );
            },
          ),
          TextButton(
            child: Text("Noch keinen Account? Hier registrieren."),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OurSignUp(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
