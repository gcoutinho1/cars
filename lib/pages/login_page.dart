import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

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
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView(
        children: [
          Text("Usuário"),
          TextFormField(),
          SizedBox(height: 20,),
          Text("Senha"),
          TextFormField(
            obscureText: true,
          ),
          SizedBox(
            height: 20,
          ),
          // height: 45,
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink,
                  onPrimary: Colors.white,
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7))),
                  // padding: EdgeInsets.all(10),
                  side: BorderSide(color: Colors.redAccent),
                  minimumSize: Size(150, 30),

                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
