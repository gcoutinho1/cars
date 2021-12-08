import 'package:cars/pages/fav/favorite_bloc.dart';
import 'package:cars/pages/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FavoriteBloc>(
          create: (context) => FavoriteBloc(),
          dispose: (context, bloc) => bloc.dispose(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // primarySwatch: Colors.white,
          accentColor: Colors.white,
          brightness: Brightness.dark,
          // scaffoldBackgroundColor: Colors.black45
        ),
        home: SplashScreen(),
      ),
    );
  }
}


