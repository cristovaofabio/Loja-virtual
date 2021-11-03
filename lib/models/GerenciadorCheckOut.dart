import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/CartaoCredito.dart';
import 'package:loja_virtual/models/GerenciadorCarrinho.dart';
import 'package:loja_virtual/models/Pedido.dart';
import 'package:loja_virtual/models/Produto.dart';
import 'package:loja_virtual/servicos/CieloPagamento.dart';

class GerenciadorCheckOut extends ChangeNotifier {
  GerenciadorCarrinho? gerenciadorCarrinho;
  final FirebaseFirestore bancoDados = FirebaseFirestore.instance;
  final CieloPagamento cieloPagamento = CieloPagamento();

  bool _carregando = false;
  bool get carregando => _carregando;
  set carregando(bool value) {
    _carregando = value;
    notifyListeners();
  }

  // ignore: use_setters_to_change_properties
  void updateCart(GerenciadorCarrinho gerenciadorCarrinho) {
    this.gerenciadorCarrinho = gerenciadorCarrinho;
  }

  Future<void> checkout({
    required CartaoCreditoModel cartaoCredito,
    Function? onStockFail,
    Function? onSuccess,
    Function? onPayFail,
  }) async {
    carregando = true;
    final orderId = await _getOrderId();

    try {
      String payId = await cieloPagamento.autorizar(
          creditCard: cartaoCredito,
          price: gerenciadorCarrinho!.precoTotal,
          orderId: orderId.toString(),
          user: gerenciadorCarrinho!.usuario!);

      debugPrint('success $payId');
    } catch (erro) {
      onPayFail!(erro);
      carregando = false;
      return;
    }

    try {
      await _decrementarEstoque();
    } catch (erro) {
      onStockFail!(erro);
      carregando = false;
      return;
    }

    final order = Pedido.fromCartManager(gerenciadorCarrinho!);
    order.orderId = orderId.toString();

    await order.salvar();

    gerenciadorCarrinho!.limpar();

    onSuccess!(order);
    carregando = false;
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

  Future<void> _decrementarEstoque() {
    return bancoDados.runTransaction((tx) async {
      final List<Produto> produtosParaAtualizar = [];
      final List<Produto> produtosSemEstoque = [];

      for (final cartProduct in gerenciadorCarrinho!.itens) {
        Produto produto;

        if (produtosParaAtualizar.any((p) => p.id == cartProduct.idProduto)) {
          produto = produtosParaAtualizar
              .firstWhere((p) => p.id == cartProduct.idProduto);
        } else {
          final doc =
              await tx.get(bancoDados.doc('produtos/${cartProduct.idProduto}'));
          produto = Produto.fromDocumentSnapshot(doc);
        }

        cartProduct.produto = produto;

        final size = produto.encontrarTamanho(cartProduct.tamanho);
        if (size.estoque! - cartProduct.quantidade < 0) {
          produtosSemEstoque.add(produto);
        } else {
          size.estoque = size.estoque! - cartProduct.quantidade;
          produtosParaAtualizar.add(produto);
        }
      }

      if (produtosSemEstoque.isNotEmpty) {
        return Future.error(
            '${produtosSemEstoque.length} produtos sem estoque');
      }

      for (final product in produtosParaAtualizar) {
        tx.update(bancoDados.doc('produtos/${product.id}'),
            {'tamanhos': product.exportTamanhoList()});
      }
    });
  }
}
