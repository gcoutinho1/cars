import 'package:cars/pages/fav/favorite_model.dart';
import 'package:cars/pages/splash/splash_screen.dart';
import 'package:cars/utils/event_bus.dart';
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
        Provider<EventBus>(
            create: (context) => EventBus(),
            dispose: (context, bus) => bus.dispose(),
        ),
        ChangeNotifierProvider<FavoriteModel>(
          create: (context) => FavoriteModel(),
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


