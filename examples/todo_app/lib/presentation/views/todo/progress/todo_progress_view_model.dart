import 'package:fl_mvvm/fl_mvvm.dart';
import 'package:todo_app/app/dependencies/app_dependencies.dart';
import 'package:todo_app/domain/values/todo_progress.dart';
import 'package:todo_app/presentation/views/todo/todos_view_model.dart';

class TodoProgressViewModel extends FlViewModel<TodoProgress> {
  @override
  void buildDependencies() {
    var todos = serviceLocator.get<TodosViewModel>().value;

    int completeCount =
        todos?.where((element) => element.isComplete).length ?? 0;
    int inCompleteCount = (todos?.length ?? 0) - completeCount;

    setData(
        TodoProgress(completed: completeCount, inCompleted: inCompleteCount));
  }
}
