import 'package:flutter/material.dart';
import 'package:turnup_try/screens/login/login.dart';
import 'package:turnup_try/screens/map/map.dart';
import 'package:turnup_try/utils/ourTheme.dart';

void main() {
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
    );
  }
}
