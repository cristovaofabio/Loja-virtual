import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/Endereco.dart';
import 'package:loja_virtual/models/GerenciadorCarrinho.dart';
import 'package:loja_virtual/telas/carrinho/componentes/IconeBotaoCustomizado.dart';
import 'package:loja_virtual/util/BotaoCustomizado.dart';
import 'package:provider/provider.dart';

class CepInput extends StatelessWidget {
  final Endereco endereco;

  CepInput(this.endereco);

  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (endereco.zipCode == null)
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
    else
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'CEP: ${endereco.zipCode}',
                style: TextStyle(
                  color: temaPadrao.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconeBotaoCustomizado(
              icone: Icons.edit,
              cor: temaPadrao.primaryColor,
              onTap: () {
                context.read<GerenciadorCarrinho>().removerEndereco();
              },
            ),
          ],
        ),
      );
  }
}
