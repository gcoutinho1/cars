import 'dart:async';

import 'package:cars/firebase/firebase_service.dart';
import 'package:cars/pages/login/user.dart';
import '../api_response.dart';
import 'login_api.dart';

class LoginBloc {
  final _streamController = StreamController<bool>();

  get stream => _streamController.stream;

  Future<ApiResponse> login(String login, String password) async {
    _streamController.add(true);
    // ApiResponse response = await LoginApi.login(login, password);
    ApiResponse response = await FirebaseService().login(login, password);
    _streamController.add(false);
    return response;
  }

  void dispose() {
    _streamController.close();
  }
}
