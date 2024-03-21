import 'package:flutter/material.dart';
import 'package:todo_app/presentation/views/todo/details/tood_details_view.dart';

navigateToTodoDetails(BuildContext context, {required String todoId}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, _, __) {
        return TodoDetailsView(todoId: todoId);
      },
      transitionDuration: const Duration(
        milliseconds: 400,
      ),
      reverseTransitionDuration: const Duration(
        milliseconds: 400,
      ),
      transitionsBuilder: (_, animation, __, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(
          curve: Curves.easeInOut,
        ));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
  );
}
