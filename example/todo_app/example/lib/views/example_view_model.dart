import 'dart:async';

import 'package:example/models/example_model.dart';
import 'package:fl_mvvm/fl_mvvm.dart';

class ExampleViewModel extends FlViewModel<List<ExampleModel>> {
  final int _numberOfItems;

  ExampleViewModel({required int numberOfItems})
      : _numberOfItems = numberOfItems;

  List<ExampleModel> get exampleList => value ?? [];

  @override
  onViewInitialized() {
    super.onViewInitialized();
    setFutureData(_loadList());
  }

  Future<List<ExampleModel>> _loadList() async {
    return List.generate(
      _numberOfItems,
      (index) => ExampleModel(index + 1, "I'm the item number ${index + 1}"),
    );
  }

  void reload() async {
    setFutureData(
      Future.delayed(
          const Duration(
            seconds: 1,
          ), () {
        return _loadList();
      }),
    );
  }

  void reloadWithError() async {
    setFutureData(
      Future.delayed(
        const Duration(seconds: 1),
        () {
          return Future.error(Exception("This is an Exception"));
        },
      ),
    );
  }
}
