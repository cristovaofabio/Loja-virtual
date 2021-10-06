import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/GerenciadorCarrinho.dart';
import 'package:loja_virtual/models/GerenciadorHome.dart';
import 'package:loja_virtual/models/GerenciadorProdutos.dart';
import 'package:loja_virtual/models/GerenciadorUsuarios.dart';
import 'package:loja_virtual/models/GerenciadorUsuariosAdministradores.dart';
import 'package:loja_virtual/models/Produto.dart';
import 'package:loja_virtual/servicos/CepAbertoService.dart';
import 'package:loja_virtual/telas/base/TelaBase.dart';
import 'package:loja_virtual/telas/cadastro/TelaCadastro.dart';
import 'package:loja_virtual/telas/carrinho/TelaCarrinho.dart';
import 'package:loja_virtual/telas/endereco/TelaEndereco.dart';
import 'package:loja_virtual/telas/login/TelaLogin.dart';
import 'package:loja_virtual/telas/produtos/TelaEditarProduto.dart';
import 'package:loja_virtual/telas/produtos/TelaProduto.dart';
import 'package:loja_virtual/telas/produtos/TelaProdutoSelecionado.dart';
import 'package:provider/provider.dart';

final ThemeData temaPadrao = ThemeData(
  primaryColor: Colors.green,
  scaffoldBackgroundColor: Colors.green[400],
  appBarTheme: AppBarTheme(
    elevation: 0,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  //Inicializar o Firebase:
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  HttpOverrides.global = new MyHttpOverrides();

  CepAbertoService().getEnderecoCep('13.087-000');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GerenciadorUsuarios(),
          lazy: false, //Carregar imediatamente o GerenciadorUsuarios
        ),
        ChangeNotifierProvider(
          create: (_) => GerenciadorProdutos(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => GerenciadorHome(),
          lazy: false,
        ),
        //Sempre que o ítem 1 sofrer alguma modificação, o ítem 2 é altualizado:
        ChangeNotifierProxyProvider<GerenciadorUsuarios, GerenciadorCarrinho>(
          create: (_) => GerenciadorCarrinho(),
          lazy: false,
          update: (_, gerenciadorUsuario, gerenciadorCarrinho) =>
              gerenciadorCarrinho!..atualizarUsuario(gerenciadorUsuario),
        ),
        ChangeNotifierProxyProvider<GerenciadorUsuarios,
            GerenciadorUsuariosAdministradores>(
          create: (_) => GerenciadorUsuariosAdministradores(),
          lazy: false,
          update:
              (_, gerenciadorUsuarios, gerenciadorUsuariosAdministradores) =>
                  gerenciadorUsuariosAdministradores!
                    ..atualizarUsuario(gerenciadorUsuarios),
        )
      ],
      child: MaterialApp(
        theme: temaPadrao,
        title: 'Loja do Cristóvão',
        initialRoute: '/base',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/base':
              return MaterialPageRoute(
                builder: (_) => TelaBase(),
              );
            case '/endereco':
              return MaterialPageRoute(builder: (_) => TelaEndereco());
            case '/editar_produto':
              return MaterialPageRoute(
                  builder: (_) =>
                      TelaEditarProduto(settings.arguments as Produto));
            case '/cadastro':
              return MaterialPageRoute(
                builder: (_) => TelaCadastro(),
              );
            case '/produto':
              return MaterialPageRoute(
                builder: (_) => TelaProduto(settings.arguments as Produto),
              );
            case '/produtoSelecionado':
              return MaterialPageRoute(
                builder: (_) => TelaProdutoSelecionado(),
              );
            case '/carrinho':
              return MaterialPageRoute(
                builder: (_) => TelaCarrinho(),
              );
            case '/login':
              return MaterialPageRoute(
                builder: (_) => TelaLogin(),
              );
            default:
              return MaterialPageRoute(
                builder: (_) => TelaBase(),
              );
          }
        },
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

  /* //Gera um id aleatório
  FirebaseFirestore.instance
    .collection("pedidos")
    .add(
      {
        "preco":199.99,
        "produto" : "Curso de aperfeiçoamento"
      }
    );

    //Eu gero o meu próprio id:
    FirebaseFirestore.instance
    .collection("clientes")
    .doc("007")
    .set(
      {
        "nome": "James",
        "sobrenome" : "Bond"
      }
    ); */