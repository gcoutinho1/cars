import 'dart:convert';

import 'package:cars/pages/api_response.dart';
import 'package:cars/pages/login/user.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  static Future<ApiResponse<Users>> login(
      String login, String password) async {
    // first URL http://URL_HERE/rest/login
    try {
      var url =
          Uri.parse('https://URL_HERE/api/v1/login');

      Map<String, String> headers = {"Content-type": "application/json"};

      Map params = {
        "username": login,
        "password": password,
      };

      String s = json.encode(params);

      var response = await http.post(url, body: s, headers: headers);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // parser de JSON simples abaixo
      Map mapResponse = json.decode(response.body);

      // search JSON and serialization docs
      // String nome = mapResponse["nome"];
      // String email = mapResponse["email"];
      if (response.statusCode == 200) {
        final user = Users.fromJson(mapResponse);
        user.save();
        return ApiResponse.working(result: user);
      }
      return ApiResponse.error(message: mapResponse["error"]);
    } catch (error, exception) {
      print("Erro ao fazer login $error > $exception");

      return ApiResponse.error(message:
          "Não foi possível fazer o login.\nPor favor contate o suporte");
    }
  }
}
