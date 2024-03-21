import 'package:fl_mvvm/fl_mvvm.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/app/dependencies/app_dependencies.dart';
import 'package:todo_app/presentation/todo_item_provider.dart';
import 'package:todo_app/presentation/views/todo/progress/todo_progress_view.dart';
import 'package:todo_app/presentation/views/todo/todos_view_model.dart';
import 'package:todo_app/presentation/widgets/add_todo_widget.dart';
import 'package:todo_app/presentation/widgets/todo_list_item.dart';

class TodosView extends FlView<TodosViewModel> {
  const TodosView({super.key});

  @override
  Widget? buildContainer(
      BuildContext context, Widget child, TodosViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: const TodoProgressView(),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 32,
          ),
          child: Column(
            children: [
              const AddTodoWidget(),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildEmptyState(BuildContext context, TodosViewModel viewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.checklist_rtl,
          size: 64,
          color: Colors.deepPurpleAccent.shade100,
        ),
        Text(
          "You don't have any tasks",
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ],
    );
  }

  @override
  Widget buildDataState(BuildContext context, TodosViewModel viewModel) {
    var todos = viewModel.value ?? [];
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
          /*  findChildIndexCallback: (key) {
            final ValueKey<String> valueKey = key as ValueKey<String>;
            int index =
                todos.indexWhere((element) => valueKey.value == element.uuid);
            debugPrint("findchildindexcallback $key, $index");
            if (index < 0) return null;
            return index;
          },*/
          itemBuilder: (context, index) {
            var todo = todos[index];
            return TodoItemProvider(todo, child: const TodoListItem());
          },
          itemCount: todos.length,
        ))
      ],
    );
  }

  @override
  TodosViewModel createViewModel() {
    return serviceLocator.get<TodosViewModel>();
  }
}
