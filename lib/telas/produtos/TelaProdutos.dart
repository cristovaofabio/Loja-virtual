import 'package:flutter/material.dart';
import 'package:loja_virtual/comum/drawer_comum/DrawerCustomizado.dart';
import 'package:loja_virtual/models/GerenciadorProdutos.dart';
import 'package:provider/provider.dart';

class TelaProdutos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustomizado(),
      appBar: AppBar(
        title: Text("Produtos"),
        centerTitle: true,
      ),
      body: Consumer<GerenciadorProdutos>(
        builder: (_, gerenciadorProdutos, __) {
          return ListView.builder(
            itemCount: gerenciadorProdutos.todosProdutos.length,
            itemBuilder: (_, indice) {
              return Container();
            },
          );
        },
      ),
    );
  }
}
