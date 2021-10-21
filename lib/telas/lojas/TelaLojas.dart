import 'package:flutter/material.dart';
import 'package:loja_virtual/comum/drawer_comum/DrawerCustomizado.dart';
import 'package:loja_virtual/models/GerenciadorLojas.dart';
import 'package:loja_virtual/telas/lojas/componentes/LojaCard.dart';
import 'package:provider/provider.dart';

class TelaLojas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustomizado(),
      appBar: AppBar(
        title: Text('Lojas'),
        centerTitle: true,
      ),
      body: Consumer<GerenciadorLojas>(
        builder: (_, storesManager, __) {
          if (storesManager.lojas.isEmpty) {
            return LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
              backgroundColor: Colors.transparent,
            );
          }

          return ListView.builder(
            itemCount: storesManager.lojas.length,
            itemBuilder: (_, index) {
              return LojaCard(storesManager.lojas[index]);
            },
          );
        },
      ),
    );
  }
}
