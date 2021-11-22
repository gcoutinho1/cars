import 'package:cars/pages/cars/car_detail.dart';
import 'package:cars/utils/nav.dart';
import 'package:flutter/material.dart';
import 'cars.dart';
import 'cars_api.dart';

class CarsListView extends StatefulWidget {
  String tipo;

  CarsListView(this.tipo);

  @override
  _CarsListViewState createState() => _CarsListViewState();
}

class _CarsListViewState extends State<CarsListView>
    with AutomaticKeepAliveClientMixin<CarsListView> {
  List<Cars> cars;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future<List<Cars>> future = CarsApi.getCars(widget.tipo);
    future.then((List<Cars> cars) {
      setState(() {
        this.cars = cars;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (cars == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return _listViewCars(cars);
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
                        c.urlFoto ??
                            "https://images.pexels.com/photos/1592384/pexels-photo-1592384.jpeg?cs=srgb&dl=pexels-alexgtacar-1592384.jpg&fm=jpg",
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
                            child: const Text('DETALHES'),
                            onPressed: () {
                              _onClickCar(c);
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

  void _onClickCar(Cars c) {
    push(context, CarDetail(c));
  }
}
