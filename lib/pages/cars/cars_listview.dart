import 'package:cached_network_image/cached_network_image.dart';
import 'package:cars/utils/nav.dart';
import 'package:flutter/material.dart';

import 'car_detail.dart';
import 'cars.dart';

class CarsListView extends StatelessWidget {
  List<Cars> cars;

  CarsListView(this.cars);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: cars.length,
        itemBuilder: (context, index) {
          Cars c = cars[index];
          return Card(
            color: Colors.grey[10],
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CachedNetworkImage(
                      imageUrl: c.urlFoto ?? "https://images.pexels.com/photos/8740896/pexels-photo-8740896.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                      width: 250,
                    ),
                  ),
                  Text(
                    c.nome,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(
                    "Descrição",
                    style: TextStyle(fontSize: 16),
                  ),
                  ButtonBar(
                    children: [
                      TextButton(
                        onPressed: () {
                          _onClickCar(context, c);
                        },
                        child: Text('DETALHES'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('SHARE'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

      _onClickCar(context, Cars c) {
        push(context, CarDetail(c));
  }
}
