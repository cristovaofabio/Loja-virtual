import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/GerenciadorCarrinho.dart';

class GerenciadorCheckOut extends ChangeNotifier {
  GerenciadorCarrinho? gerenciadorCarrinho;
  final FirebaseFirestore bancoDados = FirebaseFirestore.instance;

  // ignore: use_setters_to_change_properties
  void updateCart(GerenciadorCarrinho gerenciadorCarrinho) {
    this.gerenciadorCarrinho = gerenciadorCarrinho;
  }

  void checkout() {
    _decrementStock();

    _getOrderId().then((value) => print(value));
  }

  Future<int> _getOrderId() async {
    final ref = bancoDados.doc('aux/contador');

    //A transacao irá tentar passar pelo "try" 5 vezes, ou seja,
    //irá verifica, por 5 vezes, se existe alguma colisão.
    try {
      //trabalhando com transacoes:
      final result = await bancoDados.runTransaction((transacao) async {
        final doc = await transacao.get(ref);
        final orderId = doc['atual'] as int;
        await transacao.update(ref, {'atual': orderId + 1});
        return {'orderId': orderId};
      });
      return result['orderId'] as int;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gerar número do pedido');
    }
  }

  void _decrementStock() {
    // 1. Ler todos os estoques 3xM
    // 2. Decremento localmente os estoques 2xM
    // 3. Salvar os estoques no firebase 2xM
  }
}
