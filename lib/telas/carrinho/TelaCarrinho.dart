import 'package:flutter/material.dart';
import 'package:loja_virtual/models/GerenciadorCarrinho.dart';
import 'package:loja_virtual/telas/carrinho/componentes/ItemCarrinho.dart';
import 'package:provider/provider.dart';

class TelaCarrinho extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrinho"),
        centerTitle: true,
      ),
      body: Consumer<GerenciadorCarrinho>(
        builder: (_, gerenciadorCarrinho, __) {
          return Column(
            children: gerenciadorCarrinho.itens
                .map((produtoCarrinho) => ItemCarrinho(produtoCarrinho))
                .toList(),
          );
        },
      ),
    );
  }
}
