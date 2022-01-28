import 'package:flutter/material.dart';
import 'package:cripto_app/database/db.dart';
import 'package:cripto_app/models/historico.dart';
import 'package:cripto_app/models/moeda.dart';
import 'package:cripto_app/models/posicao.dart';
import 'package:cripto_app/repositories/moeda_repository.dart';
import 'package:sqflite/sqflite.dart';

class ContaRepository extends ChangeNotifier {
  late Database db;
  List<Posicao> _carteira = [];
  double _saldo = 0;
  List<Historico> _historico = [];
  late MoedaRepository moedas;

  get saldo => _saldo;

  List<Posicao> get carteira => _carteira;
  List<Historico> get historico => _historico;

  ContaRepository({required this.moedas}) {
    _initRepository();
  }

  _initRepository() async {
    await _getSaldo();
    await _getCarteira();
  }

  _getSaldo() async {
    db = await DB.instance.database;

    List conta = await db.query('conta', limit: 1);

    _saldo = conta.first['saldo'];

    notifyListeners();
  }

  setSaldo(double valor) async {
    db = await DB.instance.database;

    db.update('conta', {'saldo': valor});

    _saldo = valor;

    notifyListeners();
  }

  comprar(Moeda moeda, double valor) async {
    db = await DB.instance.database;

    await db.transaction((txn) async {
      // Verificar se a moeda já foi comprada.
      await _compraMoeda(txn, moeda, valor);

      // Inserir a compra no historico
      await txn.insert('historico', {
        'sigla': moeda.sigla,
        'moeda': moeda.nome,
        'quantidade': (valor / moeda.preco),
        'valor': valor,
        'tipo_operacao': 'compra',
        'data_operacao': DateTime.now().microsecondsSinceEpoch
      });

      // Atualizar o saldo
      await txn.update('conta', {
        'saldo': saldo - valor,
      });
    });

    await _initRepository();

    notifyListeners();
  }

  /// Realiza a compra da moeda. Caso a moeda já tenha sido comprada
  /// realizará apenas o update da quantidade da moeda já comprada.
  _compraMoeda(Transaction txn, Moeda moeda, double valor) async {
    final posicaoMoeda = await txn.query(
      'carteira',
      where: 'sigla = ?',
      whereArgs: [moeda.sigla],
    );

    if (posicaoMoeda.isEmpty) {
      await txn.insert('carteira', {
        'sigla': moeda.sigla,
        'moeda': moeda.nome,
        'quantidade': (valor / moeda.preco).toString(),
      });
    } else {
      double qtdExistente =
          double.parse(posicaoMoeda.first['quantidade'].toString());

      final novaQuantidade = ((valor / moeda.preco) + qtdExistente).toString();

      await txn.update(
        'carteira',
        {'quantidade': novaQuantidade},
        where: 'sigla = ?',
        whereArgs: [moeda.sigla],
      );
    }
  }

  _getCarteira() async {
    List posicoes = await db.query('carteira');

    posicoes.forEach((element) {
      Moeda moeda =
          moedas.tabela.firstWhere((m) => m.sigla == element['sigla']);

      _carteira.add(
        Posicao(
          moeda: moeda,
          quantidade: double.parse(element['quantidade']),
        ),
      );
    });
    notifyListeners();
  }
}
