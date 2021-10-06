import 'package:flutter/material.dart';
import 'package:loja_virtual/telas/endereco/componentes/EnderecoCard.dart';

class TelaEndereco extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrega'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          EnderecoCard(),
        ],
      ),
    );
  }
}