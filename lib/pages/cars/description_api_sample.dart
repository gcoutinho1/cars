import 'dart:async';

import 'package:http/http.dart' as http;

class DescriptionApi {
  static Future<String> getDescription() async {
    var url = Uri.parse('https://loripsum.net/api');
    var response = await http.get(url);

    String text = response.body;
    text = text.replaceAll("<p>", "");
    text = text.replaceAll("</p>", "");
    return text;
  }
}
