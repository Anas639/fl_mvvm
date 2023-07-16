import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlViewModel<T> extends AutoDisposeAsyncNotifier<T?> {
  late BuildContext context;
  late final _provider =
      AsyncNotifierProvider.autoDispose<FlViewModel<T>, T?>(() => this);

  AutoDisposeAsyncNotifierProvider get provider => _provider;

  T? get value => state.asData?.value;

  bool get shouldBuildError => true;

  bool get requireData => true;

  String? get errorMessage {
    if (state is! AsyncError) return null;
    AsyncError asyncError = state as AsyncError;

    return asyncError.error.toString();
  }

  bool get hasData {
    if (!requireData) return true;
    var currentData = value;
    if (currentData == null) return false;
    if (currentData is Iterable) {
      return currentData.isNotEmpty;
    }
    if (currentData is Map) {
      return currentData.isNotEmpty;
    }
    return true;
  }

  @override
  FutureOr<T?> build() {
    return null;
  }

  void onInit() {}

  void onDispose() {}

  void refresh() {
    ref.notifyListeners();
  }

  void refreshState() {
    state = ref.refresh(_provider);
  }

  @protected
  void setLoading() {
    state = AsyncValue<T?>.loading();
  }

  @protected
  void setData(T? data) {
    state = AsyncValue<T?>.data(data);
  }

  void setFutureData(
    Future<T?> futureData, {
    bool withLoading = true,
  }) async {
    if (withLoading) setLoading();
    state = await AsyncValue.guard(() => futureData);
  }

  @protected
  void setEmpty() {
    setData(null);
  }

  @protected
  void setError(Object error, [StackTrace? stackTrace]) {
    state = AsyncValue<T?>.error(error, stackTrace ?? StackTrace.current);
  }

  @override
  bool updateShouldNotify(
    AsyncValue<T?> previous,
    AsyncValue<T?> next,
  ) {
    if (next is AsyncData) {
      onStateDataChanged(next.value);
    }
    return super.updateShouldNotify(previous, next);
  }

  void onStateDataChanged(T? data) {
    // Not implemented in the base class
  }
}
