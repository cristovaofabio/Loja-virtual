import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/Carrinho.dart';
import 'package:loja_virtual/models/Endereco.dart';
import 'package:loja_virtual/models/GerenciadorCarrinho.dart';

enum Status { cancelado, preparando, transportando, entregue }

class Pedido {
  String? orderId;
  List<Carrinho>? itens;
  num? preco;
  String? userId;
  Endereco? endereco;
  Timestamp? date;
  late Status status;

  String get formattedId => '#${orderId!.padLeft(6, '0')}';

  String get statusText => getStatusText(status);

  static String getStatusText(Status status) {
    switch (status) {
      case Status.cancelado:
        return 'Cancelado';
      case Status.preparando:
        return 'Em preparação';
      case Status.transportando:
        return 'Em transporte';
      case Status.entregue:
        return 'Entregue';
      default:
        return '';
    }
  }

  Pedido.fromCartManager(GerenciadorCarrinho cartManager) {
    itens = List.from(cartManager.itens);
    preco = cartManager.precoTotal;
    userId = cartManager.usuario!.idUsuario;
    endereco = cartManager.endereco!;
    status = Status.preparando;
  }

  Pedido.fromDocument(DocumentSnapshot doc) {
    orderId = doc.id;

    itens = (doc['itens'] as List<dynamic>).map((e) {
      return Carrinho.fromMap(e as Map<String, dynamic>);
    }).toList();

    preco = doc['preco'] as num;
    userId = doc['usuario'] as String;
    endereco = Endereco.fromMap(doc['endereco'] as Map<String, dynamic>);
    date = doc['date'] as Timestamp;
    status = Status.values[doc['status'] as int];
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> salvar() async {
    firestore.collection('orders').doc(orderId).set({
      'itens'   : itens!.map((e) => e.toOrderItemMap()).toList(),
      'preco'   : preco,
      'usuario' : userId,
      'endereco': endereco!.toMap(),
      'status'  : status.index,
      'date'    : Timestamp.now(),
    });
  }

  @override
  String toString() {
    return 'Order{firestore: $firestore, pedidoID: $orderId, itens: $itens, preco: $preco, userId: $userId, endereco: $endereco, data: $date}';
  }
}
