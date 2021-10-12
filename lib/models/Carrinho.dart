import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/Produto.dart';
import 'package:loja_virtual/models/TamanhoItem.dart';

class Carrinho extends ChangeNotifier {
  String? id; //Id do carrinho
  late String idProduto;
  late int quantidade;
  late String tamanho;
  Produto? _produto;
  num? precoFixo;

  Produto? get produto => _produto;
  set produto(Produto? value){
     _produto = value;
    notifyListeners();
  }

  FirebaseFirestore bancoDados = FirebaseFirestore.instance;

  TamanhoItem get itemTamanho {
    if (produto == null) {
      TamanhoItem tamanhoItem = TamanhoItem();
      tamanhoItem.nome = "";
      tamanhoItem.preco = 0;
      tamanhoItem.estoque = 0;
      return tamanhoItem;
    }
    return produto!.encontrarTamanho(tamanho);
  }

  num get precoUnitario {
    if (produto == null) return 0;
    return itemTamanho.preco ?? 0;
  }

  num get precoTotal => precoUnitario * quantidade;

  Map<String, dynamic> toMap() {
    return {
      'idProduto': this.idProduto,
      'quantidade': this.quantidade,
      'tamanho': this.tamanho,
    };
  }

  bool get temEstoque {
    final size = itemTamanho;
    if (size.nome!.isEmpty) {
      return false;
    }
    return size.estoque! >= quantidade;
  }

  bool empilhavel(Produto produto) {
    return produto.id == this.idProduto &&
        produto.tamanhoSelecionado.nome == this.tamanho;
  }

  void incremente() {
    this.quantidade++;
    notifyListeners();
  }

  void decremente() {
    this.quantidade--;
    notifyListeners();
  }

  Carrinho.fromProduto(this._produto) {
    this.idProduto = produto!.id!;
    this.quantidade = 1;
    this.tamanho = produto!.tamanhoSelecionado.nome!;
  }

  Carrinho.fromDocument(DocumentSnapshot document) {
    this.id = document.id;
    this.idProduto = document['idProduto'] as String;
    this.quantidade = document['quantidade'] as int;
    this.tamanho = document['tamanho'] as String;

    bancoDados.doc('produtos/${this.idProduto}').get().then(
      (doc) {
        produto = Produto.fromDocumentSnapshot(doc);
    });
  }

  Map<String, dynamic> toOrderItemMap(){
    return {
      'idProduto'   : idProduto,
      'quantidade'  : quantidade,
      'tamanho'     : tamanho,
      'precoFixo'   : precoFixo ?? precoUnitario,
    };
  }
}
