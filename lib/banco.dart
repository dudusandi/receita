import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> inicializarBancoDados() async {
  final caminhoBanco = await getDatabasesPath();
  final caminho = join(caminhoBanco, 'receitas.db');

  return openDatabase(
    caminho,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE receitas(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          titulo TEXT NOT NULL,
          descricao TEXT,
          tempoPreparo INTEGER,
          tag TEXT,
          categoria TEXT,
          dataCriacao TEXT
        )
      ''');
    },
  );
}

// Função para adicionar uma nova receita
Future<int> adicionarReceita(String titulo, String descricao, int tempoPreparo, String tag, String categoria) async {
  final db = await inicializarBancoDados();
  
  final dataAtual = DateTime.now().toIso8601String();
  
  final Map<String, dynamic> receita = {
    'titulo': titulo,
    'descricao': descricao,
    'tempoPreparo': tempoPreparo,
    'tag': tag,
    'categoria': categoria,
    'dataCriacao': dataAtual
  };
  
  return await db.insert('receitas', receita);
}

// Buscar todas as receitas
Future<List<Map<String, dynamic>>> buscarTodasReceitas() async {
  final db = await inicializarBancoDados();
  return await db.query('receitas');
}

// Buscar receitas por categoria
Future<List<Map<String, dynamic>>> buscarReceitasPorCategoria(String categoria) async {
  final db = await inicializarBancoDados();
  return await db.query(
    'receitas',
    where: 'categoria LIKE ?',
    whereArgs: ['%$categoria%']
  );
}

// Buscar receitas por tag
Future<List<Map<String, dynamic>>> buscarReceitasPorTag(String tag) async {
  final db = await inicializarBancoDados();
  return await db.query(
    'receitas',
    where: 'tag LIKE ?',
    whereArgs: ['%$tag%']
  );
}

// Buscar receitas por texto em todos
Future<List<Map<String, dynamic>>> buscarReceitasPorTexto(String texto) async {
  final db = await inicializarBancoDados();
  return await db.query(
    'receitas',
    where: 'titulo LIKE ? OR descricao LIKE ?',
    whereArgs: ['%$texto%', '%$texto%']
  );
}

// Atualizar uma receita
Future<int> atualizarReceita(int id, String titulo, String descricao, int tempoPreparo, String tag, String categoria) async {
  final db = await inicializarBancoDados();
  
  final Map<String, dynamic> receita = {
    'titulo': titulo,
    'descricao': descricao,
    'tempoPreparo': tempoPreparo,
    'tag': tag,
    'categoria': categoria
  };
  
  return await db.update(
    'receitas',
    receita,
    where: 'id = ?',
    whereArgs: [id]
  );
}

// Função para excluir uma receita
Future<int> excluirReceita(int id) async {
  final db = await inicializarBancoDados();
  return await db.delete(
    'receitas',
    where: 'id = ?',
    whereArgs: [id]
  );
}