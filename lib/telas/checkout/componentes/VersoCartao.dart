import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/CartaoCredito.dart';
import 'package:loja_virtual/telas/checkout/componentes/TextoCartao.dart';

class VersoCartao extends StatelessWidget {
  VersoCartao({required this.cvvFocus, required this.cartaoCredito});

  final FocusNode cvvFocus;
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
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.black,
              height: 40,
              margin: EdgeInsets.symmetric(vertical: 16),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 70,
                  child: Container(
                    color: Colors.grey[500],
                    margin: EdgeInsets.only(left: 12),
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: TextoCartao(
                      initialValue: cartaoCredito.securityCode,
                      hint: '123',
                      maxLength: 3,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textAlign: TextAlign.end,
                      textInputType: TextInputType.number,
                      validator: (cvv) {
                        if (cvv!.length != 3) return 'Inválido';
                        return null;
                      },
                      focusNode: cvvFocus,
                      onSaved: (cvv) {
                        cartaoCredito.setCVV(cvv!);
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 30,
                  child: Container(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
