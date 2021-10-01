import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/TamanhoItem.dart';

class Produto extends ChangeNotifier {
  String? id;
  String? nome="";
  String? descricao="";
  List<String>? imagens;
  List<TamanhoItem>? tamanhos;
  List<dynamic>? novasImagens;

  Produto({this.id, this.nome, this.descricao, this.imagens, this.tamanhos}) {
    imagens = imagens ?? [];
    tamanhos = tamanhos ?? [];
  }

  TamanhoItem _tamanhoSelecionado = TamanhoItem();

  Produto clone() {
    return Produto(
      id: id,
      nome: nome,
      descricao: descricao,
      imagens: List.from(imagens!),
      tamanhos: tamanhos!.map((size) => size.clone()).toList(),
    );
  }

  TamanhoItem get tamanhoSelecionado => _tamanhoSelecionado;
  set tamanhoSelecionado(TamanhoItem value) {
    _tamanhoSelecionado = value;
    notifyListeners();
  }

  int get totalEstoque {
    int estoque = 0;
    for (final tamanho in tamanhos!) {
      estoque += tamanho.estoque!;
    }
    return estoque;
  }

  bool get temEstoque {
    return totalEstoque > 0;
  }

  num get precoBase {
    num menor = double.infinity;
    for (final tamanho in tamanhos!) {
      if (tamanho.preco! < menor && tamanho.hasStock) menor = tamanho.preco!;
    }
    return menor;
  }

  TamanhoItem encontrarTamanho(String nome) {
    try {
      return tamanhos!.firstWhere((s) => s.nome == nome);
    } catch (e) {
      TamanhoItem tamanhoItem = TamanhoItem();
      tamanhoItem.nome = "";
      tamanhoItem.preco = 0;
      tamanhoItem.estoque = 0;
      return tamanhoItem;
    }
  }

  Produto.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    this.id = documentSnapshot.id;
    this.nome = documentSnapshot["nome"];
    this.descricao = documentSnapshot["descricao"];
    this.imagens = List<String>.from(documentSnapshot["imagens"]);
    this.tamanhos = (documentSnapshot["tamanhos"] as List<dynamic>)
        .map((s) => TamanhoItem.fromMap(s as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "nome": this.nome,
      "descricao": this.descricao,
      "imagens": this.imagens
    };
    return map;
  }

  @override
  String toString() {
    return 'Produto{id: $id, nome: $nome, descricao: $descricao, imagems: $imagens, tamanhos: $tamanhos, novasImagens: $novasImagens}';
  }
}
