import 'package:flutter/material.dart';
import 'package:loja_virtual/models/GerenciadorHome.dart';
import 'package:loja_virtual/models/Secao.dart';
import 'package:loja_virtual/telas/carrinho/componentes/IconeBotaoCustomizado.dart';
import 'package:provider/provider.dart';

class CabecalhoSecao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<GerenciadorHome>();
    final secao = context.watch<Secao>();

    if (homeManager.editando) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  initialValue: secao.nome,
                  decoration: InputDecoration(
                    hintText: 'Título',
                    isDense: true,
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                  onChanged: (text) => secao.nome = text,
                ),
              ),
              IconeBotaoCustomizado(
                icone: Icons.remove,
                cor: Colors.white,
                onTap: () {
                  homeManager.removerSecao(secao);
                },
              ),
            ],
          ),
          if (secao.error.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                secao.error,
                style: TextStyle(color: Colors.red),
              ),
            )
        ],
      );
    } else {
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
}
