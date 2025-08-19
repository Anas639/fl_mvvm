import 'package:fl_mvvm/src/fl_state.dart';
import 'package:fl_mvvm/src/fl_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

class MyCustomLoadingState<T> implements FlState<T> {
  const MyCustomLoadingState({required this.progress, this.data});

  final double progress;

  @override
  final T? data;
}

class TestViewModel extends FlViewModel<String> {
  TestViewModel({super.autoDispose});
}

/// This view model depends on [TestViewModel] and it's value will always be [TestViewModel]'s value reversed
class ReverseStringViewModel extends FlViewModel<String> {
  final TestViewModel _testViewModel;
  ReverseStringViewModel(TestViewModel testViewModel) : _testViewModel = testViewModel;

  @override
  void buildDependencies() {
    String? reversed = _testViewModel.value?.split('').reversed.join();
    setData(reversed);
  }
}

void main() {
  late TestViewModel viewModel;

  setUp(() {
    viewModel = TestViewModel();
  });

  test('ViewModel is initialized with an Empty State', () {
    expect(viewModel.isEmpty, true);
  });
  test('Sets Data State', () {
    String value = "MyValue";
    viewModel.setData(value);
    expect(viewModel.state.peek(), isA<FlDataState>());
    expect(viewModel.value, value);
  });

  test('Sets Loading State', () {
    viewModel.setLoading();
    expect(viewModel.state.peek(), isA<FlLoadingState>());
    expect(viewModel.isLoadng, true);
  });

  test('Sets Error State', () {
    viewModel.setError(Exception());
    expect(viewModel.state.peek(), isA<FlErrorState>());
    expect(viewModel.errorMessage, isNotNull);
  });

  test('Sets Error Message from Exception', () {
    String errorMessage = "An Error Occurred!";
    viewModel.setError(Exception(errorMessage));
    expect(viewModel.state.peek(), isA<FlErrorState>());
    expect(viewModel.errorMessage, contains(errorMessage));
  });

  test('Sets Error from string', () {
    String errorMessage = "My Custom Error Message";
    viewModel.setError(errorMessage);
    expect(viewModel.state.peek(), isA<FlErrorState>());
    expect(viewModel.errorMessage, equals(errorMessage));
  });

  test('Sets Empty state', () {
    viewModel.setEmpty();
    expect(viewModel.state.peek(), isA<FlEmptyState>());
  });

  test('Clears value after setting empty state', () {
    viewModel.setData('data');
    viewModel.setEmpty();
    expect(viewModel.value, isNull);
  });

  test('Sets Data from a future', () async {
    String data = "My Future Data";
    Future<String> future = Future.value(data);
    viewModel.setFutureData(future);
    await viewModel.waitForStateChange<FlDataState>();
    expect(viewModel.value, equals(data));
  });

  test('Sets Error if future fails', () async {
    String errorMessage = "Error";
    Future<String> future = Future.error(errorMessage);
    viewModel.setFutureData(future);
    await viewModel.waitForStateChange<FlErrorState>();
    expect(viewModel.errorMessage, equals(errorMessage));
  });

  test('Change State to Loading before setting future data', () {
    Future<String> future = Future.delayed(const Duration(milliseconds: 100), () => "");
    viewModel.setFutureData(future);
    expect(viewModel.state.peek(), isA<FlLoadingState>());
  });

  test('Does not change state to Loading before setting future data if [withLoading] is false', () {
    Future<String> future = Future.delayed(const Duration(milliseconds: 100), () => "");
    viewModel.setFutureData(future, withLoading: false);
    expect(viewModel.state.peek(), isNot(isA<FlLoadingState>()));
  });

  test('Sets Custom State', () {
    viewModel.setState(const MyCustomLoadingState(progress: 10));
    expect(viewModel.state.peek(), isA<MyCustomLoadingState>());
  });

  test('View Model rebuilds when a dependency state is changed', () async {
    String data = "String";
    String data2 = "Hello";
    ReverseStringViewModel reverseStringViewModel = ReverseStringViewModel(viewModel);
    expect(reverseStringViewModel.value, isNull);
    viewModel.setData(data);
    expect(reverseStringViewModel.value, equals(data.split('').reversed.join()));
    viewModel.setData(data2);
    expect(reverseStringViewModel.value, equals(data2.split('').reversed.join()));
  });

  test('Veiw Model disposes when autoDispose is set to true', () {
    TestViewModel vm = TestViewModel(autoDispose: true);
    var unsubscribe = vm.state.subscribe((value) {});
    unsubscribe();
    expect(vm.state.disposed, true);
  });

  group('Testing Utils', () {
    test('waitForStateChange actually waits for state to change and returns the current state', () {
      String data = "abc";
      expectLater(viewModel.waitForStateChange(), completion(FlDataState(data)));
      viewModel.setData(data);
    });

    test('waitForStateChange with a type doesn\'t complete until the state is actually of that type', () {
      String data = "abc";
      expectLater(viewModel.waitForStateChange<FlDataState>(), completion(FlDataState(data)));
      viewModel.setLoading();
      viewModel.setData(data);
    });

    test('waitForStateChane doesn\'t emit previous state and actually waits for a new one', () {
      String data = "123";
      viewModel.setLoading();
      viewModel.setData("abc");
      viewModel.setData("def");
      viewModel.setData("ghi");
      expectLater(viewModel.waitForStateChange(), completion(FlDataState(data)));
      viewModel.setData(data);
    });

    test('waitForStateChange returns the value if compelts before the timeout', () {
      String data = "data";
      expectLater(viewModel.waitForStateChange(timeout: 500), completion(FlDataState(data)));
      viewModel.setData(data);
    });

    test('waitForStateChange stops waiting after the timeout is reached', () {
      expectLater(viewModel.waitForStateChange(timeout: 100), completion(null));
      Future.delayed(const Duration(milliseconds: 200), () => viewModel.setData("data"));
    });
  });

  group('dartz either', () {
    test('Sets data if response is right', () async {
      final String data = "my-data";
      Future<Either<String, String>> future() => Future.value(Right(data));
      viewModel.setEitherFuture(future());
      await viewModel.waitForStateChange<FlDataState>();
      expect(viewModel.value, equals(data));
    });

    test('Sets error if response is left', () async {
      final String error = "error";
      Future<Either<String, String>> future() => Future.value(Left(error));
      viewModel.setEitherFuture(future());
      await viewModel.waitForStateChange<FlErrorState>();
      expect(viewModel.errorMessage, equals(error));
    });
  });
}
