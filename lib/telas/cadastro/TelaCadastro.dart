import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/helper/Validadores.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/GerenciadorUsuarios.dart';
import 'package:loja_virtual/models/Usuario.dart';
import 'package:loja_virtual/util/BotaoCustomizado.dart';
import 'package:loja_virtual/util/InputCustomizado.dart';
import 'package:provider/provider.dart';
import 'package:validadores/Validador.dart';

class TelaCadastro extends StatelessWidget {
  final _chave = GlobalKey<FormState>();
  final Usuario _usuario = Usuario();

  final TextEditingController _controllerSenha = TextEditingController();
  final TextEditingController _controllerConfirmacaoSenha =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar conta"),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          elevation: 6,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _chave,
            child: Consumer<GerenciadorUsuarios>(
              builder: (_, gerenciadorUsuarios, __) {
                return ListView(
                  padding: EdgeInsets.all(10),
                  shrinkWrap:
                      true, //A lista irá ocuparar o menor espaço possível
                  children: <Widget>[
                    InputCustomizado(
                      "Nome",
                      Icon(Icons.edit),
                      type: TextInputType.name,
                      onSaved: (nome) {
                        _usuario.nome = nome!;
                      },
                      habilitar: !gerenciadorUsuarios.carregando,
                      validator: (valor) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                            .minLength(3,
                                msg: "Informe pelo menos 3 caracteres")
                            .valido(valor as String);
                      },
                      inputFormaters: [
                        FilteringTextInputFormatter(RegExp("[a-z A-Z á-ú Á-Ú]"),
                            allow: true)
                      ],
                      letras: TextCapitalization.sentences,
                    ),
                    SizedBox(height: 5),
                    InputCustomizado(
                      "E-mail",
                      Icon(Icons.mail),
                      type: TextInputType.emailAddress,
                      onSaved: (email) {
                        _usuario.email = email!;
                      },
                      habilitar: !gerenciadorUsuarios.carregando,
                      validator: (email) {
                        if (!emailValidador(email!)) {
                          return "E-mail inválido";
                        }
                      },
                    ),
                    SizedBox(height: 5),
                    InputCustomizado(
                      "Digite uma senha",
                      Icon(Icons.vpn_key),
                      obscure: true,
                      type: TextInputType.text,
                      controller: _controllerSenha,
                      onSaved: (senha) {
                        _usuario.senha = senha!;
                      },
                      habilitar: !gerenciadorUsuarios.carregando,
                      validator: (valor) {
                        if (valor != _controllerConfirmacaoSenha.text) {
                          return "As senhas são diferentes!";
                        }
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                            .minLength(6,
                                msg: "A senha precisa pelo menos 6 caracteres")
                            .validar(valor);
                      },
                    ),
                    SizedBox(height: 5),
                    InputCustomizado(
                      "Digite a senha novamente",
                      Icon(Icons.vpn_key_rounded),
                      obscure: true,
                      type: TextInputType.text,
                      controller: _controllerConfirmacaoSenha,
                      habilitar: !gerenciadorUsuarios.carregando,
                      validator: (valor) {
                        if (valor != _controllerSenha.text) {
                          return "As senhas são diferentes!";
                        }
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                            .minLength(6,
                                msg: "A senha precisa pelo menos 6 caracteres")
                            .validar(valor);
                      },
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
                            texto: "Cadastrar",
                            onPressed: () {
                              if (_chave.currentState!.validate()) {
                                _chave.currentState!
                                    .save(); //Vai chamar o método onSaved
                                gerenciadorUsuarios.cadastrar(
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
                                    // Fechar tela de cadastro
                                    Navigator.of(context).pop();
                                  },
                                );
                              }
                            },
                          )
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
