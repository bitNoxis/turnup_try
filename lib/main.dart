import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:turnup_try/screens/home/home.dart';
import 'package:turnup_try/screens/login/login.dart';
import 'package:turnup_try/utils/ourTheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: OurTheme().buildTheme(),
      home: OurLogin(),
      routes: {'/home': (_) => HomeScreen()},
    );
  }
}
