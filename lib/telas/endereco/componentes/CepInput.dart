import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/GerenciadorCarrinho.dart';
import 'package:loja_virtual/util/BotaoCustomizado.dart';
import 'package:provider/provider.dart';

class CepInput extends StatelessWidget {
  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFormField(
          controller: cepController,
          decoration: InputDecoration(
            isDense: true,
            labelText: 'CEP',
            hintText: '12.345-678',
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CepInputFormatter(),
          ],
          keyboardType: TextInputType.number,
          validator: (cep) {
            if (cep!.isEmpty) {
              return 'Campo obrigatório';
            } else if (cep.length != 10) {
              return 'CEP Inválido';
            }
            return null;
          },
        ),
        BotaoCustomizado(
          texto: "Buscar CEP",
          onPressed: () {
            if (Form.of(context)!.validate()) {
              context
                  .read<GerenciadorCarrinho>()
                  .getEndereco(cepController.text);
            }
          },
        ),
      ],
    );
  }
}
