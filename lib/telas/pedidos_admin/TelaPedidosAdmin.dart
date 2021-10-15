import 'package:flutter/material.dart';
import 'package:loja_virtual/comum/CarrinhoVazio.dart';
import 'package:loja_virtual/comum/drawer_comum/DrawerCustomizado.dart';
import 'package:loja_virtual/models/GerenciadorPedidosAdmin.dart';
import 'package:loja_virtual/telas/carrinho/componentes/IconeBotaoCustomizado.dart';
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
          final pedidosFiltros = ordersManager.pedidosFiltrados;

          return Column(
            children: <Widget>[
              if (ordersManager.filtrosUsuario != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 2),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Pedidos de ${ordersManager.filtrosUsuario!.nome}',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconeBotaoCustomizado(
                        icone: Icons.close,
                        cor: Colors.white,
                        onTap: () {
                          ordersManager.setFiltrosUsuario(null);
                        },
                      ),
                    ],
                  ),
                ),
              if (pedidosFiltros.isEmpty)
                Expanded(
                  child: CarrinhoVazio(
                    titulo: 'Nenhuma venda realizada!',
                    iconData: Icons.border_clear,
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: pedidosFiltros.length,
                    itemBuilder: (_, index) {
                      return ItemPedido(
                        pedidosFiltros[index],
                        showControls: true,
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
