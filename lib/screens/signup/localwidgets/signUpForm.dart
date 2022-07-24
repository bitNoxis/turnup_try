import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turnup_try/utils/firebase.dart';

import '../../../widgets/ourContainer.dart';

class OurSignUpForm extends StatelessWidget {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return OurContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: Text(
              "Registrieren",
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            controller: userNameController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
              hintText: "Username",
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.alternate_email),
              hintText: "E-Mail",
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock_outline_rounded),
              hintText: "Passwort",
            ),
            obscureText: true,
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 80),
              child: Text(
                "Registrieren",
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
            onPressed: () async {
              try {
                await Firebase.initializeApp();
                UserCredential user =
                await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text);
                User? updateUser = FirebaseAuth.instance.currentUser;
                updateUser?.updateDisplayName(userNameController.text);
                userSetup(userNameController.text);
                Navigator.of(context).pushReplacementNamed("/home");
              } catch (e) {
                print(e.toString());
              }
            },
          ),
        ],
      ),
    );
  }
}
