import 'package:cars/firebase/firebase_service.dart';
import 'package:cars/pages/api_response.dart';
import 'package:cars/pages/cars/home_page.dart';
import 'package:cars/pages/login/login_bloc.dart';
import 'package:cars/utils/alert_dialog.dart';
import 'package:cars/utils/nav.dart';
import 'package:cars/widgets/app_text.dart';
import 'package:cars/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

// import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

  // User fUser;
  // final FirebaseMessaging _firebaseMessaging =
  //     FirebaseMessaging as FirebaseMessaging;
  // var showForm = false;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() => print('Firebase inicializado'));
    FirebaseMessaging.instance.getToken().then((value) {
      String token = value;
      print("TOKEN: $token");
    });

    setState(() {});
    /** RemoteConfig of Firebase**/
    //   RemoteConfig.instance.then((remoteConfig){
    //   remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
    //
    //   try {
    //     remoteConfig.fetch(expiration: const Duration(minutes: 1));
    //     remoteConfig.activateFetched();
    //   } catch (error) {
    //     print("Remote Config: $error");
    //   }
    //
    //   final mensagem = remoteConfig.getString("mensagem");
    //   print('Mensagem: $mensagem');
    // });
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
              "Usu??rio",
              "Digite seu Usu??rio",
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GoogleSignInButton(
                    centered: true,
                    borderRadius: defaultBorderRadius,
                    text: "Acesse com sua conta Google",
                    onPressed: _onClickGoogle,
                  ),
                ],
              ),
            ),
            Container(
              height: 46,
              margin: EdgeInsets.only(top: 20),
              child: AppButton(
                "Cadastre-se",
                onPressed: _onClickCadastrar,
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
      return "Informe o usu??rio";
    }
    return null;
  }

  String _validatePassword(String text) {
    if (text.isEmpty) {
      return "Informe a senha";
    }
    if (text.length < 3) {
      return "A senha precisa ter no minimo 3 n??meros";
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
