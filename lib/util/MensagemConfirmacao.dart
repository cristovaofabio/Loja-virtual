import 'package:flutter/material.dart';

SnackBar mensagemConfirmacao(String texto, Color cor, IconData icon) {
  return SnackBar(
    content: Row(
      children: <Widget>[
        Icon(
          icon,
          color: Colors.white,
        ),
        SizedBox(width: 17),
        Expanded(
          child: Text(
            texto,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        )
      ],
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: cor,
    duration: Duration(seconds: 3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
  );
}
