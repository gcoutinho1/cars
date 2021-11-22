import 'package:cars/utils/prefs.dart';
import 'dart:convert' as convert;

class User {
  String login;
  String nome;
  String email;
  String urlFoto;
  String token;
  List<String> roles;

  User(
      {this.login,
      this.nome,
      this.email,
      this.urlFoto,
      this.token,
      this.roles});

  User.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    nome = json['nome'];
    email = json['email'];
    urlFoto = json['urlFoto'];
    token = json['token'];
    roles = json['roles'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['urlFoto'] = this.urlFoto;
    data['token'] = this.token;
    data['roles'] = this.roles;
    return data;
  }

  void save() {
    Map map = toJson();
    String json = convert.json.encode(map);
    Prefs.setString("user.prefs", json);
  }

  static void clear() {
    Prefs.setString("user.prefs", "");
  }

  static Future<User> get() async {
    String json = await Prefs.getString("user.prefs");
    if (json.isEmpty) {
      return null;
    }
    Map map = convert.json.decode(json);
    User user = User.fromJson(map);
    return user;
  }
}

// @override
// String toString() {
//   return 'User{login: $login, nome: $nome, email: $email, urlFoto: $urlFoto, token: $token, roles: $roles}';
// }

// class User {
//   String login;
//   String nome;
//   String email;
//   String token;
//
//   List<String> roles;
//
//   User.fromJson(Map<String, dynamic> map)
//       : login = map["login"],
//         nome = map["nome"],
//         email = map["email"],
//         token = map["token"],
//         roles = map["roles"] != null ? map["roles"].map<String>((role) => role.toString()).toList() : null;
//
//   @override
//   String toString() {
//     return 'User{login: $login, nome: $nome, email: $email, token: $token, roles: $roles}';
//   }
// }
