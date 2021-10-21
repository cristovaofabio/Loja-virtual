import 'package:flutter/material.dart';
import 'package:loja_virtual/models/Loja.dart';
import 'package:loja_virtual/telas/carrinho/componentes/IconeBotaoCustomizado.dart';

class LojaCard extends StatelessWidget {
  LojaCard(this.store);

  final Loja store;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: <Widget>[
          Image.network(store.imagem),
          Container(
            height: 140,
            padding: EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        store.nome,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        store.enderecoText,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconeBotaoCustomizado(
                      icone: Icons.map,
                      cor: primaryColor,
                      onTap: () {},
                    ),
                    IconeBotaoCustomizado(
                      icone: Icons.phone,
                      cor: primaryColor,
                      onTap: () {},
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
