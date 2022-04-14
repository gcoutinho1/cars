import 'package:cached_network_image/cached_network_image.dart';
import 'package:cars/firebase/firebasefavorite_service.dart';
import 'package:cars/pages/cars/car_form_page.dart';
import 'package:cars/pages/cars/description_bloc.dart';
import 'package:cars/pages/cars/video_page.dart';
import 'package:cars/pages/fav/favorite_service.dart';
import 'package:cars/utils/alert_dialog.dart';
import 'package:cars/utils/event_bus.dart';
import 'package:cars/utils/nav.dart';
import 'package:cars/widgets/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api_response.dart';
import 'cars.dart';
import 'cars_api.dart';

class CarDetail extends StatefulWidget {
  Cars car;

  CarDetail(this.car);

  @override
  _CarDetailState createState() => _CarDetailState();
}

class _CarDetailState extends State<CarDetail> {
  final _descriptionBloc = DescriptionBloc();

  Color color = Colors.grey;

  Cars get car => widget.car;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    final service = FirebaseFavoriteService();
    service.exists(car).then((b) {
      if (b) {
        setState(() {
          _isFavorite = b;
        });
      }
    });
    FavoriteService.isFavorite(car).then((bool favorite) {
      setState(() {
        color = favorite ? Colors.red : Colors.grey;
      });
    });
    _descriptionBloc.loadDescription();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(car.nome),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.place),
            onPressed: _onClickMap,
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: _onClickVideo,
          ),
          PopupMenuButton<String>(
              onSelected: (String value) => _onClickPopupMenu(value),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: "Editar",
                    child: Text("Editar"),
                  ),
                  PopupMenuItem(
                    value: "Deletar",
                    child: Text("Deletar"),
                  ),
                  PopupMenuItem(
                    value: "Compartilhar",
                    child: Text("Compartilhar"),
                  ),
                ];
              }),
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            CachedNetworkImage(
                imageUrl: car.urlFoto ??
                    "https://images.pexels.com/photos/8740896/pexels-photo-8740896.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
            bloco1(),
            Divider(),
            bloco2(),
          ],
        ));
  }

  Row bloco1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            text(car.nome, fontSize: 20, bold: true),
            text(car.tipo, fontSize: 16),
          ],
        ),
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: color,
                size: 40,
              ),
              // onPressed: _onClickFavorite,
              onPressed: _onClickFirebaseFavorite,
            ),
            IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
                size: 40,
              ),
              onPressed: _onClickShare,
            ),
          ],
        ),
      ],
    );
  }

  void _onClickMap() {}

  _onClickVideo() {
    if (car.urlVideo != null && car.urlVideo.isNotEmpty) {
      // launch(car.urlVideo);
      push(context, VideoPage(car));
    } else {
      alert(
        context,
        "Este carro não possui video",
      );
    }
  }

  _onClickPopupMenu(String value) {
    switch (value) {
      case "Editar":
        push(context, CarFormPage(car: car));
        break;
      case "Deletar":
        delete();
        break;
      case "Compartilhar":
        print("Compartilha ai!");
        break;
    }
  }

  //   //metodo pra salvar na Api
  //   void _onClickFavorite() async {
  //   bool favorite = await FavoriteService.favoritar(context, car);
  //   setState(() {
  //     color = favorite ? Colors.red : Colors.grey;
  //   });
  // }

  void _onClickFirebaseFavorite() async {
    final service = FirebaseFavoriteService();
    final exists = await service.addFavorite(car);
    setState(() {
      color = exists ? Colors.red : Colors.grey;
    });
  }

  void _onClickShare() {}

  bloco2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        text(car.descricao, fontSize: 16),
        SizedBox(
          height: 13,
        ),
        StreamBuilder<String>(
          stream: _descriptionBloc.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return text(snapshot.data, fontSize: 16);
          },
        ),
      ],
    );
  }

  void delete() async {
    ApiResponse<bool> response = await CarsApi.delete(car);
    if (response.working) {
      alert(context, "Carro deletado com sucesso", callback: () {
        EventBus.get(context).sendEvent(CarsEvent("Carro deletado", car.tipo));
        pop(context);
      });
    } else {
      alert(context, response.message);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionBloc.dispose();
  }
}
