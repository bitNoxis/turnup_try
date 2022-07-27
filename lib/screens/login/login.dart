import 'package:flutter/material.dart';
import 'package:turnup_try/screens/login/localwidgets/loginForm.dart';

class OurLogin extends StatelessWidget {
  const OurLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Image.asset(
                  "assets/logo.png",
                  width: 300,
                  height: 300,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              OurLoginForm()
            ],
          ),
        )
      ],
    ));
  }
}
