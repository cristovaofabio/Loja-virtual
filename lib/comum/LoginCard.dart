import 'package:flutter/material.dart';
import 'package:loja_virtual/util/BotaoCustomizado.dart';

class LoginCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.account_circle,
                color: Theme.of(context).primaryColor,
                size: 100,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Faça login para acessar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              BotaoCustomizado(
                texto: 'LOGIN',
                onPressed: () {
                  Navigator.of(context).pushNamed('/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
