import 'package:flutter/material.dart';
import 'package:loja_virtual/comum/drawer_comum/DrawerCustomizado.dart';
import 'package:loja_virtual/models/GerenciadorPagina.dart';
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
        physics: const NeverScrollableScrollPhysics(),
        //Colocar todas as telas:
        children: <Widget>[
          Scaffold(
            drawer: DrawerCustomizado(),
            appBar: AppBar(
              title: const Text("Início"),
            ),
          ),
          Scaffold(
            drawer: DrawerCustomizado(),
            appBar: AppBar(
              title: const Text("Produtos"),
            ),
          ),
          Scaffold(
            drawer: DrawerCustomizado(),
            appBar: AppBar(
              title: const Text("Meus produtos"),
            ),
          ),
          Scaffold(
            drawer: DrawerCustomizado(),
            appBar: AppBar(
              title: const Text("Lojas"),
            ),
          ),
        ],
      ),
    );
  }
}
