import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EscolherImagem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid)
      return BottomSheet(
        onClosing: () {},
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min, //Menor altura possível
          crossAxisAlignment:
              CrossAxisAlignment.stretch, //Ocupar a maior largura possível
          children: <Widget>[
            TextButton(
              onPressed: () {},
              child: Text('Câmera'),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Galeria'),
            ),
          ],
        ),
      );
    else
      return CupertinoActionSheet(
        title: Text('Selecionar foto para o item'),
        message: Text('Escolha a origem da foto'),
        cancelButton: CupertinoActionSheetAction(
          onPressed: Navigator.of(context).pop,
          child: Text('Cancelar'),
        ),
        actions: <Widget>[
          CupertinoActionSheetAction(
            isDefaultAction: true, //Inicialmente a câmera ficará em negrito
            onPressed: () {},
            child: Text('Câmera'),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {},
            child: Text('Galeria'),
          ),
        ],
      );
  }
}
