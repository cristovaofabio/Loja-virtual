import 'package:flutter/material.dart';
import 'package:loja_virtual/comum/drawer_comum/DrawerCustomizado.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/GerenciadorProdutos.dart';
import 'package:loja_virtual/models/GerenciadorUsuarios.dart';
import 'package:loja_virtual/telas/produtos/componentes/BarraPesquisar.dart';
import 'package:loja_virtual/telas/produtos/componentes/ItemProduto.dart';
import 'package:provider/provider.dart';

class TelaProdutos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustomizado(),
      appBar: AppBar(
        title: Consumer<GerenciadorProdutos>(
          builder: (_, gerenciadorProdutos, __) {
            if (gerenciadorProdutos.pesquisa.isEmpty) {
              return Text('Produtos');
            } else {
              return LayoutBuilder(
                builder: (_, constraints) {
                  return GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(
                        context: context,
                        builder: (_) =>
                            BarraPesquisar(gerenciadorProdutos.pesquisa),
                      );
                      if (search != null) {
                        gerenciadorProdutos.pesquisa = search;
                      }
                    },
                    child: Container(
                      width: constraints
                          .biggest.width, //Tamanho máximo na horizontal
                      child: Text(
                        gerenciadorProdutos.pesquisa,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          Consumer<GerenciadorProdutos>(
            builder: (_, gerenciadorProdutos, __) {
              if (gerenciadorProdutos.pesquisa.isEmpty) {
                return IconButton(
                  icon: Icon(
                    Icons.search,
                  ),
                  onPressed: () async {
                    final search = await showDialog<String>(
                        context: context,
                        builder: (_) =>
                            BarraPesquisar(gerenciadorProdutos.pesquisa));
                    if (search != null) {
                      gerenciadorProdutos.pesquisa = search;
                    }
                  },
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    gerenciadorProdutos.pesquisa = '';
                  },
                );
              }
            },
          ),
          Consumer<GerenciadorUsuarios>(
            builder: (_, gerenciadorUsuarios, __) {
              if (gerenciadorUsuarios.adminHabilitado) {
                return IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/editar_produto',
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      body: Consumer<GerenciadorProdutos>(
        builder: (_, gerenciadorProdutos, __) {
          final produtosFiltrados = gerenciadorProdutos.filteredProducts;

          return ListView.builder(
            itemCount: produtosFiltrados.length,
            itemBuilder: (_, indice) {
              return ItemProduto(produto: produtosFiltrados[indice]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: temaPadrao.primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed('/carrinho');
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
