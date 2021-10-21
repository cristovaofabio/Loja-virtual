import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/Loja.dart';

class GerenciadorLojas extends ChangeNotifier {
  GerenciadorLojas() {
    _carregarListaLojas();
  }

  List<Loja> lojas = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _carregarListaLojas() async {
    final snapshot = await firestore.collection('lojas').get();

    lojas = snapshot.docs.map((e) => Loja.fromDocument(e)).toList();

    notifyListeners();
  }
}
