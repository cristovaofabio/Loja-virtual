import 'dart:collection';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/CartaoCredito.dart';
import 'package:loja_virtual/models/Usuario.dart';

class CieloPagamento {
  final FirebaseFunctions functions = FirebaseFunctions.instance;

  Future<String> autorizar({
    required CartaoCreditoModel creditCard,
    required num price,
    required String orderId,
    required Usuario user,
  }) async {
    try {
      //os dados precisam ser enviados como um mapa para a funcao que ira processa-los
      final Map<String, dynamic> dataSale = {
        'merchantOrderId': orderId,
        'amount': (price * 100).toInt(),
        'softDescriptor': 'Loja virtual', //só pode ter no máximo 13 caracteres
        'installments': 1, //quantidade de parcelas
        'creditCard': creditCard
            .toJson(), //de acordo com a documentao da cielo, o creditCard é um mapa
        'cpf': user.cpf,
        'paymentType': 'CreditCard',
      };

      final HttpsCallable callable =
          functions.httpsCallable('autorizarCartaoCredito');
      final response = await callable.call(dataSale);

      final data = Map<String, dynamic>.from(response.data as LinkedHashMap);
      if (data['success'] as bool) {
        return data['paymentId'] as String;
      } else {
        debugPrint('${data['error']['message']}');
        return Future.error(data['error']['message']);
      }
    } catch (erro) {
      debugPrint('$erro');
      return Future.error('Falha ao processar transação. Tente novamente.');
    }
  }

  //esta funcao serve para que a cobrança seja efetivada ao portador do cartão.
  Future<void> capture(String payId) async {
    //o id do pagamento precisa ser enviado como um mapa para a funcao que ira processa-la
    final Map<String, dynamic> captureData = {'payId': payId};

    final HttpsCallable callable = functions.httpsCallable('capturarCartaoCredito');
    final response = await callable.call(captureData);

    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

    if (data['success'] as bool) {
      return;
    } else {
      debugPrint('${data['error']['message']}');
      return Future.error(data['error']['message']);
    }
  }

  Future<void> cancelamento(String payId) async {
    //o id do pagamento precisa ser enviado como um mapa para a funcao que ira processa-la
    final Map<String, dynamic> cancelData = {'payId': payId};

    final HttpsCallable callable = functions.httpsCallable('cancelarCompraCartaoCredito');
    final response = await callable.call(cancelData);

    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

    if (data['success'] as bool) {
      debugPrint('Cancelamento realizado com sucesso');
      return;
    } else {
      debugPrint('${data['error']['message']}');
      return Future.error(data['error']['message']);
    }
  }
}
