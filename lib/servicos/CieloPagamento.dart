import 'package:cloud_functions/cloud_functions.dart';
import 'package:loja_virtual/models/CartaoCredito.dart';
import 'package:loja_virtual/models/Usuario.dart';

class CieloPagamento {
  final FirebaseFunctions functions = FirebaseFunctions.instance;

  Future<void> autorizar({
    required CartaoCreditoModel creditCard,
    required num price,
    required String orderId,
    required Usuario user,
  }) async {

    final Map<String, dynamic> dataSale = {
      'merchantOrderId': orderId,
      'amount': (price * 100).toInt(),
      'softDescriptor': 'Loja virtual', //só pode ter no máximo 13 caracteres
      'installments': 1, //quantidade de parcelas
      'creditCard': creditCard.toJson(),
      'cpf': user.cpf,
      'paymentType': 'CreditCard',
    };

    final HttpsCallable callable = functions.httpsCallable('autorizarCartaoCredito');
    final response = await callable.call(dataSale);
    print(response.data);
  }
}
