import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  // Construtor com acesso privado para implementação de um Singleton
  DB._();

  // Criar uma instância de DB

  static final DB instance = DB._();

  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  /// Realiza a exclusão do banco de dados.
  _deleteDatabse() async {
    final path = join(await getDatabasesPath(), 'cripto.db');
    await deleteDatabase(path);
    print('Banco de dados excluído.');
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'cripto.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(Database db, int version) async {
    await db.execute(_conta);
    await db.execute(_carteira);
    await db.execute(_historico);
    await db.insert('conta', {'saldo': 0.0});
  }

  String get _conta => '''
    CREATE TABLE conta (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      saldo REAL
    )
  ''';

  // Quantidade está como TEXT por causa da quantidade de casas decimais.
  // No sqflite, quando se precisa de muitas casas decimais, o correto é salvar
  // em text e quando for pesquisado realizar o parse para double.
  String get _carteira => '''
    CREATE TABLE carteira (
      sigla TEXT PRIMARY KEY,
      moeda TEXT,
      quantidade TEXT
    )
  ''';

  // Aqui a data é salva como INT pois é possível fazer o parse para um objeto
  // de data.
  String get _historico => '''
    CREATE TABLE historico (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      data_operacao INT,
      tipo_operacao TEXT,
      moeda TEXT,
      sigla TEXT,
      valor REAL,
      quantidade TEXT
    )
  ''';
}
