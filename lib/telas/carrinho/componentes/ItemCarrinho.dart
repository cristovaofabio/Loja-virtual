import 'package:flutter/material.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/Carrinho.dart';
import 'package:loja_virtual/telas/carrinho/componentes/IconeBotaoCustomizado.dart';
import 'package:provider/provider.dart';

class ItemCarrinho extends StatelessWidget {
  final Carrinho carrinho;

  ItemCarrinho(this.carrinho);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: this.carrinho,
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).pushNamed(
              '/produto',
            arguments: carrinho.produto);
        },
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.network(carrinho.produto!.imagens!.first),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          carrinho.produto!.nome!,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17.0,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Tamanho: ${carrinho.tamanho}',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                        Consumer<Carrinho>(
                          builder: (_, carrinhoProduto, __) {
                            if (carrinhoProduto.temEstoque) {
                              return Text(
                                'R\$ ${carrinho.precoUnitario.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: temaPadrao.primaryColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                            else{
                              return Text(
                                'Sem estoque suficiente',
                                style: TextStyle(
                                  color: Colors.red[400],
                                  fontSize: 12,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Consumer<Carrinho>(builder: (_, carrinho, __) {
                  return Column(
                    children: <Widget>[
                      IconeBotaoCustomizado(
                        icone: Icons.add,
                        cor: temaPadrao.primaryColor,
                        onTap: carrinho.incremente,
                      ),
                      Text(
                        '${carrinho.quantidade}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      IconeBotaoCustomizado(
                        icone: Icons.remove,
                        cor: carrinho.quantidade > 1
                            ? temaPadrao.primaryColor
                            : Colors.red,
                        onTap: carrinho.decremente,
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
