import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/Loja.dart';

class GerenciadorLojas extends ChangeNotifier {
  GerenciadorLojas() {
    _carregarListaLojas();
    _iniciarTimer();
  }

  List<Loja> lojas = [];
  Timer? _timer;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _carregarListaLojas() async {
    final snapshot = await firestore.collection('lojas').get();

    lojas = snapshot.docs.map((e) => Loja.fromDocument(e)).toList();

    notifyListeners();
  }

  void _iniciarTimer(){
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkOpening();
    });
  }

  void _checkOpening(){
    for(final store in lojas)
      store.atualizarStatus();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }
}
