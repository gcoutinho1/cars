import 'package:flutter/material.dart';

import 'cars.dart';
import 'cars_api.dart';

class CarsListView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  _body() {
    Future<List<Cars>> cars = CarsApi.getCars();
    return FutureBuilder(
      future: cars,
      builder: (BuildContext context, AsyncSnapshot<List<Cars>> snapshot) {
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        List<Cars> cars = snapshot.data;
        return _listViewCars(cars);
      },
    );
  }

  Container _listViewCars(List<Cars> cars) {
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView.builder(
          itemCount: cars != null ? cars.length : 0,
          itemBuilder: (context, index) {
            Cars c = cars[index];

            return Card(
              // color: Colors.pink[400],
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        c.urlFoto ?? "https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
                        width: 220,
                      ),
                    ),
                    Text(
                      c.nome,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 20),
                    ),
                    Text("description test..."),
                    ButtonBarTheme(
                      data: ButtonBarTheme.of(context),
                      child: ButtonBar(
                        children: <Widget>[
                          TextButton(
                            child: const Text('DETAILS'),
                            onPressed: () {
                              /* ... */
                            },
                          ),
                          TextButton(
                            child: const Text('SHARE'),
                            onPressed: () {
                              /* ... */
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );

            // return ListTile(
            //   leading: Image.network(c.urlFoto),
            //   title: Text(c.nome,style: TextStyle(fontSize: 20),),
            // );
          }),
    );
  }
}
