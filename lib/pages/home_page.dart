import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home Page"),
      ),
      body: _body(),
    );
  }

  _body() {
    return Center(
      child: Text("Teste home Page"),
    );
  }
}
