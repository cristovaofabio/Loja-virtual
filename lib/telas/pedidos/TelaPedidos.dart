import 'package:flutter/material.dart';
import 'package:loja_virtual/comum/CarrinhoVazio.dart';
import 'package:loja_virtual/comum/LoginCard.dart';
import 'package:loja_virtual/comum/drawer_comum/DrawerCustomizado.dart';
import 'package:loja_virtual/models/GerenciadorPedidos.dart';
import 'package:loja_virtual/telas/pedidos/componentes/ItemPedido.dart';
import 'package:provider/provider.dart';

class TelaPedidos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustomizado(),
      appBar: AppBar(
        title: Text('Meus Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<GerenciadorPedidos>(
        builder: (_, ordersManager, __) {
          if (ordersManager.user!.nome.isEmpty) {
            return LoginCard();
          }
          if (ordersManager.pedidos.isEmpty) {
            return CarrinhoVazio(
              titulo: 'Nenhuma compra encontrada!',
              iconData: Icons.border_clear,
            );
          }
          return ListView.builder(
            itemCount: ordersManager.pedidos.length,
            itemBuilder: (_, index) {
              return ItemPedido(ordersManager.pedidos.reversed.toList()[index]);
            },
          );
        },
      ),
    );
  }
}
