import 'dart:convert' as convert;
import 'dart:io';

import 'package:cars/pages/api_response.dart';
import 'package:cars/pages/cars/cars.dart';
import 'package:cars/pages/cars/upload_api.dart';
import 'package:cars/pages/login/user.dart';
import 'package:http/http.dart' as http;

class TipoCarro {
  static final String classicos = "classicos";
  static final String esportivos = "esportivos";
  static final String luxo = "luxo";
}

class CarsApi {
  static Future<List<Cars>> getCars(String tipo) async {
    // comentei código abaixo porque o login esta sendo feito através do FireBase
    // Users user = await Users.get();
    // Map<String, String> headers = {
    //   "Content-type": "application/json",
    //   "Authorization": "Bearer ${user.token}"
    // };


    try {
      var url = Uri.parse(
          'https://URL_HERE/api/v1/carros');
      var response = await http.get(url);

      String json = response.body;

      List list = convert.json.decode(json);
      final cars = list.map<Cars>((map) => Cars.fromMap(map)).toList();
      return cars;
      //   await Future.delayed(Duration(seconds: 2));
      //   uma das formas de fazer o parse dos carros da api para adicionar na lista
      //   final cars = List<Cars>();
      //   for (Map map in list){
      //   Cars c = Cars.fromJson(map);
      //   cars.add(c);

    } catch (error, exception) {
      print("$error > $exception");
      throw error;
    }
  }

  static Future<ApiResponse<bool>> save(Cars c, File file) async {
    if (file != null){
      ApiResponse<String> response = await UploadApi.upload(file);
      if(response.working){
        String urlFoto = response.result;
        c.urlFoto = urlFoto;
      }
    }
    try {
      // comentei código abaixo porque o login esta sendo feito através do FireBase
      // Users user = await Users.get();
      // Map<String, String> headers = {
      //   "Content-type": "application/json",
      //   "Authorization": "Bearer ${user.token}"
      // };

      var url =
          Uri.parse('https://URL_HERE/api/v1/carros');
      if (c.id != null) {
          url = Uri.parse('https://URL_HERE/api/v1/carros/${c.id}');

      }
      print("POST > $url");
      String json = c.toJson();

      var response = await (c.id == null
          ? http.post(url, body: json)
          : http.put(url, body: json));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        Map mapResponse = convert.json.decode(response.body);
        Cars cars = Cars.fromMap(mapResponse);
        print("New car: ${cars.id}");
        return ApiResponse.working(result: true);
      }
      if (response.body == null || response.body.isEmpty) {
        return ApiResponse.error(message: "Não foi possível salvar o carro");
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(message: mapResponse["error"]);
    } catch (e) {
      print(e);
      return ApiResponse.error(message: "Não foi possível salvar o carro");
    }
  }
  static Future<ApiResponse<bool>> delete(Cars c) async {
    try {
      // comentei código abaixo porque o login esta sendo feito através do FireBase
      // Users user = await Users.get();
      // Map<String, String> headers = {
      //   "Content-type": "application/json",
      //   "Authorization": "Bearer ${user.token}"
      // };

      var url =
      Uri.parse('https://URL_HERE/api/v1/carros/${c.id}');
      print("DELETE > $url");

      var response = await (http.delete(url));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Map mapResponse = convert.json.decode(response.body);
        // Cars cars = Cars.fromMap(mapResponse);
        // print("Deleted car: ${cars.id}");
        return ApiResponse.working(result: true);
      }
        return ApiResponse.error(message: "Não foi possível deletar o carro");

    } catch (e) {
      print(e);
      return ApiResponse.error(message: "Não foi possível deletar o carro");
    }
  }
}
