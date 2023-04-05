import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _recuperarDB() async {
    final caminhoDB = await getDatabasesPath();
    final localDB = p.join(caminhoDB, 'banco.db');
    var db =
    await openDatabase(localDB, version: 1, onCreate: (db, versaoAtual) {
      String sql =
          'CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)';
      db.execute(sql);
    });
    return db;
  }

  _registrarUsuario() async {
    Database db = await _recuperarDB();
    Map<String, dynamic> dadosUsuario = {
      "nome": "Naty",
      "idade": 22
    };
    int id = await db.insert('usuarios', dadosUsuario);
    print('$id');
    return id;
  }

  _listarUsuarios() async {
    Database db = await _recuperarDB();
    List usuarios = await db.rawQuery('SELECT * FROM usuarios');
    for(var usuario in usuarios){
      print("usuarios: ${usuario['id']}, nome: ${usuario['nome']}, idade: ${usuario['idade']}");
    }
  }

  _listaUsuarioPorID(int id) async {
    Database db = await _recuperarDB();
    List usuario = await db.query(
        'usuarios',
        columns: ['id', 'nome', 'idade'],
        where: 'id = ?',
        whereArgs: [id] );
    for(var user in usuario){
      print("usuario: ${user['id']}, nome: ${user['nome']}, idade: ${user['idade']}");
    }
    return usuario;
  }

  _deletarUsuario(int id) async {
    Database db = await _recuperarDB();
    int linhasExcluidas = await db.delete(
        'usuarios',
        where: 'id = ?',
        whereArgs: [id],
    );

  }

  _alterarUsuario(int id) async {
    Database db = await _recuperarDB();
    Map<String, dynamic> dadosUsuario = {
      "nome": "Naty Fontes",
      "idade": 22
    };
    int linhasAlteradas = await db.update(
    'usuarios',
    dadosUsuario,
    where: 'id = ?',
    whereArgs: [id],
    );
  }

  @override
  Widget build(BuildContext context) {
    //_listaUsuarioPorID(2);
    //_alterarUsuario(3);
    _listarUsuarios();
    //_registrarUsuario();
    //_deletarUsuario(2);
    return const Placeholder();
  }

}
