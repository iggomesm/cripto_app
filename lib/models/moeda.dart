import 'dart:convert';

class Moeda {
  String icone;
  String nome;
  String sigla;
  double preco;
  Moeda({
    required this.icone,
    required this.nome,
    required this.sigla,
    required this.preco,
  });

  Map<String, dynamic> toMap() {
    return {
      'icone': icone,
      'nome': nome,
      'sigla': sigla,
      'preco': preco,
    };
  }

  factory Moeda.fromMap(Map<String, dynamic> map) {
    return Moeda(
      icone: map['icone'] ?? '',
      nome: map['nome'] ?? '',
      sigla: map['sigla'] ?? '',
      preco: map['preco']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Moeda.fromJson(String source) => Moeda.fromMap(json.decode(source));
}
