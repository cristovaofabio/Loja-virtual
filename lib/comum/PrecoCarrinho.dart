import 'package:flutter/material.dart';
import 'package:loja_virtual/models/GerenciadorCarrinho.dart';
import 'package:loja_virtual/util/BotaoCustomizado.dart';
import 'package:provider/provider.dart';

class PrecoCarrinho extends StatelessWidget {
  final String textoBotao;
  final VoidCallback onPressed;

  PrecoCarrinho({required this.textoBotao, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final gerenciadorCarrinho = context.watch<GerenciadorCarrinho>();
    final precosProdutos = gerenciadorCarrinho.precoProdutos;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, //Ocupar a largura máxima
          children: <Widget>[
            Text(
              'Resumo do Pedido',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Subtotal'),
                Text('R\$ ${precosProdutos.toStringAsFixed(2)}')
              ],
            ),
            Divider(),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  'R\$ ${precosProdutos.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            BotaoCustomizado(
              texto: this.textoBotao,
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
