import 'dart:async';

import 'cars.dart';
import 'cars_api.dart';

class CarsBloc {
  final _streamController = StreamController<List<Cars>>();

  Stream<List<Cars>> get stream => _streamController.stream;

  Future<List<Cars>> loadCars(String tipo) async {
    try {
      List<Cars> cars = await CarsApi.getCars(tipo);
      _streamController.add(cars);
      return cars;
    } catch (e) {
      _streamController.addError(e);
    }
  }

  void dispose() {
    _streamController.close();
  }
}
