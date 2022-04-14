import 'package:cars/firebase/firebase_service.dart';
import 'package:cars/pages/api_response.dart';
import 'package:cars/pages/cars/home_page.dart';
import 'package:cars/pages/login/login_page.dart';
import 'package:cars/utils/alert_dialog.dart';
import 'package:cars/utils/nav.dart';
import 'package:cars/widgets/app_text.dart';
import 'package:cars/widgets/button.dart';
import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _controllerName = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var _progress = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Cadastrar"),
      ),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            AppText(
              "Nome do usuário",
              "Cadastre seu nome",
              controller: _controllerName,
              validator: _validateRegisterName,
              // keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 20,
            ),
            AppText(
              "Email",
              "Cadastre seu email",
              controller: _controllerEmail,
              validator: _validateRegisterEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 20,
            ),
            AppText(
              "Senha",
              "Cadastre sua senha",
              controller: _controllerPassword,
              validator: _validateRegisterPassword,
              // keyboardType: TextInputType.emailAddress,
              password: true,
            ),
            SizedBox(
              height: 20,
            ),
            AppButton(
              "Cadastrar",
              onPressed: _onClickRegister,
              showProgress: _progress,
            ),
            AppButton(
              "Cancelar",
              onPressed: _onClickCancelRegister,
            ),
          ],
        ),
      ),
    );
  }

  String _validateRegisterName(String text) {
    if (text.isEmpty || text.length < 2) {
      return "Coloque um nome valido";
    }
    return null;
  }

  String _validateRegisterEmail(String text) {
    if (text.isEmpty) {
      return "Coloque um email valido";
    }
    return null;
  }

  String _validateRegisterPassword(String text) {
    if (text.isEmpty || text.length < 6) {
      return "A Senha precisa ter no minimo 6 digitos";
    }
    return null;
  }

  _onClickRegister() async {
    String nome = _controllerName.text;
    String email = _controllerEmail.text;
    String senha = _controllerPassword.text;

    bool formWorking = _formKey.currentState.validate();
    if (!formWorking) {
      return;
    }

    setState(() {
      _progress = true;
    });

    final service = FirebaseService();
    final ApiResponse response = await service.cadastrar(nome, email, senha);
    if (response.working) {
      push(context, HomePage(), replace: true);
    } else {
      alert(context, response.message);
    }

    setState(() {
      _progress = false;
    });
  }

  _onClickCancelRegister() {
    push(context, LoginPage(), replace: true);
  }
}
