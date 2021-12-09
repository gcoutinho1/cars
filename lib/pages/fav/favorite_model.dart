import 'package:cars/pages/cars/cars.dart';
import 'package:cars/pages/fav/favorite_service.dart';
import 'package:flutter/material.dart';

class FavoriteModel extends ChangeNotifier {
  List<Cars> cars = [];

  Future<List<Cars>> getCars() async {

    cars = await FavoriteService.getCars();

    notifyListeners();

    return cars;
  }
}
