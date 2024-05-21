import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String task;
  final bool isDone;
  final Timestamp createOn;
  final Timestamp updateOn;

  Todo({
    required this.task,
    required this.isDone,
    required this.createOn,
    required this.updateOn,
  });

  Todo.fromJson(Map<String, Object?> json)
      : this(
          task: json["task"] as String,
          isDone: json["isDone"] as bool,
          createOn: json["createOn"] as Timestamp,
          updateOn: json["updateOn"] as Timestamp,
        );

  Todo copyWith(
      {String? task, bool? isDone, Timestamp? createOn, Timestamp? updateOn}) {
    return Todo(
        task: task ?? this.task,
        isDone: isDone ?? this.isDone,
        createOn: createOn ?? this.createOn,
        updateOn: updateOn ?? this.updateOn);
  }

  Map<String, Object?> toJson() {
    return {
      "task": task,
      "isDone": isDone,
      "createOn": createOn,
      "updateOn": updateOn
    };
  }
}
