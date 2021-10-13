import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/Pedido.dart';
import 'package:loja_virtual/models/Usuario.dart';

class GerenciadorPedidos extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Usuario? user;
  List<Pedido> pedidos = [];
  StreamSubscription? _subscription;

  void atualizarUsuario(Usuario user) {
    this.user = user;
    pedidos.clear();

    _subscription?.cancel();
    if (user.nome.isNotEmpty) {
      _listenToOrders();
    }
  }

  void _listenToOrders() {
    _subscription = firestore
        .collection('orders')
        .where('usuario', isEqualTo: user!.idUsuario)
        .snapshots()
        .listen((event) {
          pedidos.clear();
          for (final doc in event.docs) {
            pedidos.add(Pedido.fromDocument(doc));
          }
          print("Pedidos: "+pedidos.toString());
          notifyListeners();
        });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
