import 'package:flutter/material.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/Pedido.dart';
import 'package:loja_virtual/telas/carrinho/componentes/ItemProdutoPedido.dart';
import 'package:loja_virtual/telas/pedidos/componentes/CancelarPedidoAlert.dart';
import 'package:loja_virtual/telas/pedidos/componentes/ExportarEnderecoAlert.dart';

class ItemPedido extends StatelessWidget {
  const ItemPedido(this.pedido, {this.showControls = false});

  final Pedido pedido;
  final bool showControls;

  @override
  Widget build(BuildContext context) {
    final primaryColor = temaPadrao.primaryColor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  pedido.formattedId,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                Text(
                  'R\$ ${pedido.preco!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
              pedido.statusText,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: pedido.status == Status.cancelado
                      ? Colors.red
                      : primaryColor,
                  fontSize: 14),
            )
          ],
        ),
        children: <Widget>[
          Column(
            children: pedido.itens!.map((e) {
              return ItemProdutoPedido(e);
            }).toList(),
          ),
          if (showControls && pedido.status != Status.cancelado)
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => CancelarPedidoAlert(pedido));
                    },
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: pedido.voltar,
                    child: Text(
                      'Recuar',
                    ),
                  ),
                  TextButton(
                    onPressed: pedido.avancar,
                    child: Text(
                      'Avançar',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) =>
                              ExportarEnderecoAlert(pedido.endereco!));
                    },
                    child: Text(
                      'Endereço',
                      style: TextStyle(color: temaPadrao.primaryColor),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
