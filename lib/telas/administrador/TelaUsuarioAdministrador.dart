import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/comum/drawer_comum/DrawerCustomizado.dart';
import 'package:loja_virtual/models/GerenciadorUsuariosAdministradores.dart';
import 'package:provider/provider.dart';

class TelaUsuarioAdministrador extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerCustomizado(),
      appBar: AppBar(
        title: Text('Usuários'),
        centerTitle: true,
      ),
      body: Consumer<GerenciadorUsuariosAdministradores>(
        builder: (_,gerenciadorUsuariosAdministradores, __){
          return AlphabetListScrollView(
            keyboardUsage: true,
            itemBuilder: (_, index){
              return ListTile(
                title: Text(
                  gerenciadorUsuariosAdministradores.usuarios[index].nome,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white
                  ),
                ),
                subtitle: Text(
                  gerenciadorUsuariosAdministradores.usuarios[index].email,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            },
            highlightTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20
            ),
            indexedHeight: (index) => 80,
            strList: gerenciadorUsuariosAdministradores.nomes,
            showPreview: true,
          );
        },
      ),
    );
  }
}