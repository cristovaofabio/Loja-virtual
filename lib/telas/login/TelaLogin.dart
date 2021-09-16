import 'package:flutter/material.dart';
import 'package:loja_virtual/helper/validadores.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/GerenciadorUsuarios.dart';
import 'package:loja_virtual/models/Usuario.dart';
import 'package:loja_virtual/util/BotaoCustomizado.dart';
import 'package:loja_virtual/util/InputCustomizado.dart';
import 'package:provider/provider.dart';

class TelaLogin extends StatelessWidget {
  final _chave = GlobalKey<FormState>();
  final Usuario _usuario = Usuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/cadastro');
            },
            child: Text(
              "CRIAR CONTA",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _chave,
            child: Consumer<GerenciadorUsuarios>(
              builder: (_, gerenciadorUsuarios, __) {
                return ListView(
                  padding: EdgeInsets.all(10),
                  shrinkWrap: true, //A lista irá ocupar a menor altura possível
                  children: <Widget>[
                    InputCustomizado(
                      "E-mail",
                      Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                      onSaved: (email) {
                        _usuario.email = email!;
                      },
                      habilitar: !gerenciadorUsuarios.carregando,
                      type: TextInputType.emailAddress,
                      validator: (email) {
                        if (!emailValidador(email!)) {
                          return "E-mail inválido";
                        }
                      },
                    ),
                    SizedBox(height: 5),
                    InputCustomizado(
                      "Senha",
                      Icon(
                        Icons.vpn_key,
                        color: Colors.grey,
                      ),
                      obscure: true,
                      onSaved: (senha) {
                        _usuario.senha = senha!;
                      },
                      habilitar: !gerenciadorUsuarios.carregando,
                      validator: (senha) {
                        if (senha!.isEmpty || senha.length < 6) {
                          return "Senha inválida! Digite pelo menos 6 caracteres";
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text("Esqueci minha senha"),
                      ),
                    ),
                    SizedBox(height: 15),
                    gerenciadorUsuarios.carregando
                        ? TextButton(
                            onPressed: () {},
                            child: CircularProgressIndicator(
                              color: temaPadrao.primaryColor,
                            ),
                          )
                        : BotaoCustomizado(
                            texto: "Entrar",
                            onPressed: () {
                              if (_chave.currentState!.validate()) {
                                _chave.currentState!
                                    .save(); //Vai chamar o método onSaved
                                gerenciadorUsuarios.entrar(
                                  usuario: _usuario,
                                  fracasso: (erro) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("$erro"),
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    );
                                  },
                                  sucesso: () {
                                    // Fechar tela de login
                                    Navigator.of(context).pop();
                                  },
                                );
                              }
                            },
                          ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
