import 'package:flutter/material.dart';
import 'package:loja_virtual/models/Secao.dart';
import 'package:loja_virtual/telas/home/componentes/CabecalhoSecao.dart';
import 'package:loja_virtual/telas/home/componentes/Item.dart';

class ListaSecao extends StatelessWidget {
  ListaSecao(this.secao);

  late final Secao secao;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CabecalhoSecao(secao),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                return Item(secao.itens[index]);
              },
              separatorBuilder: (_, __) => SizedBox(
                width: 4,
              ),
              itemCount: secao.itens.length,
            ),
          )
        ],
      ),
    );
  }
}
