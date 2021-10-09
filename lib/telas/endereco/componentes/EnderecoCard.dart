import 'package:flutter/material.dart';
import 'package:loja_virtual/models/Endereco.dart';
import 'package:loja_virtual/models/GerenciadorCarrinho.dart';
import 'package:loja_virtual/telas/endereco/componentes/CepInput.dart';
import 'package:loja_virtual/telas/endereco/componentes/EnderecoInputField.dart';
import 'package:provider/provider.dart';

class EnderecoCard extends StatelessWidget {
  const EnderecoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Consumer<GerenciadorCarrinho>(
          builder: (_, gerenciadorCarrinho, __) {
            final endereco = gerenciadorCarrinho.endereco ?? Endereco();
            
            return Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Endereço de Entrega',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  CepInput(endereco),
                  EnderecoInputField(endereco),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
