import 'package:fl_mvvm/fl_mvvm.dart';
import 'package:todo_app/domain/entities/todo.dart';

class TodosViewModel extends FlViewModel<List<Todo>> {
  void addTodo(Todo todo) {
    setData([
      if (value != null) ...value!,
      todo,
    ]);
  }

  setAsCompleted(
    Todo todo, {
    bool completed = true,
  }) {
    if (value == null) return;
    var todos = value!.toList();
    var index = todos.indexWhere((element) => element.uuid == todo.uuid);
    if (index < 0) return;
    todos.removeAt(index);
    todos.insert(
        index,
        todo.copyWith(
          isComplete: completed,
        ));
    setData(todos);
  }

  removeTodo(Todo todo) {
    if (value == null) return;
    var newList = value!.toList();
    newList.remove(todo);
    setData(newList);
  }

  updateTodoDescription(Todo todo, {required String description}) {
    if (value == null) return;
    setData([
      for (final todoItem in value!)
        if (todoItem == todo)
          todo.copyWith(description: description)
        else
          todoItem
    ]);
  }
}
