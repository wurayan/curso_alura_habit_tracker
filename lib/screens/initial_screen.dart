import 'package:flutter/material.dart';
import 'package:nosso_primeiro_projeto/data/task_inherited.dart';
import 'package:nosso_primeiro_projeto/screens/form_screen.dart';

import '../components/task.dart';
import '../data/task_dao.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
        title: const Text('Tarefas'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 8, bottom: 70),
        //como nós sabemos que o snapshot retorna uma lista de Task
        //então declaramos no futurebuilder que a informação que ele
        //vai trabalhar é uma lista de task
        child: FutureBuilder<List<Task>>(
            future: TaskDao().findAll(),
            builder: (context, snapshot) {
              List<Task>? items = snapshot.data;
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(
                    child: Column(
                      children: const [
                        CircularProgressIndicator(),
                        Text("Carregando...")
                      ],
                    ),
                  );
                  break;
                case ConnectionState.waiting:
                  return Center(
                    child: Column(
                      children: const [
                        CircularProgressIndicator(),
                        Text("Carregando...")
                      ],
                    ),
                  );
                  break;
                case ConnectionState.active:
                  return Center(
                    child: Column(
                      children: const [
                        CircularProgressIndicator(),
                        Text("Carregando...")
                      ],
                    ),
                  );
                  break;
                case ConnectionState.done:
                  if (snapshot.hasData && items != null) {
                    if (items.isNotEmpty) {
                      return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          final Task tarefa = items[index];
                          return tarefa;
                        },
                        itemCount: items.length,
                      );
                    }
                    //retorno caso conecta mas a lista ta vazia
                    return Center(
                        child: Column(
                      children: const [
                        Icon(
                          Icons.error_outline,
                          size: 128,
                        ),
                        Text(
                          "Não há nenhuma tarefa!",
                          style: TextStyle(fontSize: 32),
                        )
                      ],
                    ));
                  }
                  //retorno quando o snapshot não tem dados ou é null
                  return Text('Erro ao carregar Tarefas.');
                  break;
              }
              return Text('Erro desconhecido');
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              //a adição de new em context(contextNew) é só para exemplificar que o
              //contexto utilizado para criar a formscreen não é o mesmo
              //do taskinherited usado anteriormente e diferenciar na
              //hora de declara-lo no formscreen
              builder: (contextNew) => FormScreen(
                taskContext: context,
              ),
            ),
            //setstate atualiza a página?
          ).then((value) => setState(() {}));
          //Navigator.of(context).pushReplacementNamed("/form");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
