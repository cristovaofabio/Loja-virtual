import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/GerenciadorCarrinho.dart';
import 'package:loja_virtual/models/GerenciadorUsuarios.dart';
import 'package:loja_virtual/models/Produto.dart';
import 'package:loja_virtual/telas/produtos/componentes/TamanhoWidget.dart';
import 'package:loja_virtual/util/BotaoCustomizado.dart';
import 'package:provider/provider.dart';

class TelaProduto extends StatelessWidget {
  final Produto produto;

  TelaProduto(this.produto);

  @override
  Widget build(BuildContext context) {
    //As alterações no produto selecionado serão ouvidas nesta tela:
    return ChangeNotifierProvider.value(
      value: this.produto,
      child: Scaffold(
        appBar: AppBar(
          title: Text(produto.nome!),
          centerTitle: true,
          actions: <Widget>[
            Consumer<GerenciadorUsuarios>(
              builder: (_, gerenciadorUsuarios, __) {
                if (gerenciadorUsuarios.adminHabilitado &&
                    (produto.deletado == false)) {
                  return IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                          '/editar_produto',
                          arguments: produto);
                    },
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            AspectRatio(
              //Colocar a imagem quadrada
              aspectRatio: 1,
              child: Carousel(
                images: produto.imagens!.map((url) {
                  return NetworkImage(url);
                }).toList(),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: temaPadrao.primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start, //Alinhar o conteúdo da coluna todo à esquerda
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    produto.nome!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'A partir de',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    'R\$ ${produto.precoBase.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: temaPadrao.primaryColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Descrição',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    produto.descricao!,
                    style: TextStyle(fontSize: 16),
                  ),
                  if (produto.deletado!)
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        'Este produto não está mais disponível',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.red),
                      ),
                    )
                  else ...[
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        'Tamanhos',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    //Permite colocar um ítem abaixo do outro, até que não seja mais possível:
                    Wrap(
                      spacing: 8,
                      runSpacing: 8, //Espaçamento entre linhas
                      children: produto.tamanhos!.map((e) {
                        return TamanhoWidget(e);
                      }).toList(),
                    ),
                  ],
                  SizedBox(
                    height: 20,
                  ),
                  if (produto.temEstoque)
                    //O Consumer2 observa dois providers
                    Consumer2<GerenciadorUsuarios, Produto>(
                      builder: (_, gerenciadorUsuario, produto, __) {
                        String nomeUsuario =
                            gerenciadorUsuario.usuarioAtual.nome;
                        return SizedBox(
                          height: 44,
                          child: BotaoCustomizado(
                            texto: nomeUsuario.isNotEmpty
                                ? "Adicionar ao carrinho"
                                : "Entre para comprar",
                            onPressed: (produto.tamanhoSelecionado.nome != null)
                                ? () {
                                    if (nomeUsuario.isNotEmpty) {
                                      //Usuário logado e tamanho selecionado
                                      //Adicionar ao carrinho
                                      context
                                          .read<GerenciadorCarrinho>()
                                          .adicionarAoCarrinho(produto);
                                      Navigator.of(context)
                                          .pushNamed('/carrinho');
                                    } else {
                                      //Usuário deslogado
                                      Navigator.of(context).pushNamed('/login');
                                    }
                                  }
                                : () {},
                          ),
                        );
                      },
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
