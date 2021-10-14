import 'package:flutter/material.dart';
import 'package:loja_virtual/models/Carrinho.dart';

class ItemProdutoPedido extends StatelessWidget {
  ItemProdutoPedido(this.carrinho);

  final Carrinho carrinho;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed('/produto', arguments: carrinho.produto);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 60,
              width: 60,
              child: Image.network(carrinho.produto!.imagens!.first),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    carrinho.produto!.nome!,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17.0,
                    ),
                  ),
                  Text(
                    'Tamanho: ${carrinho.tamanho}',
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    'R\$ ${(carrinho.precoFixo ?? carrinho.precoUnitario).toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${carrinho.quantidade}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
