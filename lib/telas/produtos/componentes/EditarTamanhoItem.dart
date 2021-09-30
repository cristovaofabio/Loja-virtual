import 'package:flutter/material.dart';
import 'package:loja_virtual/models/TamanhoItem.dart';
import 'package:loja_virtual/telas/carrinho/componentes/IconeBotaoCustomizado.dart';

class EditarTamanhoItem extends StatelessWidget {
  final TamanhoItem tamanhoItem;
  final VoidCallback remover;
  final VoidCallback moverParaCima;
  final VoidCallback moverParaBaixo;

  EditarTamanhoItem({Key? key,
    required this.tamanhoItem,
    required this.remover,
    required this.moverParaBaixo,
    required this.moverParaCima,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: tamanhoItem.nome,
            decoration: InputDecoration(
              labelText: 'Título',
              isDense: true,
            ),
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: tamanhoItem.estoque?.toString(),
            decoration: InputDecoration(
              labelText: 'Estoque',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Expanded(
          flex: 40,
          child: TextFormField(
            initialValue: tamanhoItem.preco?.toStringAsFixed(2),
            decoration: InputDecoration(
              labelText: 'Preço',
              isDense: true,
              prefixText: 'R\$',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        IconeBotaoCustomizado(
          icone: Icons.remove,
          cor: Colors.red,
          onTap: remover,
        ),
        IconeBotaoCustomizado(
          icone: Icons.arrow_drop_up,
          cor: Colors.black,
          onTap: this.moverParaCima,
        ),
        IconeBotaoCustomizado(
          icone: Icons.arrow_drop_down,
          cor: Colors.black,
          onTap: this.moverParaBaixo,
        ),
      ],
    );
  }
}
