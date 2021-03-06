import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/Pedido.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/Usuario.dart';

class GerenciadorPedidosAdmin extends ChangeNotifier {
  
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<Pedido> _orders = [];
  StreamSubscription? _subscription;
  Usuario? filtrosUsuario;
  List<Status> filtroStatus = [Status.preparando];

  void atualizarAdmin({bool? adminEnabled}){
    _orders.clear();

    _subscription?.cancel();
    if(adminEnabled!){
      _listenToOrders();
    }
  }

  List<Pedido> get pedidosFiltrados {
    List<Pedido> output = _orders.reversed.toList();

    if(filtrosUsuario != null){
      output = output.where((o) => o.userId == filtrosUsuario!.idUsuario).toList();
    }

    return output.where((o) => filtroStatus.contains(o.status)).toList();
  }

  void _listenToOrders(){
    _subscription = firestore.collection('orders').snapshots().listen(
      (event) {
        for(final mudanca in event.docChanges){
          switch(mudanca.type){
            case DocumentChangeType.added:
              _orders.add(
                Pedido.fromDocument(mudanca.doc)
              );
              break;
            case DocumentChangeType.modified:
              final modPedido = _orders.firstWhere(
                  (ped) => ped.orderId == mudanca.doc.id); 
              modPedido.updateFromDocument(mudanca.doc);
              break;
            case DocumentChangeType.removed:
              debugPrint('Aconteceu algum problema!');
              break;
          }
        }
        notifyListeners();
    });
  }

  void setFiltrosUsuario(Usuario? user){
    filtrosUsuario = user;
    notifyListeners();
  }

  void setfiltroStatus({required Status status, required bool enabled}){
    if(enabled){
      filtroStatus.add(status);
    } else {
      filtroStatus.remove(status);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

}