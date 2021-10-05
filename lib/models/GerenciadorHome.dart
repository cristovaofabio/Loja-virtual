import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/Secao.dart';

class GerenciadorHome extends ChangeNotifier{
  final FirebaseFirestore bancoDados = FirebaseFirestore.instance;
  final List<Secao> _secoes = [];
  List<Secao> _editandoSecoes = [];
  bool editando = false;
  bool carregando = false;

  GerenciadorHome() {
    _carregarSecoes();
  }

  Future<void> _carregarSecoes() async {
    bancoDados.collection('home').orderBy('pos').snapshots().listen((snapshot) {
      _secoes.clear();
      for (final DocumentSnapshot document in snapshot.docs) {
        _secoes.add(Secao.fromDocument(document));
      }
      notifyListeners();
    });
  }

  void addSecao(Secao secao){
    _editandoSecoes.add(secao);
    notifyListeners();
  }

  void removerSecao(Secao secao){
    _editandoSecoes.remove(secao);
    notifyListeners();
  }

  List<Secao> get secoes {
    if(editando)
      return _editandoSecoes;
    else
      return _secoes;
  }

  void entrarEditando(){
    editando = true;
    _editandoSecoes = _secoes.map((secoes) => secoes.clone()).toList();
    notifyListeners();
  }

  Future<void> salvarEditando() async{
    bool valid = true;
    for(final secao in _editandoSecoes){
      if(secao.valid()==false) valid = false;
    }
    if(valid==false) return;

    carregando = true;
    notifyListeners();

    int contador = 0;
    for(final section in _editandoSecoes){
      await section.save(contador);
      contador++;
    }

    for(final section in List.from(_secoes)){
      if(!_editandoSecoes.any((element) => element.id == section.id)){
        await section.delete();
      }
    }

    if(contador==_editandoSecoes.length){
      carregando = false;
      editando = false;
      notifyListeners();
    }
  }

  void discartarEditando(){
    editando = false;
    notifyListeners();
  }
}
