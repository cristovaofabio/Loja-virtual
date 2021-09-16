import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/GerenciadorUsuarios.dart';
import 'package:loja_virtual/telas/base/TelaBase.dart';
import 'package:loja_virtual/telas/cadastro/TelaCadastro.dart';
import 'package:loja_virtual/telas/login/TelaLogin.dart';
import 'package:provider/provider.dart';

final ThemeData temaPadrao = ThemeData(
  primaryColor: Colors.lightBlue,
  scaffoldBackgroundColor: Colors.lightBlue,
  appBarTheme: AppBarTheme(
    elevation: 0,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

void main() async {
  //Inicializar o Firebase:
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (_) => GerenciadorUsuarios(),
      lazy: false, //Carregar imediatamente o GerenciadorUsuarios
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
            case '/cadastro':
              return MaterialPageRoute(
                builder: (_) => TelaCadastro(),
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