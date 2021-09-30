import 'package:flutter/material.dart';
import 'package:loja_virtual/models/Produto.dart';
import 'package:loja_virtual/models/TamanhoItem.dart';
import 'package:loja_virtual/telas/carrinho/componentes/IconeBotaoCustomizado.dart';
import 'package:loja_virtual/telas/produtos/componentes/EditarTamanhoItem.dart';

class FormularioTamanho extends StatelessWidget {
  final Produto produto;

  FormularioTamanho({required this.produto});

  @override
  Widget build(BuildContext context) {
    return FormField<List<TamanhoItem>>(
      initialValue: List.from(produto.tamanhos),
      builder: (state) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Tamanhos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconeBotaoCustomizado(
                    icone: Icons.add,
                    cor: Colors.black,
                    onTap: () {
                      state.value!.add(TamanhoItem());
                      state.didChange(state.value);
                    }),
              ],
            ),
            Column(
              children: state.value!.map((tamanho) {
                return EditarTamanhoItem(
                  key: ObjectKey(tamanho),
                  tamanhoItem: tamanho,
                  remover: () {
                    state.value!.remove(tamanho);
                    state.didChange(state.value);
                  },
                  moverParaCima: tamanho != state.value!.first
                      ? () {
                          final index = state.value!.indexOf(tamanho);
                          state.value!.remove(tamanho);
                          state.value!.insert(index - 1, tamanho);
                          state.didChange(state.value);
                        }
                      : () {},
                  moverParaBaixo: tamanho != state.value!.last
                      ? () {
                          final index = state.value!.indexOf(tamanho);
                          state.value!.remove(tamanho);
                          state.value!.insert(index + 1, tamanho);
                          state.didChange(state.value);
                        }
                      : () {},
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
