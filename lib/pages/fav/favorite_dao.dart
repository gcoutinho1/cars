// Data Access Object
import 'package:cars/pages/fav/favorite.dart';
import 'package:cars/utils/sql/base_dao.dart';

class FavoriteDAO extends BaseDAO<Favorite> {
  @override
  String get tableName => "favorito";

  @override
  Favorite fromMap(Map<String, dynamic> map) {
    return Favorite.fromMap(map);
  }

  // Future<List<Favorite>> findAllByTipo(String id) async {
  //   final dbClient = await db;
  //   final list = await dbClient.rawQuery('select * from favorito where id =? ',[id]);
  //   return list.map<Favorite>((json) => fromMap(json)).toList();
  //
  // }

}