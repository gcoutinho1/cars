import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:cars/pages/api_response.dart';
import 'package:cars/utils/http_helper.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart' as path;

class UploadApi {
  static Future<ApiResponse<String>> upload(File file) async {
    try {
      String url = "https://URL_HERE/api/v1/upload";

      List<int> imageBytes = await file.readAsBytesSync();
      String base64Image = convert.base64Encode(imageBytes);

      String fileName = path.basename(file.path);
//        teste mimeType com jpeg e png
      var params = {
        "fileName": fileName,
        "mimeType": "image/jpeg;image/png",
        "base64": base64Image
      };

      String json = convert.jsonEncode(params);

      print("http.upload: " + url);
      print("params: " + json);

      final response = await http
          .post(
          url,
          body: json
      )
          .timeout(
        Duration(seconds: 120),
        onTimeout: _onTimeOut,
      );

      print("http.upload << " + response.body);

      Map<String, dynamic> map = convert.json.decode(response.body);

      String urlFoto = map["url"];

      return ApiResponse.working(result: urlFoto);
    } catch (error, exception) {
      print("Erro ao fazer upload $error - $exception");
      return ApiResponse.error(message: "Não foi possível fazer o upload");
    }
  }

  static FutureOr<Response> _onTimeOut() {
    print("timeout!");
    throw SocketException("Não foi possível se comunicar com o servidor.");
  }
}