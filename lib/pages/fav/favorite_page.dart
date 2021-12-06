import 'dart:async';
import 'package:cars/pages/cars/cars.dart';
import 'package:cars/pages/cars/cars_listview.dart';
import 'package:cars/widgets/text_error.dart';
import 'package:flutter/material.dart';
import 'favorite_bloc.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with AutomaticKeepAliveClientMixin<FavoritePage> {
  final _bloc = FavoriteBloc();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _bloc.fetch();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
        stream: _bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return TextError("Não foi possível buscar os seus favoritos");
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Cars> cars = snapshot.data;
          return RefreshIndicator(
              onRefresh: _onRefresh, child: CarsListView(cars));
        });
  }

  Future<void> _onRefresh() {
    return _bloc.fetch();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }
}
