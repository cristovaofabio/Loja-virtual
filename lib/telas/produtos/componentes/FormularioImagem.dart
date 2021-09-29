import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/Produto.dart';
import 'package:loja_virtual/telas/produtos/componentes/EscolherImagem.dart';

class FormularioImagem extends StatelessWidget {
  final Produto produto;
  FormularioImagem(this.produto);

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: produto.imagens,
      builder: (estado) {
        return AspectRatio(
          aspectRatio: 1,
          child: Carousel(
            images: estado.value!.map<Widget>((imagem) {
              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  if (imagem is String)
                    Image.network(
                      imagem,
                      fit: BoxFit.cover,
                    )
                  else
                    Image.file(
                      imagem as File,
                      fit: BoxFit.cover,
                    ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        estado.value!.remove(imagem);
                        //Informa um novo estado:
                        estado.didChange(estado.value);
                      },
                    ),
                  )
                ],
              );
            }).toList()
              ..add(
                //O Material serve para adicionar um pequeno efeito ao tocar no ícone
                Material(
                  color: Colors.grey[100],
                  child: IconButton(
                    icon: Icon(Icons.add_a_photo),
                    color: temaPadrao.primaryColor,
                    iconSize: 50,
                    onPressed: () {
                      if (Platform.isAndroid)
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => EscolherImagem(),
                        );
                      else
                        showCupertinoModalPopup(
                          context: context,
                          builder: (_) => EscolherImagem(),
                        );
                    },
                  ),
                ),
              ),
            dotSize: 4,
            dotSpacing: 15,
            dotBgColor: Colors.transparent,
            dotColor: temaPadrao.primaryColor,
            autoplay: false,
          ),
        );
      },
    );
  }
}
