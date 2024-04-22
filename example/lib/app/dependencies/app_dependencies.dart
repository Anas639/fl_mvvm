import 'package:get_it/get_it.dart';
import 'package:todo_app/presentation/views/todo/todos_view_model.dart';

final serviceLocator = GetIt.instance;

sealed class AppDependencies {
  static Future injectDependencies() async {
    serviceLocator
        .registerLazySingleton<TodosViewModel>(() => TodosViewModel());
  }
}
