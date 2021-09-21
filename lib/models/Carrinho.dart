import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/Produto.dart';
import 'package:loja_virtual/models/TamanhoItem.dart';

class Carrinho {
  late String idProduto;
  late int quantidade;
  late String tamanho;
  Produto? produto;

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

  Carrinho.fromProduto(this.produto) {
    this.idProduto = this.produto!.id;
    this.quantidade = 1;
    this.tamanho = this.produto!.tamanhoSelecionado.nome!;
  }

  Carrinho.fromDocument(DocumentSnapshot document) {
    this.idProduto = document['idProduto'] as String;
    this.quantidade = document['quantidade'] as int;
    this.tamanho = document['tamanho'] as String;

    bancoDados
        .doc('produtos/${this.idProduto}')
        .get()
        .then((doc) => produto = Produto.fromDocumentSnapshot(doc));
  }
}
