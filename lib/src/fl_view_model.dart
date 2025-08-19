import 'dart:async';

import 'package:fl_mvvm/fl_mvvm.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';

/// ### Represents a View Model
///
/// The view model is the object responsible for maintaining the state.
/// and notifying the related view of state changes.
///
/// The state of the view model is a [FlState] instance that holds a value of type [T].
/// You can use predefined states, such as:
/// * [FlDataState]
/// * [FlEmptyState]
/// * [FlLoadingState]
/// * [FlErrorState]
/// You can also create your custom state by implementing the [FlState] interface.
/// ```dart
/// class CustomState implements FlState{
/// // implementation ...
/// }
/// ```
/// You can use [setState] to set your custom state as the current state.
///
/// ```dart
/// setState(CustomState(customProperty:'hello 👋'));
/// ```
class FlViewModel<T> {
  FlViewModel({this.autoDispose = false}) {
    this._setEffect();
    if (autoDispose) {
      state.onDispose(() async {
        _isDisposed = true;
        onDispose();
      });
    }
  }

  /// Whether this view model will get disposed when the there's no more state listeners.
  final bool autoDispose;

  dynamic Function()? _disposeEffect;

  /// The signal that holds the current [FlState].
  late final _state = signal<FlState<T>>(const FlEmptyState(), autoDispose: autoDispose);

  /// Whether this [FlViewModel] has been initialized.
  bool _isInitialized = false;

  /// Whether this [FlViewModel] has been initialized.
  bool get isInitialized => _isInitialized;

  Signal<FlState<T>> get state => _state;

  /// The value of the current [FlState].
  T? get value => _state.value.data;

  /// ### Returns the current error message.
  ///
  /// If the current error is a string, the error message will be the exact string.
  ///
  /// ```dart
  /// viewModel.setError('Error');
  /// print(viewModel.errorMessage); // prints 'Error';
  /// ```
  ///
  /// If the current error is an object, the error message will be the result of that object's toString().
  ///
  /// ```dart
  /// viewModel.setError(Exception('Error'));
  /// print(viewModel.errorMessage); // prints 'Exception: Error'
  /// ```
  String? get errorMessage {
    if (_state.value is! FlErrorState) return null;
    FlErrorState<T> errorState = _state.value as FlErrorState<T>;

    return errorState.error.toString();
  }

  /// ### Returns the current empty message.
  ///
  ///
  /// ```dart
  /// viewModel.setEmpty('No Data');
  /// print(viewModel.emptyMessage); // prints 'No Data';
  /// ```
  ///
  String? get emptyMessage {
    if (_state.value is! FlEmptyState) return null;
    FlEmptyState<T> emptyState = _state.value as FlEmptyState<T>;
    return emptyState.message;
  }

  /// Whether the current state is currently loading.
  bool get isLoadng => _state.peek() is FlLoadingState<T>;

  /// Whether the state is an error.
  bool get isError => _state.peek() is FlErrorState<T>;

  /// Whether the state is a data state.
  ///
  /// NOTE: The data can be null even if the state is a DataState.
  bool get isData => _state.peek() is FlDataState<T>;

  /// Whether the state is empty.
  bool get isEmpty => _state.peek() is FlEmptyState<T>;

  /// Whether this view model as been disposed
  bool get isDisposed => _isDisposed;
  bool _isDisposed = false;

  _setEffect() {
    _disposeEffect = effect(buildDependencies);
  }

  /// ### If another state is accessed here, this view model's state will rebuild every time the other state changes.
  ///
  /// ```dart
  /// @override
  /// void buildDependencies(){
  ///   setData(productsViewModel.value?.where((e)=>e.isFavorite)); // will cause the view model to rebuild every time the state of productsViewModel changes.
  /// }
  /// ```
  @protected
  void buildDependencies() {}

  /// Called when the first view using this view model is initialized.
  @mustCallSuper
  void onViewInitialized() {
    _isInitialized = true;
  }

