import 'package:example/views/example_view_model.dart';
import 'package:fl_mvvm/fl_mvvm.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Correctly initializes the ViewModel', () async {
    // Arrange
    ExampleViewModel viewModel = ExampleViewModel(numberOfItems: 3);

    // Act
    viewModel.onViewInitialized();
    await viewModel.waitForStateChange();
    // Assert
    expect(viewModel.isData, isTrue);
    expect(viewModel.value?.length, equals(3));
  });

  test('Test data reloaded', () async {
    // Arrange
    ExampleViewModel viewModel = ExampleViewModel(numberOfItems: 3);
    // Act
    viewModel.reload();
    await viewModel.waitForStateChange<FlDataState>(timeout: 1000);
    // Assert
    expect(viewModel.value?.length, equals(3));
  });

  test('Reload with error', () async {
    // Arrange
    ExampleViewModel viewModel = ExampleViewModel(numberOfItems: 3);
    // Act
    viewModel.reloadWithError();
    await viewModel.waitForStateChange<FlErrorState>(timeout: 1000);

    // Assert
    expect(viewModel.errorMessage, isNotNull);
    expect(viewModel.value, isNull);
  });
}
