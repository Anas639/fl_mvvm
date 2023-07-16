import 'dart:async';

import 'package:example/models/example_model.dart';
import 'package:fl_mvvm/fl_mvvm.dart';

class ExampleViewModel extends FlViewModel<List<ExampleModel>> {
  final int _numberOfItems;

  ExampleViewModel({required int numberOfItems})
      : _numberOfItems = numberOfItems;

  List<ExampleModel> get exampleList => value ?? [];

  @override
  FutureOr<List<ExampleModel>?> build() {
    return _loadList();
  }

  Future<List<ExampleModel>> _loadList() async {
    return Future.value(
      List.generate(
        _numberOfItems,
        (index) => ExampleModel(index + 1, "I'm the item number ${index + 1}"),
      ),
    );
  }

  void reload() async {
    setLoading();
    await Future.delayed(const Duration(seconds: 1));
    state = await AsyncValue.guard(() => _loadList());
  }

  void reloadWithError() async {
    setLoading();
    await Future.delayed(const Duration(seconds: 1));
    state =
        AsyncValue.error(Exception("This is an exception"), StackTrace.current);
  }
}
