import 'package:flutter/material.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/Produto.dart';

class ItemProduto extends StatelessWidget {

  final Produto produto;

  ItemProduto({required this.produto});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)
      ),
      child: Container(
        height: 100,
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1, //A imagem irá ficar quadrada
              child: Image.network(produto.imagens.first),
            ),
            const SizedBox(width: 16,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    produto.nome,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'A partir de',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    'R\$ 19.99',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: temaPadrao.primaryColor
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}