import 'package:flutter/material.dart';

class BarraPesquisar extends StatelessWidget {
  final String textoInicial;

  BarraPesquisar(this.textoInicial);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 2,
          left: 4,
          right: 4,
          child: Card(
            child: TextFormField(
              initialValue: textoInicial,
              textInputAction: TextInputAction.search, //Mudar botão do teclado
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                //Adicionar ícone à esquerda do card:
                prefixIcon: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.grey[700],
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                )
              ),
              onFieldSubmitted: (text){
                Navigator.of(context).pop(text);
              },
            ),
          ),
        )
      ],
    );
  }
}