import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loja_virtual/main.dart';

class EscolherImagem extends StatelessWidget {
  final Function(File) imagemSelecionada;
  final ImagePicker _picker = ImagePicker();

  EscolherImagem({required this.imagemSelecionada});

  Future<void> editarImagem(String path, BuildContext context) async {
    final File? croppedFile = await ImageCropper.cropImage(
        sourcePath: path,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0), //Fixar a imagem no formato quadrado
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Editar Imagem',
          toolbarColor: temaPadrao.primaryColor,
          toolbarWidgetColor: Colors.white,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Editar Imagem',
          cancelButtonTitle: 'Cancelar',
          doneButtonTitle: 'Concluir',
        ));
    if (croppedFile != null) {
      imagemSelecionada(croppedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid)
      return BottomSheet(
        onClosing: () {},
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min, //Menor altura possível
          crossAxisAlignment: CrossAxisAlignment.stretch, //Ocupar a maior largura possível
          children: <Widget>[
            TextButton(
              onPressed: () async {
                XFile? imagem =
                    await _picker.pickImage(source: ImageSource.camera);
                    if(imagem!=null){
                      editarImagem(imagem.path, context);
                    }
              },
              child: Text('Câmera'),
            ),
            TextButton(
              onPressed: () async {
                XFile? imagem =
                    await _picker.pickImage(source: ImageSource.gallery);
                    if(imagem!=null){
                      editarImagem(imagem.path, context);
                    }
              },
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
            onPressed: () async {
              XFile? imagem =
                  await _picker.pickImage(source: ImageSource.camera);
              editarImagem(imagem!.path, context);
            },
            child: Text('Câmera'),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () async {
              XFile? imagem =
                  await _picker.pickImage(source: ImageSource.gallery);
              editarImagem(imagem!.path, context);
            },
            child: Text('Galeria'),
          ),
        ],
      );
  }
}
