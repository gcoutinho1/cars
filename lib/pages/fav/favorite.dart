import 'package:cars/pages/cars/cars.dart';
import 'package:cars/utils/sql/entity.dart';

class Favorite extends Entity {
  int id;
  String nome;

  Favorite.fromCar(Cars c) {
    id = c.id;
    nome = c.nome;
  }

  Favorite.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    return data;
  }
}
