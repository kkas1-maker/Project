import 'dart:async'; // Importa a biblioteca para operações assíncronas (que demoram um tempo)
import 'package:path/path.dart'; // Importa a biblioteca para lidar com caminhos de pastas no celular
import 'package:sqflite/sqflite.dart'; // Importa o pacote oficial do banco de dados SQLite no Flutter

class DBHelper { // cria a classe que vai gerenciar o banco de dados
  Future<Database> initDB() async { // função assincrona que retorna o banco
    String path = await getDatabasesPath();
    String dbName = 'financeiro.db'; // define nome do arquivo

    String dbPath = join(path, dbName); // junta a pasta com o nome do arquivo

    // abre o banco. Se nao existir, cria com o onCreateDB
    Database db = await openDatabase(dbPath, version: 1, onCreate: onCreateDB);

    return db; // retorna o banco
  }

  // função que roda na primeira vez que o app é instalado para criar a tabela
  FutureOr<void> onCreateDB(Database db, int version) async {
    String sql = ''' CREATE TABLE transacoes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            valor REAL,
            isEntrada INTEGER,
            categoria TEXT,
            data TEXT
        );'''; // O comando em sql para criar a tabela com suas colunas e tipos de dados

    await db.execute(sql); // executa o comando sql acima direto no banco
  }
}