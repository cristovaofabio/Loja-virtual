import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/Carrinho.dart';
import 'package:loja_virtual/models/GerenciadorUsuarios.dart';
import 'package:loja_virtual/models/Produto.dart';
import 'package:loja_virtual/models/Usuario.dart';

class GerenciadorCarrinho extends ChangeNotifier {
  List<Carrinho> itens = [];
  Usuario? usuario;
  num precoProdutos = 0.0;

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
      _itemAtualizado();
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
      precoProdutos = 0.0;
      for (int i = 0; i<itens.length; i++) {
        final carrinhoProduto = itens[i];

        if (carrinhoProduto.quantidade == 0) {
          removerProdutoCarrinho(carrinhoProduto);
          i--;
          continue;
        } else {
          precoProdutos += carrinhoProduto.precoTotal;
          _atualizarCarrinho(carrinhoProduto);
        }
      }
    } catch (erro) {}

    notifyListeners();
  }

  void _atualizarCarrinho(Carrinho carrinhoProduto) {
    if(carrinhoProduto.id!=null){
       usuario!.carrinhoReference
        .doc(carrinhoProduto.id)
        .update(carrinhoProduto.toMap());
    }
  }

  bool get carrinhoValido {
    for(final carrinhoProduto in itens){
      if(!carrinhoProduto.temEstoque) return false;
    }
    return true;
  }
}
