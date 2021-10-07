import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/Endereco.dart';
import 'package:loja_virtual/util/BotaoCustomizado.dart';

class EnderecoInputField extends StatelessWidget {
  final Endereco? endereco;

  EnderecoInputField(this.endereco);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFormField(
          initialValue: endereco!.rua,
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
        BotaoCustomizado(texto: "Calcular Frete", onPressed: () {})
      ],
    );
  }
}
