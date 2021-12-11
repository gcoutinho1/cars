import 'package:cars/firebase/firebase_service.dart';
import 'package:cars/pages/api_response.dart';
import 'package:cars/pages/cars/home_page.dart';
import 'package:cars/pages/login/login_bloc.dart';
import 'package:cars/utils/alert_dialog.dart';
import 'package:cars/utils/nav.dart';
import 'package:cars/widgets/app_text.dart';
import 'package:cars/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import 'cadastro_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _controllerUser = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _bloc = LoginBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // desabilita o back button no AppBar
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Cars"),
      ),
      body: _body(),
    );
  }

  _body() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            AppText(
              "Usuário",
              "Digite seu Usuário",
              controller: _controllerUser,
              validator: _validateLogin,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 20,
            ),
            AppText(
              "Senha",
              "Digite sua senha",
              password: true,
              controller: _controllerPassword,
              validator: _validatePassword,
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 20,
            ),
            // Center(
            //        child: CircularProgressIndicator(),
            //      )
            StreamBuilder<bool>(
                stream: _bloc.stream,
                builder: (context, snapshot) {
                  return AppButton(
                    "Login",
                    onPressed: _onPressedLogin,
                    showProgress: snapshot.data ?? false,
                  );
                }),
            Container(
              height: 46,
              margin: EdgeInsets.only(top: 20),
              child: GoogleSignInButton(
                onPressed: _onClickGoogle,
              ),
            ),
            Container(
              height: 46,
              margin: EdgeInsets.only(top: 20),
              child: InkWell(
                onTap: _onClickCadastrar,
                child: Text(
                  "Cadastre-se",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.red,
                      decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onPressedLogin() async {
    bool formWorking = _formKey.currentState.validate();
    if (!formWorking) {
      return;
    }

    String login = _controllerUser.text;
    String password = _controllerPassword.text;

    ApiResponse response = await _bloc.login(login, password);

    if (response.working) {
      // User user = response.result;

      push(context, HomePage(), replace: true);
    } else {
      alert(context, response.message);
    }
  }

  String _validateLogin(String text) {
    if (text.isEmpty) {
      return "Informe o usuário";
    }
    return null;
  }

  String _validatePassword(String text) {
    if (text.isEmpty) {
      return "Informe a senha";
    }
    if (text.length < 3) {
      return "A senha precisa ter no minimo 3 números";
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  _onClickGoogle() async {
    final service = FirebaseService();
    ApiResponse response = await service.loginGoogle();
    if (response.working) {
      push(context, HomePage(), replace: true);
    } else {
      alert(context, response.message);
    }
  }

  void _onClickCadastrar() async {
    push(context, CadastroPage(), replace: true);
  }
}
