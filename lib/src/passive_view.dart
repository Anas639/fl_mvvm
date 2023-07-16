import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class PassiveView<T> extends ConsumerWidget {
  final StateNotifierProvider<StateNotifier<T>, T> notifier;

  const PassiveView(this.notifier, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref);

}
