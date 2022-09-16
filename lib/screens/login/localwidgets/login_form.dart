import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turnup_try/screens/signup/sign_up.dart';

import '../../../widgets/our_container.dart';

class OurLoginForm extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  OurLoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OurContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
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
            keyboardType: TextInputType.emailAddress,
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
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
              onPressed: () async {
                await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text)
                    .then((value) {
                  Navigator.of(context).pushReplacementNamed("/home");
                }).onError((error, stackTrace) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: const Text(
                          'Das Passwort oder die E-Mail ist falsch!'),
                      actions: [
                        TextButton(
                          child: const Text('Erneut versuchen'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                });
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 80),
                child: Text(
                  "Einloggen",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0),
                ),
              )),
          TextButton(
            child: const Text("Noch keinen Account? Hier registrieren."),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const OurSignUp(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
