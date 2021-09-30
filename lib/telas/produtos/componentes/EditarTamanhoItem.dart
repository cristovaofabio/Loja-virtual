import 'package:flutter/material.dart';
import 'package:loja_virtual/models/TamanhoItem.dart';

class EditarTamanhoItem extends StatelessWidget {

  final TamanhoItem tamanhoItem;

  EditarTamanhoItem({required this.tamanhoItem});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            initialValue: tamanhoItem.nome,
            decoration: InputDecoration(
              labelText: 'Título',
              isDense: true,
            ),
          ),
        ),
        SizedBox(width: 4,),
        Expanded(
          child: TextFormField(
            initialValue: tamanhoItem.estoque.toString(),
            decoration: InputDecoration(
              labelText: 'Estoque',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: 4,),
        Expanded(
          child: TextFormField(
            initialValue: tamanhoItem.preco!.toStringAsFixed(2),
            decoration: InputDecoration(
              labelText: 'Preço',
              isDense: true,
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
        ),
      ],
    );
  }
}