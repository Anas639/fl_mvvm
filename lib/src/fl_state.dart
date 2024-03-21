import 'package:equatable/equatable.dart';

/// Base State class.
abstract class FlState<T> {
  /// The actual state
  T? get data;
}

/// Represents the data state.
///
/// Setting this state will cause the related view to build the data state widget.
class FlDataState<T> extends Equatable implements FlState<T> {
  const FlDataState(this.data);
  @override
  final T? data;

  @override
  List<Object?> get props => [data];
}

/// Represents a state indicating that the view model is still fetching data.
///
/// Setting this state will cause the related view to build the loading state widget.
class FlLoadingState<T> implements FlState<T> {
  const FlLoadingState([this.data]);
  @override
  final T? data;
}

/// Represents the state in case of a Failure
///
/// For example, when fetching data, if an exception is caught, the view model's state will be of type [FlErrorState]
/// giving you access to the error's details.
///
/// Setting this state will cause the related view to build the error state widget.
class FlErrorState<T> implements FlState<T> {
  const FlErrorState(this.error, [this.stackTrace, this.data]);
  final Object error;
  final StackTrace? stackTrace;
  @override
  final T? data;
}

/// Represent an empty state
///
/// This is the default state of the view model.
///
/// Use it when your view model doesn't have a state yet.
/// You can pass a custom message via the [message] parameter.
///
/// Setting this state will cause the related view to build the empty state widget.
class FlEmptyState<T> implements FlState<T> {
  const FlEmptyState([this.message = ""]);

  final String message;
  @override
  final T? data = null;
}
