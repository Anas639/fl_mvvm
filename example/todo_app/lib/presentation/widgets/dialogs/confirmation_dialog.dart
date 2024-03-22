import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final Function? onConfirm;
  final Function? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.message,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirmation"),
      content: Text(message),
      actions: [
        ElevatedButton(
            onPressed: () {
              onConfirm?.call();
              Navigator.pop(context);
            },
            child: const Text("Confirm")),
        TextButton(
            onPressed: () {
              onCancel?.call();
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
      ],
    );
  }
}
