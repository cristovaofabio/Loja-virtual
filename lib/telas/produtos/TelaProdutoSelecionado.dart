import 'package:flutter/material.dart';
import 'package:loja_virtual/models/GerenciadorProdutos.dart';
import 'package:provider/provider.dart';

class TelaProdutoSelecionado extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vincular Produto'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Consumer<GerenciadorProdutos>(
        builder: (_, productManager, __){
          return ListView.builder(
            itemCount: productManager.todosProdutos.length,
            itemBuilder: (_, index){
              final product = productManager.todosProdutos[index];
              return ListTile(
                leading: Image.network(product.imagens!.first),
                title: Text(product.nome!),
                subtitle: Text('R\$ ${product.precoBase.toStringAsFixed(2)}'),
                onTap: (){
                  Navigator.of(context).pop(product);
                },
              );
            },
          );
        },
      ),
    );
  }
}