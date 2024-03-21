import 'package:mocktail/mocktail.dart';
import 'package:todo_app/presentation/views/todo/todos_view_model.dart';

class MockTodosViewModel extends Mock implements TodosViewModel {
  @override
  bool get isInitilized => false;
}
