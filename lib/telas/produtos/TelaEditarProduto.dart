import 'package:flutter/material.dart';
import 'package:loja_virtual/models/Produto.dart';
import 'package:loja_virtual/telas/produtos/componentes/FormularioImagem.dart';

class TelaEditarProduto extends StatelessWidget {
  final Produto produto;

  TelaEditarProduto(this.produto);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Anúncio'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          FormularioImagem(this.produto),
        ],
      ),
    );
  }
}