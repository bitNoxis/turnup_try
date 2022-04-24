import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turnup_try/screens/login/localwidgets/loginForm.dart';
import 'package:turnup_try/screens/signup/localwidgets/signUpForm.dart';

class OurSignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(20.0),
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
                      BackButton(),
                    ],
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  OurSignUpForm(),
                ],
              ),
            )
          ],
        ));
  }
}
