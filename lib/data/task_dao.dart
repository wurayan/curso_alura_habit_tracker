import 'package:nosso_primeiro_projeto/data/database.dart';
import 'package:sqflite/sqflite.dart';

import '../components/task.dart';

/*
  DAO = Data Acces Object
  para promover a boa prática do código é necessário usar o conceito de
  refatoração e reduzir as resonsabilidades de cada arquivo ao seu espaço
  correto.
  no caso do database.dart, possui tanto o método quando a classe/objeto
  portanto foi criado o DAO, um arquivo que retém o objeto da database
*/

//TO-DO: IMPLEMENTAR UMA CHAVE ID NAS TABELAS USANDO UUID PLUGIN

class TaskDao {
  static const String _tablename = 'taskTable';
  static const String _difficulty = 'difficulty';
  static const String _name = 'name';
  static const String _image = 'image';

  static const String tableSql = 'CREATE TABLE $_tablename('
      '$_name TEXT,'
      '$_difficulty INT,'
      '$_image TEXT)';

  save(Task tarefa) async {
    //essa função exerce o INSERT  e o UPDATE simultaneamente, primeiro
    //faz a verificação se o item já existe, se sim ele atualizaq o item,
    //se não, ele cria. Impedindo assim a duplicação de itens no DB
    print('iniciando save');
    final Database bancoDeDados = await getDataBase();
    var itemExists = await find(tarefa.nome); //a função find é future
    Map<String, dynamic> taskMap = toMap(tarefa); //converte tarefa em map
    if (itemExists.isEmpty) {
      print('a tarefa não existia');
      return await bancoDeDados.insert(_tablename, taskMap);
    } else {
      print("já existe a tarefa");
      //ao realizar o update, atualizamos todas as infos, porém como o nome
      //utilizado para pesquisar é o mesmo que já está no map, o nome
      //mantém mesmo aatualizado
      return await bancoDeDados.update(_tablename, taskMap,
          where: '$_name = ?', whereArgs: [tarefa.nome]);
    }

    //create/insert
    //int recordId = await db.insert(
    //'my_table', {'name': 'my_name', 'type': 'my_type'});
    //update
    //var count = await db.update(
    //'my_table', {'name': 'new cat name'}, where: 'name = ?', whereArgs: ['cat']);
  }

  delete(String nomeDaTarefa) async {
    print("deletando tarefa");
    final Database bancoDeDados = await getDataBase();
    return await bancoDeDados.delete(
      _tablename,
      where: '$_name = ?',
      whereArgs: [nomeDaTarefa],
    );

    //var count = await db.delete(
    //'my_table', where: 'name = ?', whereArgs: ['cat']);
  }

  Future<List<Task>> findAll() async {
    print('conferindo acesso ao findAll');
    final Database bancoDeDados = await getDataBase();
    //a List recebe um map (tipo dicionário), que tem uma "key"(nome da coluna)
    //de tipo String(nome,dificuldade,etc) e uma resposta dynamic, ou seja,
    //pode ser de vários tipos.
    //ex: String nome = String tarefa; String dificuldade = Int 2
    final List<Map<String, dynamic>> result =
        await bancoDeDados.query(_tablename);
    print('findAll $result');
    //agora precisamos convertes a lista de mapas do query em uma lista
    //de tarefas
    return toList(result);
    //simplificado na doc do SQflite
    //var list = await db.query('my_table', columns: ['name', 'type']);
  }

  Future<List<Task>> find(String nomeDaTarefa) async {
    print('conferindo acesso a find');
    final Database bancoDeDados = await getDataBase();
    final List<Map<String, dynamic>> result = await bancoDeDados
        .query(_tablename, where: '$_name = ?', whereArgs: [nomeDaTarefa]);
    //será que funciona usar o like e colocar %__%(contém), para o user
    //localizar qualqur tarefa que contenha o termo pesquisado e não
    //o resultado exato
    print('find $result');
    return toList(result);
    //simplificado na doc do SQflite
    //var list = await db.query('my_table',
    //    columns: ['name'], where: 'name LIKE ?', whereArgs: ['Ta%']);
  }

  List<Task> toList(List<Map<String, dynamic>> mapaDeTarefas) {
    print('convertendo tolist');
    final List<Task> tarefas = [];
    for (Map<String, dynamic> linha in mapaDeTarefas) {
      final Task tarefa = Task(linha[_name], linha[_image], linha[_difficulty]);
      tarefas.add(tarefa);
    }
    print(tarefas);
    return tarefas;
  }

  Map<String, dynamic> toMap(Task tarefa) {
    print('convertendo tarefa para map');
    final Map<String, dynamic> mapaDeTarefas = Map();
    mapaDeTarefas[_name] = tarefa.nome;
    mapaDeTarefas[_difficulty] = tarefa.dificuldade;
    mapaDeTarefas[_image] = tarefa.foto;
    print("mapa $mapaDeTarefas");
    return mapaDeTarefas;
  }
}
