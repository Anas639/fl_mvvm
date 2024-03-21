import 'package:fl_mvvm/fl_mvvm.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/presentation/views/todo/details/todo_details_view_model.dart';
import 'package:todo_app/presentation/widgets/dialogs/confirmation_dialog.dart';

class TodoDetailsView extends FlView<TodoDetailsViewModel> {
  final String todoId;

  const TodoDetailsView({
    super.key,
    required this.todoId,
  });

  @override
  Widget? buildContainer(
    BuildContext context,
    Widget child,
    TodoDetailsViewModel viewModel,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Details",
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final todoName = viewModel.value?.title ?? '';
                    return ConfirmationDialog(
                      message:
                          "Are you sure you want to permanently delete \"$todoName\"?",
                      onConfirm: () {
                        viewModel.handleDeleteTodoPressed();
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.delete_forever_rounded,
                color: Colors.redAccent,
              ))
        ],
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 32,
            ),
            child: child),
      ),
    );
  }

  @override
  Widget buildDataState(BuildContext context, TodoDetailsViewModel viewModel) {
    var todo = viewModel.value;
    if (todo == null) return buildEmptyState(context, viewModel);
    debugPrint('Building details of ${todo.title}');
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                todo.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Checkbox(
              value: todo.isComplete,
              onChanged: (value) {
                viewModel.handleCompletedCheckboxChanged(
                  todo,
                  isCompleted: value ?? false,
                );
              },
            )
          ],
        ),
        const SizedBox(
          height: 36,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: TextField(
              controller: TextEditingController(
                text: todo.description,
              ),
              onSubmitted: viewModel.handleDescriptionChanged,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  hintText: "Describe your task",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: const Icon(
                    Icons.edit_note_rounded,
                  ),
                  enabledBorder: InputBorder.none),
              maxLines: null,
              minLines: 1,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ),
        )
      ],
    );
  }

  @override
  TodoDetailsViewModel createViewModel() {
    return TodoDetailsViewModel(id: todoId);
  }
}
