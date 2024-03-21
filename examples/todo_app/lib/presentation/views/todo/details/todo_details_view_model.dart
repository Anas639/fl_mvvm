import 'package:collection/collection.dart';
import 'package:fl_mvvm/fl_mvvm.dart';
import 'package:todo_app/app/dependencies/app_dependencies.dart';
import 'package:todo_app/domain/entities/todo.dart';
import 'package:todo_app/presentation/views/todo/todos_view_model.dart';

class TodoDetailsViewModel extends FlViewModel<Todo> {
  final String id;

  TodoDetailsViewModel({required this.id});

  @override
  void buildDependencies() {
    var todos = serviceLocator.get<TodosViewModel>().value;
    setData(todos?.firstWhereOrNull(
      (element) => element.uuid == id,
    ));
  }

  void handleCompletedCheckboxChanged(
    Todo todo, {
    bool isCompleted = false,
  }) {
    serviceLocator.get<TodosViewModel>().setAsCompleted(
          todo,
          completed: isCompleted,
        );
  }

  void handleDescriptionChanged(String description) {
    var todo = value;
    if (todo == null) return;

    serviceLocator
        .get<TodosViewModel>()
        .updateTodoDescription(todo, description: description);
  }

  void handleDeleteTodoPressed() {
    var todo = value;
    if (todo == null) return;
    serviceLocator.get<TodosViewModel>().removeTodo(todo);
  }
}
