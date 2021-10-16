import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/Endereco.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class ExportarEnderecoAlert extends StatelessWidget {
  ExportarEnderecoAlert(this.endereco);

  final Endereco endereco;
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Endereço de Entrega'),
      content: Screenshot(
        controller: screenshotController,
        child: Container(
          padding: EdgeInsets.all(8),
          color: Colors.white,
          child: Text(
            '${endereco.rua}, ${endereco.numero} ${endereco.complemento}\n'
            '${endereco.distrito}\n'
            '${endereco.cidade}/${endereco.estado}\n'
            '${endereco.zipCode}',
          ),
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await screenshotController.capture().then((imagem) async {
              if (imagem != null) {
                final Directory directory =
                    await getApplicationDocumentsDirectory();

                final imagePath =
                    await File('${directory.path}/image.png').create();
                await imagePath.writeAsBytes(imagem);

                await GallerySaver.saveImage(imagePath.path);
              }
            });
          },
          child: Text(
            'Exportar',
            style: TextStyle(color: temaPadrao.primaryColor),
          ),
        ),
      ],
    );
  }
}
