import 'package:cars/drawer_list.dart';
import 'package:cars/pages/cars/cars.dart';
import 'package:cars/pages/cars/cars_api.dart';
import 'package:cars/pages/cars/cars_listview.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Carros"),
          bottom: TabBar(tabs: [
            Tab(text: "Clássicos",),
            Tab(text: "Esportivos",),
            Tab(text: "Luxo",),
          ],),
        ),
        body: TabBarView(children: [
          CarsListView(),
          CarsListView(),
          CarsListView(),
        ],),
        drawer: DrawerList(),
      ),
    );
  }


}
