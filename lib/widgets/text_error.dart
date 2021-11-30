import 'package:flutter/material.dart';

class TextError extends StatelessWidget {
  String message;


  TextError(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          color: Colors.redAccent,
          fontSize: 22,
        ),
      ),
    );
  }
}
