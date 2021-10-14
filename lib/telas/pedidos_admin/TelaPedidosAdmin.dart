import 'package:flutter/material.dart';
import 'package:loja_virtual/comum/CarrinhoVazio.dart';
import 'package:loja_virtual/comum/drawer_comum/DrawerCustomizado.dart';
import 'package:loja_virtual/models/GerenciadorPedidosAdmin.dart';
import 'package:loja_virtual/telas/pedidos/componentes/ItemPedido.dart';
import 'package:provider/provider.dart';

class TelaPedidosAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustomizado(),
      appBar: AppBar(
        title: Text('Todos os Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<GerenciadorPedidosAdmin>(
        builder: (_, ordersManager, __) {
          if (ordersManager.orders.isEmpty) {
            return CarrinhoVazio(
              titulo: 'Nenhuma venda realizada!',
              iconData: Icons.border_clear,
            );
          }
          return ListView.builder(
            itemCount: ordersManager.orders.length,
            itemBuilder: (_, index) {
              return ItemPedido(ordersManager.orders.reversed.toList()[index]);
            },
          );
        },
      ),
    );
  }
}
