import 'package:cars/pages/login/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Colors.white,
        accentColor: Colors.white,
        brightness: Brightness.dark,
        // scaffoldBackgroundColor: Colors.black45
      ),
      home: LoginPage(),
    );
  }
}


