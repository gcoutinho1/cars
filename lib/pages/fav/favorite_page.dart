import 'dart:async';

import 'package:cars/firebase/firebasefavorite_service.dart';
import 'package:cars/pages/cars/cars.dart';
import 'package:cars/pages/cars/cars_listview.dart';
import 'package:cars/pages/cars/cars_page.dart';
import 'package:cars/pages/fav/favorite_model.dart';
import 'package:cars/widgets/text_error.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favorite_service.dart';

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

    final service = FirebaseFavoriteService();

    return StreamBuilder<QuerySnapshot>(
      stream: service.getCars(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return TextError("Não foi possível buscar os carros");
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Cars> carros =
            service.toList(snapshot);

        return CarsListView(carros);
      },
    );
  }
}
