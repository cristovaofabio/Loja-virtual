import 'package:cloud_firestore/cloud_firestore.dart';

class Produto{
  late String id;
  late String nome;
  late String descricao;
  late List<String> imagens;

  Produto();

  Produto.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot.id;
    this.nome = documentSnapshot["nome"];
    this.descricao = documentSnapshot["descricao"];
    this.imagens = List<String>.from(documentSnapshot["imagens"]);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id"        : this.id,
      "nome"      : this.nome,
      "descricao" : this.descricao,
      "imagens"   : this.imagens
    };
    return map;
  }

}