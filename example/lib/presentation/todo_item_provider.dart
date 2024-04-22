import 'package:flutter/cupertino.dart';
import 'package:todo_app/domain/entities/todo.dart';

class TodoItemProvider extends InheritedWidget {
  final Todo todo;

  const TodoItemProvider(this.todo, {super.key, required super.child});

  static TodoItemProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TodoItemProvider>();
  }

  @override
  bool updateShouldNotify(covariant TodoItemProvider oldWidget) {
    return oldWidget.todo != todo;
  }
}
