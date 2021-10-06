import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/util/BotaoCustomizado.dart';

class CepInput extends StatelessWidget {
  const CepInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            isDense: true,
            labelText: 'CEP',
            hintText: '12.345-678',
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          keyboardType: TextInputType.number,
        ),
        BotaoCustomizado(
          texto: "Buscar CEP",
          onPressed: () {},
        ),
      ],
    );
  }
}
