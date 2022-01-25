import 'package:flutter_aula_1/models/moeda.dart';

class MoedaRepository {
  static List<Moeda> tabela = [
    Moeda(
      icone: "images/bitcoin.png",
      nome: "Bitcoin",
      preco: 178909.00,
      sigla: "BTC",
    ),
    Moeda(
      icone: "images/ethereum.png",
      nome: "Ethereum",
      preco: 9716.20,
      sigla: "ETH",
    ),
    Moeda(
      icone: "images/xrp.png",
      nome: "XRP",
      preco: 3.45,
      sigla: "XRP",
    ),
  ];
}
