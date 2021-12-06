import 'package:cars/drawer_list.dart';
import 'package:cars/pages/cars/car_form_page.dart';
import 'package:cars/pages/cars/cars_api.dart';
import 'package:cars/pages/fav/favorite_page.dart';
import 'package:cars/utils/nav.dart';
import 'package:cars/utils/prefs.dart';
import 'package:flutter/material.dart';

import 'cars_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin<HomePage> {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // _tabController.index = 1;
    Future<int> future = Prefs.getInt("tabIdx");
    future.then((int idx) => _tabController.index = idx);

    _tabController.addListener(() {
      print("Tab ${_tabController.index}");

      Prefs.setInt("tabIdx", _tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Carros"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: "Clássicos",
              icon: Icon(Icons.directions_car_rounded),
            ),
            Tab(
              text: "Esportivos",
              icon: Icon(Icons.directions_car_outlined),
            ),
            Tab(
              text: "Luxo",
              icon: Icon(Icons.car_rental),
            ),
            Tab(
              text: "Favoritos",
              icon: Icon(Icons.favorite),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CarrosPage(TipoCarro.classicos),
          CarrosPage(TipoCarro.esportivos),
          CarrosPage(TipoCarro.luxo),
          FavoritePage(),
        ],
      ),
      drawer: DrawerList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _onClickAddCar,
      ),
    );
  }

  _onClickAddCar() {
    push(context, CarFormPage());
  }
}
