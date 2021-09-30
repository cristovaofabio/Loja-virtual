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
      initialValue: List.from(produto.imagens),
      validator: (imagens) {
        if (imagens!.isEmpty) return 'Insira ao menos uma imagem';
      },
      //autovalidateMode: AutovalidateMode.always,
      builder: (estado) {
        void imagemSelecionada(File file) {
          estado.value!.add(file);
          estado.didChange(estado.value);
          Navigator.of(context).pop();
        }

        return Column(
          children: <Widget>[
            AspectRatio(
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
                              builder: (_) => EscolherImagem(
                                imagemSelecionada: imagemSelecionada,
                              ),
                            );
                          else
                            showCupertinoModalPopup(
                              context: context,
                              builder: (_) => EscolherImagem(
                                imagemSelecionada: imagemSelecionada,
                              ),
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
            ),
            if (estado.hasError)
              Container(
                margin: EdgeInsets.only(top: 15, left: 15),
                alignment: Alignment.centerLeft,
                child: Text(
                  estado.errorText.toString(),
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
