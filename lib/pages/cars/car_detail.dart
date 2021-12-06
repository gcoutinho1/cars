import 'package:cached_network_image/cached_network_image.dart';
import 'package:cars/pages/cars/description_bloc.dart';
import 'package:cars/pages/fav/favorite_service.dart';
import 'package:cars/widgets/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'cars.dart';

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
  @override
  void initState() {
    super.initState();
    FavoriteService.isFavorite(car).then((bool favorite){
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
        title: Text(widget.car.nome),
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
            CachedNetworkImage(imageUrl: widget.car.urlFoto),
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
            text(widget.car.nome, fontSize: 20, bold: true),
            text(widget.car.tipo, fontSize: 16),
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
              onPressed: _onClickFavorite,
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

  void _onClickVideo() {}

  _onClickPopupMenu(String value) {
    switch (value) {
      case "Editar":
        print("Editar!!");
        break;
      case "Deletar":
        print("Deletaaa!!");
        break;
      case "Compartilhar":
        print("Compartilha ai!");
        break;
    }
  }

  void _onClickFavorite() async {
    bool favorite = await FavoriteService.favoritar(car);
    setState(() {
      color = favorite ? Colors.red : Colors.grey;
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
        text(widget.car.descricao, fontSize: 16),
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

  @override
  void dispose() {
    super.dispose();
    _descriptionBloc.dispose();

  }
}
