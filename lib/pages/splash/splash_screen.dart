import 'package:cars/pages/cars/home_page.dart';
import 'package:cars/pages/login/login_page.dart';
import 'package:cars/pages/login/user.dart';
import 'package:cars/utils/nav.dart';
import 'package:cars/utils/sql/db_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(seconds: 3),(){
    //   push(context, LoginPage());
    //
    // });

    Future futureA = DatabaseHelper.getInstance().db;
    Future futureB = Future.delayed(Duration(seconds: 3));
    Future<User> futureC = Future.value(FirebaseAuth.instance.currentUser);

    // futureC.then((User user) {
    //   if (user != null) {
    //     // abaixo código exemplo para manter o usuario conectado
    //     push(context, HomePage(), replace: true);
    //     // setState(() {
    //     //   _controllerUser.text = user.login;
    //     // });
    //   }
    // });

    Future.wait([futureA, futureB, futureC]).then((List values) {
      User user = values[2];
      print(user);
      if (user != null) {
        push(context, HomePage(), replace: true);
      } else {
        push(context, LoginPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
