import 'package:flutter/material.dart';
import 'package:todo_app/app/dependencies/app_dependencies.dart';
import 'package:todo_app/presentation/routing/router.dart';
import 'package:todo_app/presentation/todo_item_provider.dart';
import 'package:todo_app/presentation/views/todo/todos_view_model.dart';

class TodoListItem extends StatefulWidget {
  const TodoListItem({super.key});

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  @override
  Widget build(BuildContext context) {
    var todo = TodoItemProvider.of(context)?.todo;
    if (todo == null) return const SizedBox.shrink();
    return Dismissible(
      onDismissed: (direction) {
        serviceLocator.get<TodosViewModel>().removeTodo(todo);
      },
      key: ObjectKey(todo),
      child: ListTile(
        onTap: () {
          // open details
          navigateToTodoDetails(context, todoId: todo.uuid);
        },
        trailing: Checkbox(
          value: todo.isComplete,
          onChanged: (value) {
            serviceLocator
                .get<TodosViewModel>()
                .setAsCompleted(todo, completed: value ?? false);
          },
        ),
        title: Text(todo.title),
        subtitle: todo.description == null ? null : Text(todo.description!),
        subtitleTextStyle: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: Colors.grey),
      ),
    );
  }
}

/*
class ExpensiveImage extends StatelessWidget {
  const ExpensiveImage({super.key});

  @override
  Widget build(BuildContext context) {
    var todo = TodoItemProvider.of(context)?.todo;
    debugPrint('building expensive image for ${todo?.title}');
    return const Placeholder(
      fallbackHeight: 150,
    );
    return const Placeholder();
  }
}
*/
