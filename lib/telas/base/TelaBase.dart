import 'package:flutter/material.dart';
import 'package:loja_virtual/telas/home/Home.dart';
import 'package:loja_virtual/comum/drawer_comum/DrawerCustomizado.dart';
import 'package:loja_virtual/models/GerenciadorPagina.dart';
import 'package:loja_virtual/telas/produtos/TelaProdutos.dart';
import 'package:provider/provider.dart';

class TelaBase extends StatelessWidget {
  //Controlar a exibição da tela:
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_)=>GerenciadorPagina(pageController),
      child: PageView(
        controller: pageController,
        //Impede a movitação da página através de gestos:
        physics: NeverScrollableScrollPhysics(),
        //Colocar todas as telas:
        children: <Widget>[
          Home(),
          TelaProdutos(),
          Scaffold(
            drawer: DrawerCustomizado(),
            appBar: AppBar(
              title: Text("Meus produtos"),
            ),
          ),
          Scaffold(
            drawer: DrawerCustomizado(),
            appBar: AppBar(
              title: Text("Lojas"),
            ),
          ),
        ],
      ),
    );
  }
}
