import 'package:flutter/material.dart';
import 'package:loja_virtual/models/Pedido.dart';
import 'package:loja_virtual/telas/carrinho/componentes/ItemProdutoPedido.dart';

class TelaConfirmacao extends StatelessWidget {

  TelaConfirmacao(this.pedido);

  final Pedido pedido;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido Confirmado'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      pedido.formattedId,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      'R\$ ${pedido.preco!.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: pedido.itens!.map((e){
                  return ItemProdutoPedido(e);
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}