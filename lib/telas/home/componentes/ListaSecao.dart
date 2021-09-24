import 'package:flutter/material.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/Secao.dart';
import 'package:loja_virtual/telas/home/componentes/CabecalhoSecao.dart';

class ListaSecao extends StatelessWidget {
  ListaSecao(this.secao);

  late final Secao secao;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CabecalhoSecao(secao),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                return AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    secao.itens[index].imagem,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: temaPadrao.primaryColor,
                      ),
                    );
                  },
                  ),
                );
              },
              separatorBuilder: (_, __) => SizedBox(
                width: 4,
              ),
              itemCount: secao.itens.length,
            ),
          )
        ],
      ),
    );
  }
}
