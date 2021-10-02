import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/Secao.dart';

class GerenciadorHome extends ChangeNotifier{
  final FirebaseFirestore bancoDados = FirebaseFirestore.instance;
  List<Secao> secoes = [];
  bool editando = false;

  GerenciadorHome() {
    _carregarSecoes();
  }

  Future<void> _carregarSecoes() async {
    bancoDados.collection('home').snapshots().listen((snapshot) {
      secoes.clear();
      for (final DocumentSnapshot document in snapshot.docs) {
        secoes.add(Secao.fromDocument(document));
      }
      notifyListeners();
    });
  }

  void entrarEditando(){
    editando = true;
    notifyListeners();
  }

  void salvarEditando(){
    editando = false;
    notifyListeners();
  }

  void discartarEditando(){
    editando = false;
    notifyListeners();
  }
}
