import 'dart:async';

import 'package:cars/pages/cars/cars.dart';
import 'package:cars/pages/cars/cars_listview.dart';
import 'package:cars/pages/fav/favorite_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with AutomaticKeepAliveClientMixin<FavoritePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    FavoriteModel model = Provider.of<FavoriteModel>(context, listen: false);
    model.getCars();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    FavoriteModel model = Provider.of<FavoriteModel>(context);
    List<Cars> cars = model.cars;

    if (cars.isEmpty) {
      return Center(
        child: Text(
          "Você não salvou algum carro nos favoritos",
          style: TextStyle(fontSize: 20),
        ),
      );
    }
    return RefreshIndicator(onRefresh: _onRefresh, child: CarsListView(cars));
  }

  Future<void> _onRefresh() async {
    return Provider.of<FavoriteModel>(context, listen: false).getCars();
  }
}
