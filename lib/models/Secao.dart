import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/SecaoItem.dart';

class Secao {
  late String nome;
  late String tipo;
  late List<SecaoItem> itens;

  Secao.fromDocument(DocumentSnapshot document) {
    this.nome = document["nome"] as String;
    this.tipo = document["tipo"] as String;
    this.itens = (document["itens"] as List<dynamic>).map(
 (s) =>SecaoItem.fromMap(s as Map<String, dynamic>)).toList();
  }

  @override
  String toString() {
    return 'Secao{nome: $nome, tipo: $tipo, itens: $itens}';
  }
}
