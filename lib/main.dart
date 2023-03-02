import 'package:flutter/material.dart';
import 'package:nosso_primeiro_projeto/data/task_inherited.dart';
import 'package:nosso_primeiro_projeto/screens/form_screen.dart';
import 'package:nosso_primeiro_projeto/screens/initial_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //Ao colocar a taskinherited aqui, está anunciando que elá está acima
      //da intiilscreen, ou seja, acima de topdas as outras screens e 
      //todas as screens tem acesso as informações dentro de taskinherited
      //um bom metodo de se conferir a hierarquia é utilizar a arvore de widgets
      home: TaskInherited(child: const InitialScreen()),
      //home é desnecessário se está usando o route
      /*
      initialRoute: "/initial",
      routes: {
        "/initial": (context) => InitialScreen(),
      },
      */
    );
  }
}







