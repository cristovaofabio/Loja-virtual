import 'package:flutter/material.dart';
import 'package:loja_virtual/comum/CarrinhoVazio.dart';
import 'package:loja_virtual/comum/drawer_comum/DrawerCustomizado.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/GerenciadorPedidosAdmin.dart';
import 'package:loja_virtual/models/Pedido.dart';
import 'package:loja_virtual/telas/carrinho/componentes/IconeBotaoCustomizado.dart';
import 'package:loja_virtual/telas/pedidos/componentes/ItemPedido.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TelaPedidosAdmin extends StatefulWidget {
  @override
  _TelaPedidosAdminState createState() => _TelaPedidosAdminState();
}

class _TelaPedidosAdminState extends State<TelaPedidosAdmin> {
  final PanelController panelController = PanelController();

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

          return SlidingUpPanel(
            controller: panelController,
            body: Column(
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
                SizedBox(height: 120),
              ],
            ),
            minHeight: 40,
            maxHeight: 250,
            panel: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (panelController.isPanelClosed) {
                      panelController.open();
                    } else {
                      panelController.close();
                    }
                  },
                  child: Container(
                    height: 40,
                    color: Colors.blueGrey,
                    alignment: Alignment.center,
                    child: Text(
                      'Filtros',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: Status.values.map((s) {
                      return CheckboxListTile(
                        title: Text(Pedido.getStatusText(s)),
                        dense: true,
                        activeColor: temaPadrao.primaryColor,
                        value: ordersManager.filtroStatus.contains(s),
                        onChanged: (v) {
                          ordersManager.setfiltroStatus(
                            status: s,
                            enabled: v as bool,
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
