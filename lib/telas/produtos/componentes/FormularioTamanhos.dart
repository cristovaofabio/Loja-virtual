import 'package:flutter/material.dart';
import 'package:loja_virtual/models/Produto.dart';
import 'package:loja_virtual/models/TamanhoItem.dart';
import 'package:loja_virtual/telas/produtos/componentes/EditarTamanhoItem.dart';

class FormularioTamanho extends StatelessWidget {
  final Produto produto;

  FormularioTamanho({required this.produto});

  @override
  Widget build(BuildContext context) {
    return FormField<List<TamanhoItem>>(
      initialValue: produto.tamanhos,
      builder: (state) {
        return Column(
          children: state.value!.map((tamanho) {
            return EditarTamanhoItem(
              tamanhoItem: tamanho,
            );
          }).toList(),
        );
      },
    );
  }
}
