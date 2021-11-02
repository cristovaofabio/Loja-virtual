import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:loja_virtual/models/CartaoCredito.dart';
import 'package:loja_virtual/telas/checkout/componentes/FrenteCartao.dart';
import 'package:loja_virtual/telas/checkout/componentes/VersoCartao.dart';

class CartaoCredito extends StatefulWidget {

  final CartaoCreditoModel cartaoCredito; //cartao criado na tela de checkout
  
  const CartaoCredito(this.cartaoCredito);

  @override
  _CartaoCreditoState createState() => _CartaoCreditoState();
}

class _CartaoCreditoState extends State<CartaoCredito> {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  final FocusNode numberFocus = FocusNode();
  final FocusNode dateFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode cvvFocus = FocusNode();
  
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
        keyboardBarColor: Colors.grey[200],
        actions: [
          KeyboardActionsItem(focusNode: numberFocus, displayDoneButton: false),
          KeyboardActionsItem(focusNode: dateFocus, displayDoneButton: false),
          KeyboardActionsItem(focusNode: nameFocus, toolbarButtons: [
            (_) {
              return GestureDetector(
                onTap: () {
                  cardKey.currentState!.toggleCard();
                  cvvFocus.requestFocus();
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Text('CONTINUAR'),
                ),
              );
            }
          ]),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      config: _buildConfig(context),
      autoScroll: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            FlipCard(
              key: cardKey,
              direction: FlipDirection.HORIZONTAL,
              speed: 700,
              flipOnTouch: false,
              front: FrenteCartao(
                cartaoCredito: widget.cartaoCredito, //cartao criado na tela de checkout
                numberFocus: numberFocus,
                dateFocus: dateFocus,
                nameFocus: nameFocus,
                finished: () {
                  cardKey.currentState!.toggleCard(); //utilizado para rotacionar o cartao
                  cvvFocus.requestFocus();
                },
              ),
              back: VersoCartao(
                cartaoCredito: widget.cartaoCredito, //cartao criado na tela de checkout
                cvvFocus: cvvFocus,
              ),
            ),
            TextButton(
              onPressed: () {
                cardKey.currentState!.toggleCard();
              },
              child: Text(
                'Virar cartão',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
