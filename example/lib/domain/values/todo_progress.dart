class TodoProgress {
  final int completed;
  final int inCompleted;

  double get progress {
    int total = completed + inCompleted;
    if (total == 0) return 0;
    return ((completed) / (completed + inCompleted));
  }

  const TodoProgress({
    required this.completed,
    required this.inCompleted,
  });
}
