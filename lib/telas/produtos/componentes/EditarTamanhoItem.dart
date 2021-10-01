import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/TamanhoItem.dart';
import 'package:loja_virtual/telas/carrinho/componentes/IconeBotaoCustomizado.dart';

class EditarTamanhoItem extends StatelessWidget {
  final TamanhoItem tamanhoItem;
  final VoidCallback remover;
  final VoidCallback moverParaCima;
  final VoidCallback moverParaBaixo;

  EditarTamanhoItem({
    Key? key,
    required this.tamanhoItem,
    required this.remover,
    required this.moverParaBaixo,
    required this.moverParaCima,
  }) : super(key: key);

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
            validator: (nome) {
              if (nome!.isEmpty) return 'Inválido';
            },
            inputFormatters: [
              FilteringTextInputFormatter(RegExp("[a-z A-Z á-ú Á-Ú 0-9]"),
                  allow: true)
            ],
            onChanged: (nome) => tamanhoItem.nome = nome,
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
            validator: (estoque) {
              if (estoque!.isEmpty) return 'Inválido';
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (estoque) => tamanhoItem.estoque = int.tryParse(estoque),
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
            validator: (preco) {
              if (preco!.isEmpty) return 'Inválido';
            },
            onChanged: (preco) => tamanhoItem.preco = num.tryParse(preco),
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
