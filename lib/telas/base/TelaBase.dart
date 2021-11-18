import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/GerenciadorUsuarios.dart';
import 'package:loja_virtual/telas/administrador/TelaUsuarioAdministrador.dart';
import 'package:loja_virtual/telas/home/Home.dart';
import 'package:loja_virtual/models/GerenciadorPagina.dart';
import 'package:loja_virtual/telas/lojas/TelaLojas.dart';
import 'package:loja_virtual/telas/pedidos/TelaPedidos.dart';
import 'package:loja_virtual/telas/pedidos_admin/TelaPedidosAdmin.dart';
import 'package:loja_virtual/telas/produtos/TelaProdutos.dart';
import 'package:provider/provider.dart';
import 'package:another_flushbar/flushbar.dart';

class TelaBase extends StatefulWidget {
  @override
  _TelaBaseState createState() => _TelaBaseState();
}

class _TelaBaseState extends State<TelaBase> {
  //Controlar a exibição da tela:
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    //A tela do app sempre irá se manter na vertical:
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    configFCM();
  }

  void configFCM() async {
    final fcm = FirebaseMessaging.instance;

    //No iOS, isso ajuda a obter as permissões do usuário
    NotificationSettings settings = await fcm.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //O usuário aceitou as permissões!

      //lidando com as notificações recebidas
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        String title = message.notification?.title ?? "";
        String body = message.notification?.body ?? "";
        showNotification(title, body);
      });
    } else {
      //O usuário não aceitou as permissões!
    }
  }

  void showNotification(String title, String message) {
    Flushbar(
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.TOP, //Irá aparecer no topo da tela
      flushbarStyle: FlushbarStyle.GROUNDED, //Não irá ficar colado na borda superior
      isDismissible: true,
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 5),
      icon: Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => GerenciadorPagina(pageController),
      child: Consumer<GerenciadorUsuarios>(
        builder: (_, gerenciadorUsuarios, __) {
          return PageView(
            controller: pageController,
            //Impede a movimentação da página através de gestos:
            physics: NeverScrollableScrollPhysics(),
            //Colocar todas as telas:
            children: <Widget>[
              Home(),
              TelaProdutos(),
              TelaPedidos(),
              TelaLojas(),
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
