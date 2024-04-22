import 'package:fl_mvvm/fl_mvvm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/app/dependencies/app_dependencies.dart';
import 'package:todo_app/domain/entities/todo.dart';
import 'package:todo_app/presentation/views/todo/details/todo_details_view_model.dart';
import 'package:todo_app/presentation/views/todo/todos_view_model.dart';
import 'package:uuid/uuid.dart';

void main() {
  late TodosViewModel mockTodosViewModel;
  late Signal<FlState<List<Todo>>> state;
  final List<Todo> todos = [
    for (int i = 0; i < 3; i++)
      Todo(uuid: const Uuid().v8(), title: "Task #${i + 1}", isComplete: false),
  ];
  setUpAll(() {
    registerFallbackValue(const Todo(
      isComplete: false,
      title: '',
      uuid: '',
    ));
  });

  setUp(() {
    state = signal(FlDataState(todos));
    mockTodosViewModel = MockTodosViewModel();
    when(() => mockTodosViewModel.state).thenReturn(state);
    when(() => mockTodosViewModel.value)
        .thenAnswer((invocation) => state.value.data);
    serviceLocator.registerSingleton<TodosViewModel>(mockTodosViewModel);
  });

  tearDown(() {
    serviceLocator.unregister<TodosViewModel>();
    state.dispose();
  });

  test('Loads todo by Id', () {
    TodoDetailsViewModel viewModel = TodoDetailsViewModel(id: todos.first.uuid);
    expect(viewModel.value, equals(todos.first));
  });

  test('Updates todo description', () {
    Todo todo = todos.first;
    TodoDetailsViewModel viewModel = TodoDetailsViewModel(id: todo.uuid);
    String description = "Hello World";
    viewModel.handleDescriptionChanged(description);
    verify(
      () => mockTodosViewModel.updateTodoDescription(todo,
          description: description),
    ).called(1);
  });
}

class MockTodosViewModel extends Mock implements TodosViewModel {}
