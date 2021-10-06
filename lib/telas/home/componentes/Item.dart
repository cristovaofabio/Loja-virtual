import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/GerenciadorHome.dart';
import 'package:loja_virtual/models/GerenciadorProdutos.dart';
import 'package:loja_virtual/models/Produto.dart';
import 'package:loja_virtual/models/Secao.dart';
import 'package:loja_virtual/models/SecaoItem.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class Item extends StatelessWidget {
  const Item(this.item);

  final SecaoItem item;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<GerenciadorHome>();

    return GestureDetector(
      onTap: () {
        if (item.produto != null) {
          final produto = context
              .read<GerenciadorProdutos>()
              .encontrarProdutoPorId(item.produto!);
          if (produto != null) {
            Navigator.of(context).pushNamed('/produto', arguments: produto);
          }
        }
      },
      onLongPress: homeManager.editando
          ? () {
              showDialog(
                context: context,
                builder: (_) {
                  final product;
                  if (item.produto != null) {
                    product = context
                        .read<GerenciadorProdutos>()
                        .encontrarProdutoPorId(item.produto!);
                  } else {
                    product = null;
                  }
                  return AlertDialog(
                    title: Text('Editar Item'),
                    content: product != null
                        ? ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Image.network(product.imagens!.first),
                            title: Text(product.nome!),
                            subtitle: Text(
                                'R\$ ${product.precoBase.toStringAsFixed(2)}'),
                          )
                        : null,
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          context.read<Secao>().removerItem(item);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: Colors.red[400],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Excluir",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (product != null) {
                            item.produto = null;
                          } else {
                            final Produto? product = await Navigator.of(context)
                                .pushNamed('/produtoSelecionado') as Produto;
                            if (product != null) {
                              item.produto = product.id;
                            }
                          }
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                            color: Colors.blue[400],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            product != null ? 'Desvincular' : 'Vincular',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          : () {},
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(
                color: temaPadrao.primaryColor,
              ),
            ),
            if (item.imagem is String)
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: item.imagem,
                fit: BoxFit.cover,
              )
            else
              Image.file(
                item.imagem as File,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}
