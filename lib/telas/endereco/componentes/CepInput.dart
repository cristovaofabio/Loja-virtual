import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/Endereco.dart';
import 'package:loja_virtual/models/GerenciadorCarrinho.dart';
import 'package:loja_virtual/telas/carrinho/componentes/IconeBotaoCustomizado.dart';
import 'package:loja_virtual/util/BotaoCustomizado.dart';
import 'package:provider/provider.dart';

class CepInput extends StatefulWidget {
  final Endereco endereco;

  CepInput(this.endereco);

  @override
  _CepInputState createState() => _CepInputState();
}

class _CepInputState extends State<CepInput> {
  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<GerenciadorCarrinho>();

    if (widget.endereco.zipCode == null)
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
          if (cartManager.carregando)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(temaPadrao.primaryColor),
              backgroundColor: Colors.transparent,
            ),
          !cartManager.carregando
              ? BotaoCustomizado(
                  texto: "Buscar CEP",
                  onPressed: () async {
                    if (Form.of(context)!.validate()) {
                      try {
                        await context.read<GerenciadorCarrinho>().getEndereco(cepController.text);
                      } catch (erro) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("$erro"),
                            backgroundColor: Colors.red[400],
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        );
                      }
                    }
                  },
                )
              : Container(),
        ],
      );
    else
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'CEP: ${widget.endereco.zipCode}',
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
