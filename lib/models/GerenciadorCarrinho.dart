import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/Carrinho.dart';
import 'package:loja_virtual/models/GerenciadorUsuarios.dart';
import 'package:loja_virtual/models/Produto.dart';
import 'package:loja_virtual/models/Usuario.dart';

class GerenciadorCarrinho extends ChangeNotifier {
  List<Carrinho> itens = [];

  Usuario? usuario;

  void atualizarUsuario(GerenciadorUsuarios gerenciadorUsuario) {
    usuario = gerenciadorUsuario.usuarioAtual;
    itens.clear();

    if (usuario != null) {
      _carregarItensCarrinho();
    }
  }

  Future<void> _carregarItensCarrinho() async {
    final QuerySnapshot carrinhoSnap = await usuario!.carrinhoReference.get();

    itens = carrinhoSnap.docs
        .map((d) => Carrinho.fromDocument(d)..addListener(_itemAtualizado))
        .toList();
  }

  void adicionarAoCarrinho(Produto produto) {
    try {
      final e = itens.firstWhere((p) => p.empilhavel(produto));
      e.incremente();
    } catch (e) {
      final carrinho = Carrinho.fromProduto(produto);
      carrinho.addListener(_itemAtualizado);
      itens.add(carrinho);
      usuario!.carrinhoReference
          .add(carrinho.toMap())
          .then((doc) => carrinho.id = doc.id);
    }
    notifyListeners();
  }

  void removerProdutoCarrinho(Carrinho produtoCarrinho) {
    itens.removeWhere((p) => p.id == produtoCarrinho.id);
    usuario!.carrinhoReference.doc(produtoCarrinho.id).delete();
    produtoCarrinho.removeListener(_itemAtualizado);
    notifyListeners();
  }

  void _itemAtualizado() {
    try {
      for (final carrinhoProduto in itens) {
        if (carrinhoProduto.quantidade == 0) {
          removerProdutoCarrinho(carrinhoProduto);
        } else {
          _atualizarCarrinho(carrinhoProduto);
        }
      }
    } catch (erro) {}
  }

  void _atualizarCarrinho(Carrinho carrinhoProduto) {
    usuario!.carrinhoReference
        .doc(carrinhoProduto.id)
        .update(carrinhoProduto.toMap());
  }
}
