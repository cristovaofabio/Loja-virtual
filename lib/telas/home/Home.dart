import 'package:flutter/material.dart';
import 'package:loja_virtual/comum/drawer_comum/DrawerCustomizado.dart';
import 'package:loja_virtual/models/GerenciadorHome.dart';
import 'package:loja_virtual/models/GerenciadorUsuarios.dart';
import 'package:loja_virtual/telas/home/componentes/AddSecaoWidget.dart';
import 'package:loja_virtual/telas/home/componentes/ListaSecao.dart';
import 'package:loja_virtual/telas/home/componentes/SecaoStaggered.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustomizado(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF303030),
                  Colors.grey,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                snap: true,
                floating: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('Loja do Cristóvão'),
                  centerTitle: true,
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    color: Colors.white,
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/carrinho'),
                  ),
                  Consumer2<GerenciadorUsuarios, GerenciadorHome>(
                    builder: (_, userManager, homeManager, __) {
                      if (userManager.adminHabilitado &&
                          !homeManager.carregando) {
                        if (homeManager.editando) {
                          return PopupMenuButton(
                            onSelected: (e) {
                              if (e == 'Salvar') {
                                homeManager.salvarEditando();
                              } else {
                                homeManager.discartarEditando();
                              }
                            },
                            itemBuilder: (_) {
                              return ['Salvar', 'Descartar'].map((e) {
                                return PopupMenuItem(
                                  value: e,
                                  child: Text(e),
                                );
                              }).toList();
                            },
                          );
                        } else {
                          return IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              homeManager.entrarEditando();
                            },
                          );
                        }
                      } else
                        return Container();
                    },
                  ),
                ],
              ),
              Consumer<GerenciadorHome>(
                builder: (_, gerenciadorHome, __) {
                  if (gerenciadorHome.carregando) {
                    return SliverToBoxAdapter(
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        backgroundColor: Colors.transparent,
                      ),
                    );
                  }
                  final List<Widget> children =
                      gerenciadorHome.secoes.map<Widget>((secao) {
                    switch (secao.tipo) {
                      case 'lista':
                        return ListaSecao(secao);
                      case 'staggered':
                        return SecaoStaggered(secao);
                      default:
                        return Container();
                    }
                  }).toList();

                  if (gerenciadorHome.editando)
                    children.add(AddSecaoWidget(gerenciadorHome));

                  return SliverList(
                    delegate: SliverChildListDelegate(children),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
