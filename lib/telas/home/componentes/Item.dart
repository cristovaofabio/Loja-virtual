import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/GerenciadorProdutos.dart';
import 'package:loja_virtual/models/SecaoItem.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class Item extends StatelessWidget {
  const Item(this.item);

  final SecaoItem item;

  @override
  Widget build(BuildContext context) {
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
