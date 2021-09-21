import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/Carrinho.dart';
import 'package:loja_virtual/models/GerenciadorUsuarios.dart';
import 'package:loja_virtual/models/Produto.dart';
import 'package:loja_virtual/models/Usuario.dart';

class GerenciadorCarrinho {
  List<Carrinho> itens = [];

  Usuario? usuario;

  void atualizarUsuario(GerenciadorUsuarios gerenciadorUsuario){
    usuario = gerenciadorUsuario.usuarioAtual;
    itens.clear();

    if(usuario != null){
      _carregarItensCarrinho();
    }
  }

  Future<void> _carregarItensCarrinho() async {

    final QuerySnapshot carrinhoSnap = await usuario!.carrinhoReference.get();

    itens = carrinhoSnap.docs.map((d) => Carrinho.fromDocument(d)).toList();
  }

  void adicionarAoCarrinho(Produto produto) {
    itens.add(Carrinho.fromProduto(produto));
  }
}
