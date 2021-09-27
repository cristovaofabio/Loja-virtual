import 'package:flutter/material.dart';
import 'package:loja_virtual/comum/drawer_comum/DrawerCabecalho.dart';
import 'package:loja_virtual/comum/drawer_comum/DrawerItem.dart';
import 'package:loja_virtual/models/GerenciadorUsuarios.dart';
import 'package:provider/provider.dart';

class DrawerCustomizado extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFBBDEFB),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          ListView(
            children: <Widget>[
              DrawerCabecalho(),
              Divider(),
              DrawerItem(
                icone: Icons.home,
                titulo: "Início",
                pagina: 0,
              ),
              DrawerItem(
                icone: Icons.list,
                titulo: "Produtos",
                pagina: 1,
              ),
              DrawerItem(
                icone: Icons.check_box,
                titulo: "Meus pedidos",
                pagina: 2,
              ),
              DrawerItem(
                icone: Icons.location_on,
                titulo: "Lojas",
                pagina: 3,
              ),
              Consumer<GerenciadorUsuarios>(
                builder: (_, userManager, __) {
                  if (userManager.adminHabilitado) {
                    return Column(
                      children: <Widget>[
                        Divider(),
                        DrawerItem(
                          icone: Icons.people_alt,
                          titulo: "Usuários",
                          pagina: 4,
                        ),
                        DrawerItem(
                          icone: Icons.favorite_border,
                          titulo: "Pedidos",
                          pagina: 5,
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
