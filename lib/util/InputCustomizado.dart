import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/main.dart';

class InputCustomizado extends StatelessWidget {
  late final String label;
  late final bool obscure;
  late final bool autofocus;
  late final bool autocorrecao;
  late final bool leitura;
  late final bool habilitar;
  late final TextInputType type;
  late final Icon icone;
  late final TextCapitalization letras;

  final List<TextInputFormatter>? inputFormaters;
  final int? maxLinhas;
  final bool? cursor;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final String? Function(String?)? onSaved;
  final String? Function()? onTap;
  final String? textoAjuda;
  final TextEditingController? controller;

  InputCustomizado(this.label, this.icone,
      {this.controller,
      this.obscure = false,
      this.autofocus = false,
      this.leitura =false,
      this.type = TextInputType.text,
      this.letras = TextCapitalization.none,
      this.autocorrecao = false,
      this.habilitar = true,
      this.inputFormaters,
      this.maxLinhas = 1,
      this.focusNode,
      this.cursor,
      this.textoAjuda,
      this.validator,
      this.onTap,
      this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      enableSuggestions: true,
      obscureText: this.obscure,
      showCursor: this.cursor,
      readOnly: this.leitura,
      enabled: this.habilitar,
      autofocus: this.autofocus,
      keyboardType: this.type,
      focusNode: this.focusNode,
      textCapitalization: this.letras,
      autocorrect: autocorrecao,
      style: TextStyle(fontSize: 18),
      inputFormatters: this.inputFormaters,
      maxLines: this.maxLinhas,
      onSaved: this.onSaved,
      onTap: this.onTap,
      validator: this.validator,
      decoration: InputDecoration(
        prefixIcon: this.icone,
        helperText: this.textoAjuda,
        labelText: this.label,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 1, color: Colors.deepPurple),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 1, color: temaPadrao.primaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
