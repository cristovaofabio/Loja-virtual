import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/Produto.dart';

class GerenciadorProdutos extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore bancoDados = FirebaseFirestore.instance;

  List<Produto> todosProdutos = [];
  bool carregando = false;

  String _pesquisa = '';

  String get pesquisa => _pesquisa;
  set pesquisa(String value) {
    _pesquisa = value;
    notifyListeners();
  }

  List<Produto> get filteredProducts {
    final List<Produto> filteredProducts = [];

    if (pesquisa.isEmpty) {
      //Casa a pesquisa esteja vazia, mostre todos os produtos:
      filteredProducts.addAll(todosProdutos);
    } else {
      filteredProducts.addAll(todosProdutos
          .where((p) => p.nome!.toLowerCase().contains(pesquisa.toLowerCase())));
    }
    return filteredProducts;
  }

  GerenciadorProdutos() {
    _carregarTodosProdutos();
  }

  Future<void> _carregarTodosProdutos() async {
    try {
      final QuerySnapshot snapProducts =
          await bancoDados.collection("produtos").get();

      todosProdutos = snapProducts.docs
          .map((d) => Produto.fromDocumentSnapshot(d))
          .toList();
    } catch (erro) {
      //todosProdutos = [];
    }

    notifyListeners();
  }

  Produto? encontrarProdutoPorId(String id) {
    Produto produtoEncontrado = Produto();
    try {
      produtoEncontrado = todosProdutos.firstWhere((produto) => produto.id == id);
      return produtoEncontrado;
    } catch (e) {
      return null;
    }
  }
}
