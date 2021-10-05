class SecaoItem {
  dynamic imagem;
  String? produto;

  SecaoItem({required this.imagem, this.produto});

  SecaoItem clone() {
    return SecaoItem(
      imagem: imagem,
      produto: produto,
    );
  }

  SecaoItem.fromMap(Map<String, dynamic> map) {
    imagem = map['imagem'] as String;
    produto = map['produto'] as String;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'imagem'  : imagem,
      'produto' : produto,
    };
    return map;
  }

  @override
  String toString() {
    return 'SecaoItem{imagem: $imagem, produto: $produto}';
  }
}
