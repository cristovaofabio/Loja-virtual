import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextoCartao extends StatelessWidget {
  const TextoCartao({
    this.titulo,
    this.bold = false,
    required this.hint,
    required this.textInputType,
    this.inputFormatters,
    required this.validator,
    this.maxLength,
    this.textAlign = TextAlign.start,
    required this.focusNode,
    this.onSaved,
    this.onSubmitted,
  }) : textInputAction =
            onSubmitted == null ? TextInputAction.done : TextInputAction.next;

  final String? titulo;
  final bool bold;
  final String hint;
  final TextInputType textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String> validator;
  final int? maxLength;
  final TextAlign textAlign;
  final FocusNode focusNode;
  final Function(String)? onSubmitted;
  final TextInputAction textInputAction;
  final FormFieldSetter<String>? onSaved;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: '',
      validator: validator,
      onSaved: onSaved,
      builder: (state) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (titulo != null)
                Row(
                  children: <Widget>[
                    Text(
                      titulo!,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    if (state.hasError)
                      Text(
                        '   Inválido',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 9,
                        ),
                      ),
                  ],
                ),
              TextFormField(
                style: TextStyle(
                  color: titulo == null && state.hasError
                      ? Colors.red
                      : Colors.white,
                  fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: titulo == null && state.hasError
                        ? Colors.red.withAlpha(200)
                        : Colors.white.withAlpha(100),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 2),
                  counterText: "",
                ),
                keyboardType: textInputType,
                inputFormatters: inputFormatters,
                onChanged: (text) {
                  state.didChange(text);
                },
                maxLength: maxLength,
                textAlign: textAlign,
                focusNode: focusNode,
                onFieldSubmitted: onSubmitted,
                textInputAction: textInputAction,
              ),
            ],
          ),
        );
      },
    );
  }
}
