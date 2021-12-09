import 'package:cars/pages/cars/cars.dart';

import '../../utils/sql/base_dao.dart';

// Data Access Object
class CarDAO extends BaseDAO<Cars> {
  @override
  String get tableName => "carro";

  @override
  Cars fromMap(Map<String, dynamic> map) {
    return Cars.fromMap(map);
  }

  Future<List<Cars>> findAllByTipo(String tipo) async {
    final dbClient = await db;
    final list = await dbClient.rawQuery('select * from carro where tipo =? ',[tipo]);
    return list.map<Cars>((json) => fromMap(json)).toList();

  }

}