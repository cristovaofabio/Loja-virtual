import 'package:flutter/material.dart';
import 'package:loja_virtual/models/Pedido.dart';

class CancelarPedidoAlert extends StatelessWidget {
  CancelarPedidoAlert(this.pedido);

  final Pedido pedido;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cancelar ${pedido.formattedId}?'),
      content: const Text('Esta ação não poderá ser defeita!'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            pedido.cancelar();
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancelar Pedido',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
