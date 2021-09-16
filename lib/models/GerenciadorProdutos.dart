import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/Produto.dart';

class GerenciadorProdutos extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore bancoDados = FirebaseFirestore.instance;

  List<Produto> todosProdutos = [];
  bool carregando = false;

  GerenciadorProdutos() {
    _carregarTodosProdutos();
  }

  Future<void> _carregarTodosProdutos() async {
    final QuerySnapshot snapProducts =
        await bancoDados.collection("produtos").get();

    todosProdutos = snapProducts.docs.map(
      (d) => Produto.fromDocumentSnapshot(d)).toList();

    notifyListeners();
  }
}
