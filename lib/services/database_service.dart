// ignore: constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_firebase/models/todo.dart';

const String TODOS_REF = "todos";

class DatabaseService {
  final _firebase = FirebaseFirestore.instance;

  late final CollectionReference _todosRef;

  DatabaseService() {
    _todosRef = _firebase.collection(TODOS_REF).withConverter<Todo>(
          fromFirestore: (snapshot, _) => Todo.fromJson(
            snapshot.data()!,
          ),
          toFirestore: (todo, _) => todo.toJson(),
        );
  }

  Stream<QuerySnapshot> getTodos() {
    return _todosRef.snapshots();
  }

  void addTodo(Todo todo) async {
    await _todosRef.add(todo);
  }

  void updateTodo(String todoId, Todo todo) {
    _todosRef.doc(todoId).update(todo.toJson());
  }

  void deleteTodo(String todoId) {
    _todosRef.doc(todoId).delete();
  }
}
