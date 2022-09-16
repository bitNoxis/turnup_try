import 'package:flutter/material.dart';
import 'package:turnup_try/screens/signup/localwidgets/sign_up_form.dart';

class OurSignUp extends StatelessWidget {
  const OurSignUp({super.key});

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
