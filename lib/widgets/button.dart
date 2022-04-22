import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  String text;
  Function onPressed;
  bool showProgress;

  AppButton(this.text, {this.onPressed, this.showProgress = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          child: showProgress ? Center(child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),) : Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: Colors.grey[800],
            onPrimary: Colors.white,
            shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7))),
            side: BorderSide(color: Colors.grey[500]),
            minimumSize: Size(150, 30),
          ),
        ),
      ],
    );
  }
}
