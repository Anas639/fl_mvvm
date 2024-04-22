import 'package:fl_mvvm/fl_mvvm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/app/dependencies/app_dependencies.dart';
import 'package:todo_app/domain/entities/todo.dart';
import 'package:todo_app/presentation/views/todo/todos_view.dart';
import 'package:todo_app/presentation/views/todo/todos_view_model.dart';
import 'package:todo_app/presentation/widgets/todo_list_item.dart';
import 'package:uuid/uuid.dart';

void main() {
  late Signal<FlState<List<Todo>>> state;
  late TodosViewModel mockViewModel;

  Future pumpTodosView(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TodosView(),
      ),
    );
  }

  setUp(() {
    registerFallbackValue(const Todo(
      uuid: "",
      title: "",
      isComplete: false,
    ));
    state = signal(const FlEmptyState());
    mockViewModel = MockTodosViewModel();
    serviceLocator.registerSingleton<TodosViewModel>(mockViewModel);
    when(() => mockViewModel.isInitialized).thenReturn(true);
    when(() => mockViewModel.state).thenReturn(state);
    when(() => mockViewModel.value).thenAnswer((_) => state.value.data);
    when(() => mockViewModel.addTodo(
          any<Todo>(),
        )).thenAnswer((invocation) {
      var todo = invocation.positionalArguments.first;
      state.value = FlDataState([
        ...?state.value.data,
        todo,
      ]);
    });
  });

  tearDown(() {
    state.dispose();
    serviceLocator.unregister<TodosViewModel>();
  });

  testWidgets('Displays Todos inside a ListView', (tester) async {
    await pumpTodosView(tester);
    expect(find.byType(ListView), findsNothing);
    mockViewModel.addTodo(
        Todo(uuid: const Uuid().v8(), title: 'My Todo', isComplete: false));
    await tester.pumpAndSettle();
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TodoListItem), findsOneWidget);
    expect(find.text('My Todo'), findsOne);
  });

  testWidgets('Calls setAsCompleted when a checkbox is pressed ',
      (tester) async {
    await pumpTodosView(tester);
    String uuid = const Uuid().v8();
    mockViewModel
        .addTodo(Todo(uuid: uuid, title: 'My Todo', isComplete: false));
    await tester.pumpAndSettle();
    var checkbox = find.byType(Checkbox);

    expect(checkbox, findsOneWidget);
    await tester.tap(checkbox);
    await tester.pumpAndSettle();
    verify(() => mockViewModel.setAsCompleted(
          any(
            that: isA<Todo>().having((t) => t.uuid, 'uuid', uuid),
          ),
          completed: true,
        )).called(1);
  });
}

class MockTodosViewModel extends Mock implements TodosViewModel {}
