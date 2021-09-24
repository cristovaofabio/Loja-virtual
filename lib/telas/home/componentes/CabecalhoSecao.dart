import 'package:flutter/material.dart';
import 'package:loja_virtual/models/Secao.dart';

class CabecalhoSecao extends StatelessWidget {
  CabecalhoSecao(this.secao);

  late final Secao secao;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        secao.nome,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
    );
  }
}
