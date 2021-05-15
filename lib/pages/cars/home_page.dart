import 'package:cars/drawer_list.dart';
import 'package:cars/pages/cars/cars.dart';
import 'package:cars/pages/cars/cars_api.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home Page"),
      ),
      body: _body(),
      drawer: DrawerList(),
    );
  }

  _body() {
    List<Cars> cars = CarsApi.getCars();
    return ListView.builder(
        itemCount: cars.length,
        itemBuilder: (context, index) {
          Cars c = cars[index];

          return Row(
            children: [
              Image.network(
                c.urlFoto,
                width: 110,
              ),
              Flexible(
                  child: Text(
                c.nome,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20),
              )),
            ],
          );

          // return ListTile(
          //   leading: Image.network(c.urlFoto),
          //   title: Text(c.nome,style: TextStyle(fontSize: 20),),
          // );
        });
  }
}
