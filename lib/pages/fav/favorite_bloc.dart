import 'dart:async';
import 'package:cars/pages/cars/cars.dart';
import 'package:cars/pages/fav/favorite_service.dart';

class FavoriteBloc {
  final _streamController = StreamController<List<Cars>>();

  Stream<List<Cars>> get stream => _streamController.stream;

  Future<List<Cars>> fetch() async {
    try {
      List<Cars> cars =  FavoriteService.getCars();
      _streamController.add(cars);
      return cars;
    } catch (e) {
      print(e);
      if (!_streamController.isClosed) {
        _streamController.addError(e);
      }
    }
  }

  void dispose() {
    _streamController.close();
  }
}
