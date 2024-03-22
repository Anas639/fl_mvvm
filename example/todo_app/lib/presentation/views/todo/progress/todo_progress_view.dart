import 'package:fl_mvvm/fl_mvvm.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/domain/values/todo_progress.dart';
import 'package:todo_app/presentation/views/todo/progress/todo_progress_view_model.dart';

class TodoProgressView extends FlView<TodoProgressViewModel> {
  const TodoProgressView({super.key});

  @override
  Widget buildDataState(BuildContext context, TodoProgressViewModel viewModel) {
    var TodoProgress(:completed, :inCompleted, :progress) = viewModel.value!;
    return Row(
      children: [
        Text('$completed / ${completed + inCompleted}'),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: TweenAnimationBuilder<double>(
            builder: (context, value, child) {
              return LinearProgressIndicator(
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
                value: value,
              );
            },
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(
              milliseconds: 800,
            ),
            curve: Curves.easeInOut,
          ),
        ),
      ],
    );
  }

  @override
  TodoProgressViewModel createViewModel() {
    return TodoProgressViewModel();
  }
}
