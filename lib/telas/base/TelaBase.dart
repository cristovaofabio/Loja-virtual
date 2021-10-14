import 'package:flutter/material.dart';
import 'package:loja_virtual/models/GerenciadorUsuarios.dart';
import 'package:loja_virtual/telas/administrador/TelaUsuarioAdministrador.dart';
import 'package:loja_virtual/telas/home/Home.dart';
import 'package:loja_virtual/comum/drawer_comum/DrawerCustomizado.dart';
import 'package:loja_virtual/models/GerenciadorPagina.dart';
import 'package:loja_virtual/telas/pedidos/TelaPedidos.dart';
import 'package:loja_virtual/telas/pedidos_admin/TelaPedidosAdmin.dart';
import 'package:loja_virtual/telas/produtos/TelaProdutos.dart';
import 'package:provider/provider.dart';

class TelaBase extends StatefulWidget {
  @override
  _TelaBaseState createState() => _TelaBaseState();
}

class _TelaBaseState extends State<TelaBase> {
  //Controlar a exibição da tela:
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => GerenciadorPagina(pageController),
      child: Consumer<GerenciadorUsuarios>(
        builder: (_, gerenciadorUsuarios, __) {
          return PageView(
            controller: pageController,
            //Impede a movitação da página através de gestos:
            physics: NeverScrollableScrollPhysics(),
            //Colocar todas as telas:
            children: <Widget>[
              Home(),
              TelaProdutos(),
              TelaPedidos(),
              Scaffold(
                drawer: DrawerCustomizado(),
                appBar: AppBar(
                  title: Text("Lojas"),
                ),
              ),
              //Se o usuário for administrador, adicionar novos elementos à lista:
              if (gerenciadorUsuarios.adminHabilitado) ...[
                TelaUsuarioAdministrador(),
                TelaPedidosAdmin(),
              ]
            ],
          );
        },
      ),
    );
  }
}
