import 'dart:async';

import 'package:cars/pages/cars/car_dao.dart';
import 'package:cars/utils/network.dart';

import 'cars.dart';
import 'cars_api.dart';

class CarsBloc {
  final _streamController = StreamController<List<Cars>>();

  Stream<List<Cars>> get stream => _streamController.stream;

  Future<List<Cars>> loadCars(String tipo) async {
    try {
      bool networkConnectionOn = await isNetworkOn();
      if (!networkConnectionOn) {
        List<Cars> cars = await CarDAO().findAllByTipo(tipo);
        _streamController.add(cars);
        return cars;
      }

      List<Cars> cars = await CarsApi.getCars(tipo);
      if(cars.isNotEmpty){
        final dao = CarDAO();
        // save cars
        cars.forEach(dao.save);
      }
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
