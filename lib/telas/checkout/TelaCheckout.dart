import 'package:flutter/material.dart';
import 'package:loja_virtual/comum/PrecoCarrinho.dart';
import 'package:loja_virtual/models/GerenciadorCarrinho.dart';
import 'package:loja_virtual/models/GerenciadorCheckOut.dart';
import 'package:provider/provider.dart';

class TelaCheckout extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<GerenciadorCarrinho,
        GerenciadorCheckOut>(
      create: (_) => GerenciadorCheckOut(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager!..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Pagamento'),
          centerTitle: true,
        ),
        body: Consumer<GerenciadorCheckOut>(
          builder: (_, gerenciadorCheckOut, __) {
            if (gerenciadorCheckOut.carregando) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Processando seu pagamento...',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16),
                    )
                  ],
                ),
              );
            } else {
              return ListView(
                children: <Widget>[
                  PrecoCarrinho(
                    textoBotao: 'Finalizar Pedido',
                    onPressed: () {
                      gerenciadorCheckOut.checkout(onStockFail: (e) {
                        Navigator.of(context).popUntil(
                            (route) => route.settings.name == '/carrinho');
                      }, onSuccess: (pedido) {
                        Navigator.of(context).popUntil(
                            (route) => route.settings.name == '/');
                        Navigator.of(context)
                            .pushNamed('/confirmacao', arguments: pedido);
                      });
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
