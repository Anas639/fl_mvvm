import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'todo.g.dart';

@immutable
@CopyWith(skipFields: true)
class Todo extends Equatable {
  final String uuid;
  final DateTime? dueDate;
  final bool isComplete;
  final String title;
  final String? description;

  const Todo({
    required this.uuid,
    required this.title,
    this.dueDate,
    required this.isComplete,
    this.description,
  });

  @override
  List<Object?> get props => [
        uuid,
        isComplete,
        title,
        description,
      ];
}
