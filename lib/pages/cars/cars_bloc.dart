import 'dart:async';

import 'cars.dart';
import 'cars_api.dart';

class CarsBloc {
  final _streamController = StreamController<List<Cars>>();

  Stream<List<Cars>> get stream => _streamController.stream;

  loadCars(String tipo) async {
    List<Cars> cars = await CarsApi.getCars(tipo);
    _streamController.add(cars);
  }

  void dispose() {
    _streamController.close();
  }
}