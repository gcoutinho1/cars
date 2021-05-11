import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  String text;
  Function onPressed;


  AppButton(this.text, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: Colors.pink,
            onPrimary: Colors.white,
            shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7))),
            side: BorderSide(color: Colors.redAccent),
            minimumSize: Size(150, 30),
          ),
        ),
      ],
    );
  }
}
