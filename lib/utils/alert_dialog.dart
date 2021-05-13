import 'package:flutter/material.dart';

alert(BuildContext context, String message) {
  showDialog(
      //barrierDismissible para não permitir fechar o AlertDialog clicando fora dele
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          //onWillPop false para evitar do usuário apertar para voltar pelo navBar do Android 8.1 ou > e fechar o Dialog
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text("Cars"),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok")),
            ],
          ),
        );
      });
}
