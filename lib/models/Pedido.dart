import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/Carrinho.dart';
import 'package:loja_virtual/models/Endereco.dart';
import 'package:loja_virtual/models/GerenciadorCarrinho.dart';

class Pedido {
  String? orderId;
  List<Carrinho>? itens;
  num? preco;
  String? userId;
  Endereco? endereco;
  Timestamp? date;

  Pedido.fromCartManager(GerenciadorCarrinho cartManager) {
    itens = List.from(cartManager.itens);
    preco = cartManager.precoTotal;
    userId = cartManager.usuario!.idUsuario;
    endereco = cartManager.endereco!;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> salvar() async {
    firestore.collection('orders').doc(orderId).set({
      'itens'     : itens!.map((e) => e.toOrderItemMap()).toList(),
      'preco'     : preco,
      'usuario'   : userId,
      'endereco'  : endereco!.toMap(),
    });
  }
}
