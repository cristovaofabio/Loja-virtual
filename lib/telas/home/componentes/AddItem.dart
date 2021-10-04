import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/Secao.dart';
import 'package:loja_virtual/models/SecaoItem.dart';
import 'package:loja_virtual/telas/produtos/componentes/EscolherImagem.dart';
import 'package:provider/provider.dart';

class AddItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final secao = context.watch<Secao>();

    void onImageSelected(File file) {
      secao.addItem(SecaoItem(imagem: file));
      Navigator.of(context).pop();
    }

    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () {
          if (Platform.isAndroid) {
            showModalBottomSheet(
              context: context,
              builder: (context) =>
                  EscolherImagem(imagemSelecionada: onImageSelected),
            );
          } else {
            showCupertinoModalPopup(
              context: context,
              builder: (context) =>
                  EscolherImagem(imagemSelecionada: onImageSelected),
            );
          }
        },
        child: Container(
          color: Colors.white.withAlpha(30),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
