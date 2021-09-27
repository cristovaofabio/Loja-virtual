import 'package:flutter/material.dart';
import 'package:loja_virtual/models/GerenciadorPagina.dart';
import 'package:loja_virtual/models/GerenciadorUsuarios.dart';
import 'package:provider/provider.dart';

class DrawerCabecalho extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 24, 16, 8),
      height: 180,
      child: Consumer<GerenciadorUsuarios>(
        builder: (_, gerenciadorUsuarios, __) {
          String nomeUsuario = gerenciadorUsuarios.usuarioAtual.nome;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "Loja do Fulano",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Olá, $nomeUsuario",
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if(nomeUsuario.isEmpty){
                    //Entrar ou realizar cadastro
                    Navigator.of(context).pushNamed('/login');
                  }else{
                    //Sair do sistema
                    context.read<GerenciadorPagina>().mostrarPagina(0);
                    gerenciadorUsuarios.sair();
                  }
                },
                child: Text(
                  nomeUsuario.isNotEmpty ? "Sair" : "Entre ou cadastre-se",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
