import 'package:flutter/material.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/Produto.dart';
import 'package:loja_virtual/models/TamanhoItem.dart';
import 'package:provider/provider.dart';

class TamanhoWidget extends StatelessWidget {
  TamanhoWidget(this.tamanho);

  final TamanhoItem tamanho;

  @override
  Widget build(BuildContext context) {
    final produto = context.watch<Produto>();
    final selecionado = tamanho == produto.tamanhoSelecionado;

    late Color cor;
    if (!tamanho.hasStock) {
      cor = Colors.red.withAlpha(50);
    } else if (selecionado) {
      cor = temaPadrao.primaryColor;
    } else {
      cor = Colors.grey;
    }

    return GestureDetector(
      onTap: () {
        if(tamanho.hasStock){
          produto.tamanhoSelecionado = tamanho;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: cor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, //Ocupar a mínima largura possível
          children: <Widget>[
            Container(
              color: cor,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                tamanho.nome as String,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'R\$ ${tamanho.preco!.toStringAsFixed(2)}',
                style: TextStyle(
                  color: cor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
