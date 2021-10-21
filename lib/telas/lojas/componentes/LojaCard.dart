import 'package:flutter/material.dart';
import 'package:loja_virtual/models/Loja.dart';
import 'package:loja_virtual/telas/carrinho/componentes/IconeBotaoCustomizado.dart';
import 'package:url_launcher/url_launcher.dart';

class LojaCard extends StatelessWidget {
  LojaCard(this.store);

  final Loja store;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    Color colorForStatus(LojaStatus status) {
      switch (status) {
        case LojaStatus.fechado:
          return Colors.red;
        case LojaStatus.aberto:
          return Colors.green;
        case LojaStatus.fechando:
          return Colors.orange;
        default:
          return Colors.green;
      }
    }

    Future<void> openTelefone() async {
      if (await canLaunch('tel:${store.cleanTelefone}')) {
        launch('tel:${store.cleanTelefone}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Esta função não está disponível neste dispositivo',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFFEF5350),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ));
      }
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          Container(
            height: 160,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.network(
                  store.imagem,
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Text(
                      store.statusText,
                      style: TextStyle(
                        color: colorForStatus(store.status),
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 140,
            padding: EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        store.nome,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        store.enderecoText,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        store.abrindoText,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconeBotaoCustomizado(
                      icone: Icons.map,
                      cor: primaryColor,
                      onTap: () {},
                    ),
                    IconeBotaoCustomizado(
                      icone: Icons.phone,
                      cor: primaryColor,
                      onTap: openTelefone,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
