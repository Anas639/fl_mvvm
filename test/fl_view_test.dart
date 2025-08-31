import 'package:fl_mvvm/src/fl_state.dart';
import 'package:fl_mvvm/src/fl_view.dart';
import 'package:fl_mvvm/src/fl_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'fl_view_test.mocks.dart';

class MyCustomLoadingState<T> implements FlState<T> {
  const MyCustomLoadingState({required this.progress, this.data});

  final double progress;

  @override
  final T? data;
}

class TestViewModel extends FlViewModel<String> {}

class TestView extends FlView<TestViewModel> {
  const TestView({super.key, super.viewModel, super.keepViewModelAlive, this.viewDisposed});
  final Function? viewDisposed;

  @override
  void onDispose() {
    viewDisposed?.call();
  }

  @override
  Widget? buildContainer(BuildContext context, Widget child, TestViewModel viewModel) {
    return Scaffold(
      body: child,
    );
  }

  @override
  Widget buildDataState(BuildContext context, TestViewModel viewModel) {
    return Text("Data State ${viewModel.value}");
  }

  @override
  Widget buildEmptyState(BuildContext context, TestViewModel viewModel) {
    return const Text("Empty State");
  }

  @override
  Widget buildErrorState(BuildContext context, TestViewModel viewModel, String error) {
    return Text(error);
  }

  @override
  Widget buildLoadingState(BuildContext context, TestViewModel viewModel) {
    return const Text("Loading State");
  }

  @override
  Widget buildCustomState(BuildContext context, FlState state, TestViewModel viewModel) {
    return const Text('Custom State');
  }
}

@GenerateNiceMocks([MockSpec<TestViewModel>()])
void main() {
  late TestViewModel viewModel;

  Future loadTestViewt(WidgetTester tester) {
    return tester.pumpWidget(MaterialApp(
      home: TestView(viewModel: viewModel),
    ));
  }

  setUp(() {
    viewModel = TestViewModel();
  });

  testWidgets('Renders Empty State by dfault', (tester) async {
    await loadTestViewt(tester);
    expect(find.text('Empty State'), findsOne);
  });

  testWidgets('Renders Data State', (tester) async {
    await loadTestViewt(tester);
    viewModel.setData("Data");
    await tester.pumpAndSettle();
    expect(find.textContaining("Data State"), findsOne);
  });

  testWidgets('Renders Data State with view model value', (tester) async {
    await loadTestViewt(tester);
    String data = "my data";
    viewModel.setData(data);
    await tester.pumpAndSettle();
    expect(find.textContaining(data), findsOneWidget);
  });

  testWidgets('Renders Empty state', (tester) async {
    await loadTestViewt(tester);
    viewModel.setData('Data');
    await tester.pumpAndSettle();
    viewModel.setEmpty();
    await tester.pumpAndSettle();
    expect(find.text('Empty State'), findsOneWidget);
  });

  testWidgets('Renders Error State', (tester) async {
    String errorMessage = "Error Message";
    await loadTestViewt(tester);
    viewModel.setError(errorMessage);
    await tester.pumpAndSettle();
    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('Renders Loading State', (tester) async {
    await loadTestViewt(tester);
    viewModel.setLoading();
    await tester.pumpAndSettle();
    expect(find.text('Loading State'), findsOneWidget);
  });

  testWidgets('Renders Custom State', (tester) async {
    await loadTestViewt(tester);
    viewModel.setState(const MyCustomLoadingState(progress: 10));
    await tester.pumpAndSettle();
    expect(find.text('Custom State'), findsOneWidget);
  });

  testWidgets('Renders Container', (tester) async {
    await loadTestViewt(tester);
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('Calls ViewModel onInit after settling down', (tester) async {
    MockTestViewModel mockViewModel = MockTestViewModel();
    final state = signal(const FlEmptyState<String>());
    when(mockViewModel.state).thenReturn(state);
    await tester.pumpWidget(MaterialApp(
      home: TestView(viewModel: mockViewModel),
    ));
    verify(mockViewModel.onViewInitialized()).called(1);
    state.dispose();
  });

  testWidgets('View Model disposes correctly when keepViewModelAlive is set to false', (tester) async {
    MockTestViewModel mockViewModel = MockTestViewModel();
    final state = signal(const FlEmptyState<String>());
    when(mockViewModel.state).thenReturn(state);
    await tester.pumpWidget(MaterialApp(
      home: TestView(
        viewModel: mockViewModel,
        keepViewModelAlive: false,
      ),
    ));
    await tester.pumpWidget(MaterialApp(
      home: Container(),
    ));
    verify(mockViewModel.dispose()).called(1);
    state.dispose();
  });

  testWidgets('View Model do not dispose with the view when keepViewModelAlive is set to true', (tester) async {
    MockTestViewModel mockViewModel = MockTestViewModel();
    final state = signal(const FlEmptyState<String>());
    when(mockViewModel.state).thenReturn(state);
    await tester.pumpWidget(MaterialApp(
      home: TestView(
        viewModel: mockViewModel,
        keepViewModelAlive: true,
      ),
    ));
    await tester.pumpWidget(MaterialApp(
      home: Container(),
    ));
    verifyNever(mockViewModel.dispose());
    state.dispose();
  });

  testWidgets('onDispose is called when the view is disposed', (tester) async {
    MockTestViewModel mockViewModel = MockTestViewModel();
    final state = signal(const FlEmptyState<String>());
    bool called = false;
    when(mockViewModel.state).thenReturn(state);
    await tester.pumpWidget(MaterialApp(
      home: TestView(
        viewModel: mockViewModel,
        keepViewModelAlive: true,
        viewDisposed: () {
          called = true;
        },
      ),
    ));
    await tester.pumpWidget(MaterialApp(
      home: Container(),
    ));

    expect(called, isTrue);
    state.dispose();
  });
}
