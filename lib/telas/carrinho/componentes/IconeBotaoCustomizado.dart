import 'package:flutter/material.dart';

class IconeBotaoCustomizado extends StatelessWidget {
  IconeBotaoCustomizado(
      {required this.icone, required this.cor, required this.onTap, this.size});
  late final IconData icone;
  late final Color cor;
  late final VoidCallback onTap;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Icon(
              icone,
              color: onTap != () {} ? cor : Colors.grey,
              size: size ?? 24,
            ),
          ),
        ),
      ),
    );
  }
}
