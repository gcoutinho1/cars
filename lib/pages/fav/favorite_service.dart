import 'package:cars/pages/cars/cars.dart';
import 'package:cars/pages/fav/favorite_dao.dart';

import 'favorite.dart';

class FavoriteService {
  static favoritar(Cars c) async {

    Favorite f = Favorite.fromCar(c);
    final dao = FavoriteDAO();
    final exists = await dao.exists(c.id);
    if(exists){
      // remove from favorites
      dao.delete(c.id);
      // add on favorites
    } else {
      dao.save(f);
    }

}

  static List<Cars> getCars(){
    List<Cars> cars = [];
    return cars;

  }


}