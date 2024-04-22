import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/domain/entities/todo.dart';
import 'package:todo_app/presentation/views/todo/todos_view_model.dart';
import 'package:uuid/uuid.dart';

void main() {
  late TodosViewModel viewModel;

  setUp(() {
    viewModel = TodosViewModel();
  });
  test('Adds Todo', () {
    var todos = viewModel.value ?? [];
    expect(todos.length, equals(0));
    final uuid = const Uuid().v8();
    Todo todo = Todo(uuid: uuid, title: 'Test TODO', isComplete: false);

    viewModel.addTodo(todo);
    todos = viewModel.value ?? [];
    expect(todos.length, equals(1));
    expect(
        todos.firstWhereOrNull(
          (element) => element.uuid == uuid,
        ),
        isNot(isNull));
  });

  test('Sets Todo as completed', () {
    for (int i = 0; i < 3; i++) {
      viewModel.addTodo(Todo(
          uuid: const Uuid().v8(), title: 'Todo #${i + 1}', isComplete: false));
    }
    expect(
        viewModel.value!.where((element) => element.isComplete), hasLength(0));
    viewModel.setAsCompleted(viewModel.value!.first);
    expect(
        viewModel.value!.where((element) => element.isComplete), hasLength(1));
  });

  test('Sets Todo as incomplete', () {
    var todoCount = 3;
    for (int i = 0; i < todoCount; i++) {
      viewModel.addTodo(Todo(
          uuid: const Uuid().v8(), title: 'Todo #${i + 1}', isComplete: true));
    }
    expect(viewModel.value!.where((element) => element.isComplete),
        hasLength(todoCount));
    viewModel.setAsCompleted(viewModel.value!.first, completed: false);
    expect(viewModel.value!.where((element) => element.isComplete),
        hasLength(todoCount - 1));
  });

  test('Removes todo', () {
    var todoCount = 2;
    for (int i = 0; i < todoCount; i++) {
      viewModel.addTodo(Todo(
          uuid: const Uuid().v8(), title: 'Todo #${i + 1}', isComplete: false));
    }
    expect(viewModel.value!.length, equals(todoCount));
    var removedTodoUUID = viewModel.value!.first.uuid;
    viewModel.removeTodo(viewModel.value!.first);
    expect(viewModel.value!, hasLength(todoCount - 1));
    expect(viewModel.value!.where((element) => element.uuid == removedTodoUUID),
        hasLength(0));
  });

  test('Updates Todo description', () {
    var todoCount = 2;
    for (int i = 0; i < todoCount; i++) {
      viewModel.addTodo(Todo(
          uuid: const Uuid().v8(), title: 'Todo #${i + 1}', isComplete: false));
    }
    expect(viewModel.value!.length, equals(todoCount));
    var todoUUID = viewModel.value!.first.uuid;
    String description = "description";
    expect(
        viewModel.value!.where((element) => element.description == description),
        hasLength(0));
    viewModel.updateTodoDescription(viewModel.value!.first,
        description: description);
    expect(
        viewModel.value!.where((element) =>
            element.uuid == todoUUID && element.description == description),
        hasLength(1));
  });
}
