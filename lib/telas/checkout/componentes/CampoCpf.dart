import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/GerenciadorUsuarios.dart';
import 'package:provider/provider.dart';

class CampoCpf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userManager = context.watch<GerenciadorUsuarios>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'CPF',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            TextFormField(
              initialValue: userManager.usuarioAtual.cpf,
              decoration: InputDecoration(
                hintText: '000.000.000-00',
                isDense: true
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CpfInputFormatter(),
              ],
              validator: (cpf){
                if(cpf!.isEmpty) return 'Campo Obrigatório';
                else if(!CPFValidator.isValid(cpf)) return 'CPF Inválido';
                return null;
              },
              onSaved: (cpf){
                userManager.usuarioAtual.setCpf(cpf!);
              },
            )
          ],
        ),
      ),
    );
  }
}