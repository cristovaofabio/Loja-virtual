import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class CartaoCreditoModel {
  String numero="";
  String nomeTitular="";
  String expirationDate="";
  String securityCode="";
  String marca="";

  void setNome(String nome) => nomeTitular = nome;
  void setExpirationDate(String date) => expirationDate = date;
  void setCVV(String cvv) => securityCode = cvv;
  void setNumero(String numero) {
    this.numero = numero;
    marca = detectCCType(numero.replaceAll(' ', '')).toString().toUpperCase().split(".").last;
    /* Exemplo: converte CreditCardType.mastercard para isso MASTERCARD*/
  }

  Map<String, dynamic> toJson() {
    return {
      'cardNumber': numero.replaceAll(' ', ''),
      'holder': nomeTitular,
      'expirationDate': expirationDate,
      'securityCode': securityCode,
      'brand': marca,
    };
  }

  @override
  String toString() {
    return 'CreditCard{number: $numero, holder: $nomeTitular, expirationDate: $expirationDate, securityCode: $securityCode, brand: $marca}';
  }
}
