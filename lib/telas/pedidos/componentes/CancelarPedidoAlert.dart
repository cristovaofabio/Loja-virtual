import 'package:flutter/material.dart';
import 'package:loja_virtual/models/Pedido.dart';

class CancelarPedidoAlert extends StatefulWidget {
  CancelarPedidoAlert(this.pedido);

  final Pedido pedido;

  @override
  _CancelarPedidoAlertState createState() => _CancelarPedidoAlertState();
}

class _CancelarPedidoAlertState extends State<CancelarPedidoAlert> {
  bool carregando = false;
  String error = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(
          false), //quando o botao voltar é clicado, o alertDialog não é fechado.
      child: AlertDialog(
        title: Text('Cancelar ${widget.pedido.formattedId}?'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              carregando
                  ? "Cancelando..."
                  : 'Esta ação não poderá ser defeita!',
            ),
            if (error.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  error,
                  style: TextStyle(color: Colors.red),
                ),
              )
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: !carregando
                ? () {
                    Navigator.of(context).pop();
                  }
                : null,
            child: Text(
              'Voltar',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: !carregando
                ? () async {
                    setState(() {
                      carregando = true;
                    });
                    try {
                      await widget.pedido.cancelar().then((_) {
                        Navigator.of(context).pop();
                      });
                    } catch (e) {
                      setState(() {
                        carregando = false;
                        error = e.toString();
                      });
                      Navigator.of(context).pop();
                    }
                  }
                : null,
            child: Text(
              'Cancelar Pedido',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
