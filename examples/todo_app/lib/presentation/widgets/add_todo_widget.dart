import 'package:flutter/material.dart';
import 'package:todo_app/app/dependencies/app_dependencies.dart';
import 'package:todo_app/presentation/views/todo/todos_view_model.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/todo.dart';

class AddTodoWidget extends StatefulWidget {
  const AddTodoWidget({super.key});

  @override
  State<AddTodoWidget> createState() => _AddTodoWidgetState();
}

class _AddTodoWidgetState extends State<AddTodoWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 80,
        child: Row(
          children: [
            Expanded(
                child: TextField(
              onSubmitted: _createTodoFromTitle,
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'What\'s on your mind?',
              ),
            )),
            const SizedBox(
              width: 12,
            ),
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepPurpleAccent,
              ),
              child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    _createTodoFromTitle(_controller.text);
                  },
                  icon: const Icon(Icons.add)),
            )
          ],
        ));
  }

  _createTodoFromTitle(String title) {
    if (title.isEmpty) return;
    serviceLocator.get<TodosViewModel>().addTodo(Todo(
          isComplete: false,
          title: _controller.text,
          uuid: const Uuid().v8(),
        ));
    _controller.clear();
  }
}
