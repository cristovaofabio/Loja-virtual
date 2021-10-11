import 'package:flutter/material.dart';
import 'package:loja_virtual/comum/CarrinhoVazio.dart';
import 'package:loja_virtual/comum/LoginCard.dart';
import 'package:loja_virtual/comum/PrecoCarrinho.dart';
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
          if (gerenciadorCarrinho.usuario!.nome.isEmpty) {
            return LoginCard();
          }

          if (gerenciadorCarrinho.itens.isEmpty) {
            return CarrinhoVazio(
              iconData: Icons.remove_shopping_cart,
              titulo: 'Nenhum produto no carrinho!',
            );
          }
          return ListView(
            children: <Widget>[
              Column(
                children: gerenciadorCarrinho.itens
                    .map((produtoCarrinho) => ItemCarrinho(produtoCarrinho))
                    .toList(),
              ),
              PrecoCarrinho(
                textoBotao: "Continuar para Entrega",
                onPressed: gerenciadorCarrinho.carrinhoValido
                    ? () {
                        Navigator.of(context).pushNamed('/endereco');
                      }
                    : () {},
              ),
            ],
          );
        },
      ),
    );
  }
}
