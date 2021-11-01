import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class CartaoCreditoModel {
  late String numero;
  late String nomeTitular;
  late String expirationDate;
  late String securityCode;
  late String marca;

  void setNome(String nome) => nomeTitular = nome;
  void setExpirationDate(String date) => expirationDate = date;
  void setCVV(String cvv) => securityCode = cvv;
  void setNumero(String numero) {
    this.numero = numero;
    marca = detectCCType(numero.replaceAll(' ', '')).toString();
  }

  @override
  String toString() {
    return 'CreditCard{number: $numero, holder: $nomeTitular, expirationDate: $expirationDate, securityCode: $securityCode, brand: $marca}';
  }
}
