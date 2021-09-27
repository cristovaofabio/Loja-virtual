import 'package:flutter/material.dart';
import 'package:loja_virtual/models/Secao.dart';
import 'package:loja_virtual/telas/home/componentes/CabecalhoSecao.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loja_virtual/telas/home/componentes/Item.dart';

class SecaoStaggered extends StatelessWidget {

  SecaoStaggered(this.secao);

  final Secao secao;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CabecalhoSecao(secao),
          StaggeredGridView.countBuilder(
            padding: EdgeInsets.zero,
            shrinkWrap: true, //A lista será a menor possívels
            crossAxisCount: 4, //Quantidade de unidades de medida (quadrados) na largura
            itemCount: secao.itens.length,
            itemBuilder: (_, index){
              return Item(secao.itens[index]);
            },
            /*Quantas unidades na horizontal e na vertical, ou seja,
            duas unidades na horizontal e duas ou uma unidade na vertical: */
            staggeredTileBuilder: (index) => StaggeredTile.count(2, index.isEven ? 2 : 1),
            mainAxisSpacing: 4, //Espaçamento na horizontal
            crossAxisSpacing: 4, //Espaçamento na vertical
          )
        ],
      ),
    );
  }
}