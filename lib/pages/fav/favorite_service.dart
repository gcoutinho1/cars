import 'package:cars/pages/cars/car_dao.dart';
import 'package:cars/pages/cars/cars.dart';
import 'package:cars/pages/fav/favorite_dao.dart';
import 'package:cars/pages/fav/favorite_model.dart';
import 'package:provider/provider.dart';

import 'favorite.dart';

class FavoriteService {
  static Future<bool> favoritar(context, Cars c) async {
    Favorite f = Favorite.fromCar(c);
    final dao = FavoriteDAO();
    final exists = await dao.exists(c.id);
    if (exists) {
      // remove from favorites
      dao.delete(c.id);
      Provider.of<FavoriteModel>(context, listen: false).getCars();
      return false;
    } else {
      // add on favorites
      dao.save(f);
      Provider.of<FavoriteModel>(context, listen: false).getCars();
      return true;
    }
  }

  static Future<List<Cars>> getCars() async {
    List<Cars> cars = await CarDAO()
        .query("select * from carro c, favorito f where c.id = f.id");
    return cars;
  }

  static Future<bool> isFavorite(Cars c) async {
    final dao = FavoriteDAO();
    final exists = await dao.exists(c.id);
    return exists;
  }
}
