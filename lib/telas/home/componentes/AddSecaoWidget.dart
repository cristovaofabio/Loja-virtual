import 'package:flutter/material.dart';
import 'package:loja_virtual/models/GerenciadorHome.dart';
import 'package:loja_virtual/models/Secao.dart';

class AddSecaoWidget extends StatelessWidget {
  AddSecaoWidget(this.homeManager);

  final GerenciadorHome homeManager;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextButton(
            onPressed: () {
              homeManager.addSecao(Secao(nome: "nova secao", tipo: "lista", itens: []));
            },
            child: Text(
              'Adicionar Lista',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () {
              homeManager.addSecao(Secao(nome: "novo staggered", tipo: "staggered", itens: []));
            },
            child: Text(
              'Adicionar Grade',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
