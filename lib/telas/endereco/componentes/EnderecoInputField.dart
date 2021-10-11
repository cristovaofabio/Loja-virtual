import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/Endereco.dart';
import 'package:loja_virtual/models/GerenciadorCarrinho.dart';
import 'package:loja_virtual/util/BotaoCustomizado.dart';
import 'package:provider/provider.dart';

class EnderecoInputField extends StatelessWidget {
  final Endereco? endereco;

  EnderecoInputField(this.endereco);

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<GerenciadorCarrinho>();

    if (endereco!.zipCode != null && cartManager.precoEntrega == null)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            enabled: !cartManager.carregando,
            initialValue: (endereco!.rua == "null") ? "" : endereco!.rua,
            decoration: InputDecoration(
              isDense: true,
              labelText: 'Rua/Avenida',
              hintText: 'Av. Brasil',
            ),
            validator: (rua) {
              if (rua!.isEmpty) {
                return 'Campo obrigatório';
              } else {
                return null;
              }
            },
            onSaved: (t) => endereco!.rua = t,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  enabled: !cartManager.carregando,
                  initialValue: endereco!.numero,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Número',
                    hintText: '123',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  validator: (numero) {
                    if (numero!.isEmpty) {
                      return 'Campo obrigatório';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (t) => endereco!.numero = t,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextFormField(
                  enabled: !cartManager.carregando,
                  initialValue: endereco!.complemento,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Complemento',
                    hintText: 'Opcional',
                  ),
                  onSaved: (t) => endereco!.complemento = t,
                ),
              ),
            ],
          ),
          TextFormField(
            enabled: !cartManager.carregando,
            initialValue: endereco!.distrito,
            decoration: InputDecoration(
              isDense: true,
              labelText: 'Bairro',
              hintText: 'Guanabara',
            ),
            validator: (bairro) {
              if (bairro!.isEmpty) {
                return 'Campo obrigatório';
              } else {
                return null;
              }
            },
            onSaved: (t) => endereco!.distrito = t,
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: TextFormField(
                  enabled: false,
                  initialValue: endereco!.cidade,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Cidade',
                    hintText: 'Campinas',
                  ),
                  validator: (cidade) {
                    if (cidade!.isEmpty) {
                      return 'Campo obrigatório';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (t) => endereco!.cidade = t,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextFormField(
                  autocorrect: false,
                  enabled: false,
                  textCapitalization: TextCapitalization.characters,
                  initialValue: endereco!.estado,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'UF',
                    hintText: 'SP',
                    counterText: '',
                  ),
                  maxLength: 2,
                  validator: (estado) {
                    if (estado!.isEmpty) {
                      return 'Campo obrigatório';
                    } else if (estado.length != 2) {
                      return 'Inválido';
                    }
                    return null;
                  },
                  onSaved: (t) => endereco!.estado = t,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          if (cartManager.carregando)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(temaPadrao.primaryColor),
              backgroundColor: Colors.transparent,
            ),
          !cartManager.carregando
              ? BotaoCustomizado(
                  texto: "Calcular Frete",
                  onPressed: () async {
                    if (Form.of(context)!.validate()) {
                      Form.of(context)!.save();
                      try {
                        await context
                            .read<GerenciadorCarrinho>()
                            .setEndereco(endereco!);
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
    else if (endereco!.zipCode != null)
      return Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Text(
            '${endereco!.rua}, ${endereco!.numero}\n${endereco!.distrito}\n'
            '${endereco!.cidade} - ${endereco!.estado}'),
      );
    else
      return Container();
  }
}
