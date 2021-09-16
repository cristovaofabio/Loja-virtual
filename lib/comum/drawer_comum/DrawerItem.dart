import 'package:flutter/material.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/GerenciadorPagina.dart';
import 'package:provider/provider.dart';

class DrawerItem extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final int pagina;

  const DrawerItem({
    required this.icone,
    required this.titulo,
    required this.pagina,
  });

  @override
  Widget build(BuildContext context) {
    final int paginaAtual = context.watch<GerenciadorPagina>().paginaEstou;
    final Color corItemSelecionado = temaPadrao.primaryColor;

    return InkWell(
      onTap: () {
        context.read<GerenciadorPagina>().mostrarPagina(this.pagina);
      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Icon(
                this.icone,
                size: 32,
                color: paginaAtual == this.pagina
                    ? corItemSelecionado
                    : Colors.grey[600],
              ),
            ),
            Text(
              this.titulo,
              style: TextStyle(
                fontSize: 16,
                color: paginaAtual == this.pagina
                    ? corItemSelecionado
                    : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
