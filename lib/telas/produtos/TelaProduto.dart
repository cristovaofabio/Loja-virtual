import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/Produto.dart';

class TelaProduto extends StatelessWidget {

  final Produto produto;

  TelaProduto(this.produto);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(produto.nome),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          AspectRatio( //Colocar a imagem quadrada
            aspectRatio: 1,
            child: Carousel(
              images: produto.imagens.map((url){
                return NetworkImage(url);
              }).toList(),
              dotSize: 4,
              dotSpacing: 15,
              dotBgColor: Colors.transparent,
              dotColor: temaPadrao.primaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              //Alinhar o conteúdo da coluna todo à esquerda:
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  produto.nome,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'A partir de',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  'R\$ 19.99',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: temaPadrao.primaryColor
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    'Descrição',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                Text(
                  produto.descricao,
                  style: const TextStyle(
                    fontSize: 16
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}