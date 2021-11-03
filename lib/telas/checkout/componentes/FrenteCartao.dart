import 'package:brasil_fields/brasil_fields.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/CartaoCredito.dart';
import 'package:loja_virtual/telas/checkout/componentes/TextoCartao.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class FrenteCartao extends StatelessWidget {
  FrenteCartao(
      {required this.cartaoCredito,
      required this.numberFocus,
      required this.dateFocus,
      required this.nameFocus,
      required this.finished});

  final MaskTextInputFormatter dateFormatter = MaskTextInputFormatter(
      mask: '!#/####', filter: {'#': RegExp('[0-9]'), '!': RegExp('[0-1]')});

  final VoidCallback finished;

  final FocusNode numberFocus;
  final FocusNode dateFocus;
  final FocusNode nameFocus;
  final CartaoCreditoModel cartaoCredito; //cartao criado na tela de checkout e passado para a tela do cartao de crédito

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 16,
      child: Container(
        height: 200,
        color: Colors.grey[700],
        padding: const EdgeInsets.all(24),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextoCartao(
                    initialValue: cartaoCredito.numero,
                    titulo: 'Número',
                    hint: '0000 0000 0000 0000',
                    textInputType: TextInputType.number,
                    bold: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CartaoBancarioInputFormatter(),
                    ],
                    validator: (number) {
                      if (number!.length != 19)
                        return 'Inválido';
                      else if (detectCCType(number) == CreditCardType.unknown)
                        return 'Inválido';
                      return null;
                    },
                    onSubmitted: (_) {
                      dateFocus.requestFocus();
                    },
                    focusNode: numberFocus,
                    onSaved:(numero){
                      cartaoCredito.setNumero(numero!);
                    },
                  ),
                  TextoCartao(
                    initialValue: cartaoCredito.expirationDate,
                    titulo: 'Validade',
                    hint: '11/2027',
                    textInputType: TextInputType.number,
                    inputFormatters: [dateFormatter],
                    validator: (date) {
                      if (date!.length != 7) return 'Inválido';
                      return null;
                    },
                    onSubmitted: (_) {
                      nameFocus.requestFocus();
                    },
                    onSaved: (validade){
                      cartaoCredito.setExpirationDate(validade!);
                    },
                    focusNode: dateFocus,
                  ),
                  TextoCartao(
                    initialValue: cartaoCredito.nomeTitular,
                    titulo: 'Titular',
                    hint: 'João da Silva',
                    textInputType: TextInputType.text,
                    bold: true,
                    validator: (name) {
                      if (name!.isEmpty) return 'Inválido';
                      return null;
                    },
                    onSubmitted: (_) {
                      finished();
                    },
                    onSaved: (titular){
                      cartaoCredito.setNome(titular!);
                    },
                    focusNode: nameFocus,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