  /// Dispose the view model and it's state
  ///
  /// The view model's state cannot be used after getting dispoded
  @nonVirtual
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    state.dispose();
    if (!autoDispose) onDispose();
  }

  /// Called when the accosiated view get's disposed of.
  ///
  /// This code will run when the associated View is being disposed.
  /// You might want to release resources, dispose of a disposable state, stop a timer, etc...
  @mustCallSuper
  void onDispose() {
    _disposeEffect?.call();
  }

  /// Sets the current state to [newState].
  ///
  /// Use this method if you want to set the current state to a custom [FlState].
  ///
  /// ```dart
  /// class MyCustomLoadingState<T> implements FlState<T> {
  ///
  /// const MyCustomLoadingState({required this.progress, this.data});
  ///
  /// final double progress;
  ///
  /// @override
  /// final T? data;
  /// }
  ///
  /// setState(MyCustomLoadingState(progress: 20));
  /// ```
  void setState(FlState<T> newState) {
    _state.value = newState;
  }

  /// Sets the current state to [FlLoadingState].
  void setLoading() {
    _state.value = FlLoadingState<T>(_state.peek().data);
  }

  /// Sets the current state to [FlDataState] with [data].
  void setData(T? data) {
    _state.value = FlDataState<T>(data);
  }

  /// ### Sets data from a [Future]
  ///
  /// If [futureData] completes successfully, [setFutureData] will set the current state to an [FlDataState] containing the result of the future.
  ///
  /// If [futureData] completes with an error, [setFutureData] will catch the error and set the current state to [FlErrorState] with the caught error.
  ///
  /// If [withLoading] is true, [setFutureData] will call [setLoading] before waiting for the future.
  void setFutureData(
    Future<T?> futureData, {
    bool withLoading = true,
  }) async {
    if (withLoading) setLoading();
    try {
      setData(await futureData);
    } catch (e, s) {
      setError(e, s);
    }
  }

  /// ### Sets data from a [Future<Either>]
  ///
  /// If [future] completes successfully,
  /// [setEitherFuture] will examine the [Either] value.
  /// If it's [Right] then it sets the current state to an [FlDataState] containing the value of [Right].
  /// If it's [Left] then it sets the current state to an [FlErrorState] with an error message equal to [Left] as [String]
  /// If you use a custom object as [Left] then the value of [toString] will be used as the error message.
  ///
  /// If [future] completes with an error, [setEitherFuture] will catch the error and set the current state to [FlErrorState] with the caught error.
  ///
  /// If [withLoading] is true, [setEitherFuture] will call [setLoading] before waiting for the future.
  void setEitherFuture(
    Future<Either<dynamic, T>> future, {
    bool withLoading = true,
  }) async {
    if (withLoading) setLoading();
    try {
      final response = await future;
      response.fold((l) => setError(l.toString()), (r) => setData(r));
    } catch (e, s) {
      setError(e, s);
    }
  }

  ///### Sets the current state to [FlEmptyState].
  ///
  /// You can pass a custom [message] that can be retrieved later from the state.
  void setEmpty([String message = ""]) {
    _state.value = FlEmptyState<T>(message);
  }

  /// Sets the current state to [FlErrorState].
  void setError(Object error, [StackTrace? stackTrace]) {
    _state.value = FlErrorState<T>(error, stackTrace);
  }

  /// ### Returns a [Future] that completes when the state changes.
  ///
  /// Use the generic type if you want to wait for a certain state.
  ///
  /// ```dart
  /// waitForStateChange(); // it will wait for the next state.
  /// waitForStateChange<FlDataState>(); // it will wait for the next FlDataState
  /// ```
  ///
  /// Pass a [timeout] if you want to stop waiting after some milliseconds.
  /// in the state doesn't change after 200 ms, [waitForStateChange] will complete with a null value.
  /// ```dart
  /// waitForStateChange(timeout: 200); // Will wait for the next state during 200 ms
  /// ```
  @visibleForTesting
  Future<FlState<T>?> waitForStateChange<S extends FlState>({int? timeout}) async {
    Completer<FlState<T>?> completer = Completer();
    Stream<FlState<T>> stream = _state.toStream();
    StreamSubscription<FlState<T>>? subscription;
    subscription = stream.skip(1).listen((value) {
      if (S != dynamic && value is! S) {
        return;
      }
      completer.complete(value);
      subscription?.cancel();
    });

    if (timeout != null) {
      Future.delayed(Duration(milliseconds: timeout), () {
        if (!completer.isCompleted) {
          subscription?.cancel();
          completer.complete(null);
        }
      });
    }

    return completer.future;
  }
}
