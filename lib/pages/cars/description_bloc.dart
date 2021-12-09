import 'dart:async';

import 'package:cars/pages/cars/description_api.dart';

class DescriptionBloc {
  static String description;
  final _streamController = StreamController<String>();

  Stream<String> get stream => _streamController.stream;

  loadDescription() async {
      String s = description ?? await DescriptionApi.getDescription();
      description = s;
      _streamController.add(s);

      // _streamController.addError(e);

  }

  void dispose() {
    _streamController.close();
  }
}