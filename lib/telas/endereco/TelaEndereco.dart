import 'package:flutter/material.dart';
import 'package:loja_virtual/comum/PrecoCarrinho.dart';
import 'package:loja_virtual/models/GerenciadorCarrinho.dart';
import 'package:loja_virtual/telas/endereco/componentes/EnderecoCard.dart';
import 'package:provider/provider.dart';

class TelaEndereco extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrega'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          EnderecoCard(),
          Consumer<GerenciadorCarrinho>(
            builder: (_, gerenciadorCarrinho, __) {
              if (gerenciadorCarrinho.enderecoValido) {
                return PrecoCarrinho(
                  textoBotao: 'Continuar para o Pagamento',
                  onPressed: () {},
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
