import 'package:flutter/material.dart';
import 'package:loja_virtual/comum/PrecoCarrinho.dart';
import 'package:loja_virtual/models/GerenciadorCarrinho.dart';
import 'package:loja_virtual/models/GerenciadorCheckOut.dart';
import 'package:provider/provider.dart';

class TelaCheckout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<GerenciadorCarrinho,
        GerenciadorCheckOut>(
      create: (_) => GerenciadorCheckOut(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager!..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pagamento'),
          centerTitle: true,
        ),
        body: Consumer<GerenciadorCheckOut>(
          builder: (_, gerenciadorCheckOut, __) {
            return ListView(
              children: <Widget>[
                PrecoCarrinho(
                  textoBotao: 'Finalizar Pedido',
                  onPressed: () {
                    gerenciadorCheckOut.checkout();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
