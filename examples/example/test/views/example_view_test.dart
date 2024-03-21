// ignore_for_file: require_trailing_commas

import 'package:example/models/example_model.dart';
import 'package:example/views/example_view.dart';
import 'package:example/views/example_view_model.dart';
import 'package:fl_mvvm/fl_mvvm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'example_view_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ExampleViewModel>()])
void main() {
  testWidgets("Loads the right number of items ", (tester) async {
    const int numberOfItems = 3;
    await tester.pumpWidget(
      const MaterialApp(
        home: ExampleView(
          numberOfItems: numberOfItems,
        ),
      ),
    );

    await tester.pumpAndSettle();

    final titleFinder = find.textContaining("I'm the item number");

    expect(titleFinder, findsExactly(numberOfItems));
  });

  testWidgets('Calls ExampleViewModel\'s reload function', (tester) async {
    var mockViewModel = MockExampleViewModel();
    var state = signal(const FlDataState<List<ExampleModel>>([]));
    addTearDown(state.dispose);
    when(mockViewModel.state).thenReturn(state);
    await tester.pumpWidget(MaterialApp(
      home: ExampleView(
        viewModel: mockViewModel,
        numberOfItems: 3,
      ),
    ));

    final reloadFinder = find.widgetWithText(ElevatedButton, "Reload");
    await tester.tap(reloadFinder);
    await tester.pumpAndSettle();
    verify(mockViewModel.reload()).called(1);
  });
}
