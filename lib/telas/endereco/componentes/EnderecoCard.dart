import 'package:flutter/material.dart';
import 'package:loja_virtual/telas/endereco/componentes/CepInput.dart';

class EnderecoCard extends StatelessWidget {
  const EnderecoCard({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
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
            CepInput()
          ],
        ),
      ),
    );
  }
}