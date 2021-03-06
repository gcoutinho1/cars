import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cars/pages/api_response.dart';
import 'package:cars/pages/cars/cars.dart';
import 'package:cars/pages/cars/cars_api.dart';
import 'package:cars/utils/alert_dialog.dart';
import 'package:cars/utils/event_bus.dart';
import 'package:cars/utils/nav.dart';
import 'package:cars/widgets/app_text.dart';
import 'package:cars/widgets/button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CarFormPage extends StatefulWidget {
  final Cars car;

  CarFormPage({this.car});

  @override
  State<StatefulWidget> createState() => _CarFormPageState();
}

class _CarFormPageState extends State<CarFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final tNome = TextEditingController();
  final tDesc = TextEditingController();
  final tTipo = TextEditingController();

  int _radioIndex = 0;

  var _showProgress = false;

  File _file;

  Cars get car => widget.car;

  // Add validate email function.
  String _validateNome(String value) {
    if (value.isEmpty) {
      return 'Informe o nome do carro.';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();

    // Copia os dados do carro para o form
    if (car != null) {
      tNome.text = car.nome;
      tDesc.text = car.descricao;
      _radioIndex = getTipoInt(car);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          car != null ? car.nome : "Novo Carro",
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: _form(),
      ),
    );
  }

  _form() {
    return Form(
      key: this._formKey,
      child: ListView(
        children: <Widget>[
          _headerFoto(),
          Text(
            "Clique na imagem para tirar uma foto",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Divider(),
          Text(
            "Tipo",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
          _radioTipo(),
          Divider(),
          AppText(
            "nome",
            "",
            controller: tNome,
            keyboardType: TextInputType.text,
            validator: _validateNome,
          ),
          AppText(
            "descricao",
            "",
            controller: tDesc,
            keyboardType: TextInputType.text,
            validator: _validateNome,
          ),
          AppButton(
            "Salvar",
            onPressed: _onClickSave,
            showProgress: _showProgress,
          ),
        ],
      ),
    );
  }

  _headerFoto() {
    return InkWell(
      onTap: _onClickPhoto,
      child: _file != null
          ? Image.file(
              _file,
              height: 150,
            )
          : car != null
              ? CachedNetworkImage(
                  imageUrl: car.urlFoto,
                )
              : Image.asset(
                  "assets/images/camera.png",
                  height: 150,
                ),
    );
  }

  _radioTipo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio(
          value: 0,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          "Cl??ssicos",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        Radio(
          value: 1,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          "Esportivos",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        Radio(
          value: 2,
          groupValue: _radioIndex,
          onChanged: _onClickTipo,
        ),
        Text(
          "Luxo",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ],
    );
  }

  void _onClickTipo(int value) {
    setState(() {
      _radioIndex = value;
    });
  }

  getTipoInt(Cars cars) {
    switch (cars.tipo) {
      case "classicos":
        return 0;
      case "esportivos":
        return 1;
      default:
        return 2;
    }
  }

  String _getTipo() {
    switch (_radioIndex) {
      case 0:
        return "classicos";
      case 1:
        return "esportivos";
      default:
        return "luxo";
    }
  }

  _onClickSave() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    // Cria o carro
    var c = car ?? Cars();
    c.nome = tNome.text;
    c.descricao = tDesc.text;
    c.tipo = _getTipo();
    print("Carro: $c");

    setState(() {
      _showProgress = true;
    });

    print("Salvar o carro $c");
    // await Future.delayed(Duration(seconds: 3));
    // save cars api
    ApiResponse<bool> response = await CarsApi.save(c, _file);
    if (response.working) {
      alert(context, "Carro salvo com sucesso", callback: () {
        EventBus.get(context).sendEvent(CarsEvent("Carro salvo", c.tipo));
        pop(context);
      });
    } else {
      alert(context, response.message);
    }

    setState(() {
      _showProgress = false;
    });

    print("Fim.");
  }

  void _onClickPhoto() async {
    final ImagePicker _picker = ImagePicker();
    XFile file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        // this._file = file;
      });
    }
  }
}
