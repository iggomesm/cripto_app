// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';

import 'package:cripto_app/database/db.dart';
import 'package:cripto_app/models/moeda.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class MoedaRepository extends ChangeNotifier {
  List<Moeda> _tabela = [];

  List<Moeda> get tabela => _tabela;

  MoedaRepository() {
    _setupMoedasTable();
    _setupDadosTableMoeda();
    _readMoedasTable();
    _refreshPrecos();
  }

  late Timer intervalo;
  void _refreshPrecos() async {
    intervalo = Timer.periodic(Duration(minutes: 15), (_) => checkPrecos());
  }

  checkPrecos() async {
    String uri = 'https://api.coinbase.com/v2/assets/prices?base=BRL';
    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> moedas = json['data'];
      Database db = await DB.instance.database;
      Batch batch = db.batch();

      _tabela.forEach((atual) {
        moedas.forEach((novo) {
          if (atual.baseId == novo['base_id']) {
            final moeda = novo['prices'];
            final preco = moeda['latest_price'];
            final timestamp = DateTime.parse(preco['timestamp']);

            batch.update(
              'moedas',
              {
                'preco': moeda['latest'],
                'timestamp': timestamp.millisecondsSinceEpoch,
                'mudancaHora': preco['percent_change']['hour'].toString(),
                'mudancaDia': preco['percent_change']['day'].toString(),
                'mudancaSemana': preco['percent_change']['week'].toString(),
                'mudancaMes': preco['percent_change']['month'].toString(),
                'mudancaAno': preco['percent_change']['year'].toString(),
                'mudancaPeriodoTotal': preco['percent_change']['all'].toString()
              },
              where: 'baseId = ?',
              whereArgs: [atual.baseId],
            );
          }
        });
      });
      await batch.commit(noResult: true);
      await _readMoedasTable();
    }
  }

  void _setupMoedasTable() async {
    const String table = '''
      CREATE TABLE IF NOT EXISTS moedas (
        baseId TEXT PRIMARY KEY,
        sigla TEXT,
        nome TEXT,
        icone TEXT,
        preco TEXT,
        timestamp INTEGER,
        mudancaHora TEXT,
        mudancaDia TEXT,
        mudancaSemana TEXT,
        mudancaMes TEXT,
        mudancaAno TEXT,
        mudancaPeriodoTotal TEXT
      );
    ''';
    Database db = await DB.instance.database;
    await db.execute(table);
  }

  void _setupDadosTableMoeda() async {
    if (await moedasTableIsEmpy()) {
      String uri = 'https://api.coinbase.com/v2/assets/search?base=BRL';

      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> moedas = json['data'];

        Database db = await DB.instance.database;

        // Essa estrutura de batch serve para realizar o insert de vários registros
        // no banco de dados.
        // No término é dado um commit no banco.
        Batch batch = db.batch();

        moedas.forEach((moeda) {
          final preco = moeda['latest_price'];
          final timestamp = DateTime.parse(preco['timestamp']);

          batch.insert('moedas', {
            'baseId': moeda['id'],
            'sigla': moeda['symbol'],
            'nome': moeda['name'],
            'icone': moeda['image_url'],
            'preco': moeda['latest'],
            'timestamp': timestamp.millisecondsSinceEpoch,
            'mudancaHora': preco['percent_change']['hour'].toString(),
            'mudancaDia': preco['percent_change']['day'].toString(),
            'mudancaSemana': preco['percent_change']['week'].toString(),
            'mudancaMes': preco['percent_change']['month'].toString(),
            'mudancaAno': preco['percent_change']['year'].toString(),
            'mudancaPeriodoTotal': preco['percent_change']['all'].toString()
          });
        });

        // Realiza o commit.
        await batch.commit(noResult: true);

        await _readMoedasTable();
      }
    }
  }

  moedasTableIsEmpy() async {
    Database db = await DB.instance.database;

    List resultados = await db.query('moedas');

    return resultados.isEmpty;
  }

  _readMoedasTable() async {
    Database db = await DB.instance.database;
    List resultados = await db.query('moedas');

    _tabela = resultados.map((row) {
      return Moeda(
        baseId: row['baseId'],
        icone: row['icone'],
        sigla: row['sigla'],
        nome: row['nome'],
        preco: double.parse(row['preco']),
        timestamp: DateTime.fromMillisecondsSinceEpoch(row['timestamp']),
        mudancaHora: double.parse(row['mudancaHora']),
        mudancaDia: double.parse(row['mudancaDia']),
        mudancaSemana: double.parse(row['mudancaSemana']),
        mudancaMes: double.parse(row['mudancaMes']),
        mudancaAno: double.parse(row['mudancaAno']),
        mudancaPeriodoTotal: double.parse(row['mudancaPeriodoTotal']),
      );
    }).toList();

    notifyListeners();
  }
}
