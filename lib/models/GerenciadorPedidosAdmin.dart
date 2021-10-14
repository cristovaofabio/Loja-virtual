import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/Pedido.dart';
import 'package:flutter/cupertino.dart';

class GerenciadorPedidosAdmin extends ChangeNotifier {
  
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Pedido> orders = [];
  StreamSubscription? _subscription;

  void atualizarAdmin({bool? adminEnabled}){
    orders.clear();

    _subscription?.cancel();
    if(adminEnabled!){
      _listenToOrders();
    }
  }

  void _listenToOrders(){
    _subscription = firestore.collection('orders').snapshots().listen(
      (event) {
        orders.clear();
        for(final doc in event.docs){
          orders.add(Pedido.fromDocument(doc));
        }
        notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

}