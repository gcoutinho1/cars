import 'dart:async';

import 'package:cars/pages/cars/cars_bloc.dart';
import 'package:cars/pages/cars/cars_listview.dart';
import 'package:cars/utils/event_bus.dart';
import 'package:cars/widgets/text_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cars.dart';

class CarrosPage extends StatefulWidget {
  String tipo;

  CarrosPage(this.tipo);

  @override
  _CarrosPageState createState() => _CarrosPageState();
}

class _CarrosPageState extends State<CarrosPage>
    with AutomaticKeepAliveClientMixin<CarrosPage> {
  List<Cars> cars;

  StreamSubscription<Event> subscription;

  String get tipo => widget.tipo;
  final _bloc = CarsBloc();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _bloc.loadCars(tipo);

    final bus = EventBus.get(context);
    subscription = bus.stream.listen((Event e) {
      print("Evento > $e");
      CarsEvent carsEvent = e;
      if (carsEvent.tipo == tipo) {
        _bloc.loadCars(tipo);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("Carros listView build ${tipo}");
    return StreamBuilder(
        stream: _bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return TextError("Não foi possível buscar a lista de carros");
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
    return _bloc.loadCars(widget.tipo);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    subscription.cancel();
  }
}
