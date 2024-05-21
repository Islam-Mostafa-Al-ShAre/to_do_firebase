import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_firebase/models/todo.dart';
import 'package:to_do_firebase/services/database_service.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          displayAddTodo();
        },
        backgroundColor: const Color.fromARGB(255, 61, 127, 207),
        child: Icon(Icons.add),
      ),
      appBar: myAppBar(),
      body: bulidUI(),
    );
  }

  AppBar myAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 61, 127, 207),
      title: const Text("ToDo"),
      centerTitle: true,
    );
  }

  Widget bulidUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
          messageListView(),
        ],
      ),
    );
  }

  Widget messageListView() {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * .8,
      child: StreamBuilder(
        builder: (context, snapshot) {
          List todos = snapshot.data?.docs ?? [];
          if (todos.isEmpty) {
            return const Center(
                child: Text(
              "Add Todo",
              style: TextStyle(fontSize: 30),
            ));
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              itemBuilder: (context, index) {
                Todo todo = todos[index].data();
                String todoId = todos[index].id;
                return Card(
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    tileColor: const Color.fromARGB(255, 156, 189, 230),
                    title: Text(todo.task),
                    subtitle: Text(DateFormat("yyyy-mm-dd h :m s ")
                        .format(todo.updateOn.toDate())),
                    trailing: Checkbox(
                      value: todo.isDone,
                      onChanged: (value) {
                        Todo updeatedTodo = todo.copyWith(
                            isDone: !todo.isDone, updateOn: Timestamp.now());
                        _databaseService.updateTodo(todoId, updeatedTodo);
                      },
                    ),
                    leading: IconButton(
                      onPressed: () {
                        _databaseService.deleteTodo(todoId);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    titleTextStyle: const TextStyle(fontSize: 20),
                  ),
                );
              },
              itemCount: todos.length,
            ),
          );
        },
        stream: _databaseService.getTodos(),
      ),
    );
  }

  void displayAddTodo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text("Add Todo"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Todo newTodo = Todo(
                      task: _textEditingController.text,
                      isDone: false,
                      createOn: Timestamp.now(),
                      updateOn: Timestamp.now());
                  _databaseService.addTodo(newTodo);
                  _textEditingController.clear();
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
            content: TextField(
              decoration: const InputDecoration(hintText: " Write Todo"),
              controller: _textEditingController,
            ));
      },
    );
  }
}
