import 'package:nosso_primeiro_projeto/data/task_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//TO-DO: alterar o código para salvar os níveis das tarefas também

Future<Database> getDataBase() async {
  //pega a path até o banco de dados dentro do dispositivo
  final String path = join(await getDatabasesPath(),"task.db");
  return openDatabase(
    //onCreate, cria a tabela caso não encontre a mesma
    path, onCreate: 
      (db, version) {db.execute(TaskDao.tableSql);},version: 1,);
}