import 'package:cars/pages/api_response.dart';
import 'package:cars/pages/cars/home_page.dart';
import 'package:cars/pages/login/login_api.dart';
import 'package:cars/pages/login/user.dart';
import 'package:cars/utils/alert_dialog.dart';
import 'package:cars/utils/nav.dart';
import 'package:cars/widgets/button.dart';
import 'package:cars/widgets/text.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _controllerUser = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            _showProgress
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : AppButton(
                    "Login",
                    onPressed: _onPressedLogin,
                    showProgress: _showProgress,
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

    // print("Login: $login, Senha: $password");
    setState(() {
      _showProgress = true;
    });
    ApiResponse response = await LoginApi.login(login, password);

    if (response.working) {
      User user = response.result;
      print(">>> $user");

      push(context, HomePage(), replace: true);
    } else {
      alert(context, response.message);
    }

    setState(() {
      _showProgress = false;
    });
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
    return null;
  }
}
