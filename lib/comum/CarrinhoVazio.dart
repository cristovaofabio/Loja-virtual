import 'package:flutter/material.dart';

class CarrinhoVazio extends StatelessWidget {
  CarrinhoVazio({required this.titulo, required this.iconData});

  final String titulo;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            iconData,
            size: 80.0,
            color: Colors.white,
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
