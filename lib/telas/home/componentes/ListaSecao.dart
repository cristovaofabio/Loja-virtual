import 'package:flutter/material.dart';
import 'package:loja_virtual/models/GerenciadorHome.dart';
import 'package:loja_virtual/models/Secao.dart';
import 'package:loja_virtual/telas/home/componentes/AddItem.dart';
import 'package:loja_virtual/telas/home/componentes/CabecalhoSecao.dart';
import 'package:loja_virtual/telas/home/componentes/Item.dart';
import 'package:provider/provider.dart';

class ListaSecao extends StatelessWidget {
  ListaSecao(this.secao);

  late final Secao secao;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<GerenciadorHome>();

    return ChangeNotifierProvider.value(
      value: secao,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CabecalhoSecao(),
            SizedBox(
              height: 150,
              child: Consumer<Secao>(
                builder: (_, secao, __) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      if (index < secao.itens.length) {
                        return Item(secao.itens[index]);
                      } else {
                        return AddItem();
                      }
                    },
                    separatorBuilder: (_, __) => SizedBox(width: 4),
                    itemCount: homeManager.editando
                        ? secao.itens.length + 1
                        : secao.itens.length,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
