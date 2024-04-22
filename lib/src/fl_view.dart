import 'package:fl_mvvm/src/fl_state.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'fl_view_model.dart';

/// ### Represents a view
///
/// The view is responsible for building the UI based on a given state.
///
/// A view must be linked to a [FlViewModel] in order to listen to state changes.
/// You can override [createViewModel] and return your view model.
/// ```dart
/// class MyView extends FlView<MyViewModel>{
///   @override
///   MyViewModel? createViewModel() => MyViewModel();
/// }
/// ```
/// Or you can simply pass a view model via the constructor; for example, this is useful if you want to inject the view model while testing.
/// ```dart
/// const MyView(viewModel: MyViewModel()),
/// ```
///**⚠️ [createViewModel] will be ignored if the viewModel is passed via cnostructor.**
///
abstract class FlView<VT extends FlViewModel> extends StatefulWidget {
  /// The view model to be associated with this view
  final VT? viewModel;
  final bool _keepViewModelAlive;
  const FlView({
    super.key,
    this.viewModel,
    bool keepViewModelAlive = false,
  }) : _keepViewModelAlive = keepViewModelAlive;

  /// Wether to keep the viewmodel alive when the view is dispose of.
  bool get keepViewModelAlive => _keepViewModelAlive;

  @override
  State<FlView<VT>> createState() {
    return ViewState();
  }

  /// Returns the view model related to this view.
  ///
  /// ⚠️ The returning value will be ignored if a view model is passed via constructor.
  VT? createViewModel() {
    return null;
  }

  /// Returns a [Widget] that wraps the content of the view.
  ///
  /// Use it to wrap your view with a [Scaffold] for example.
  Widget? buildContainer(
    BuildContext context,
    Widget child,
    VT viewModel,
  ) {
    return null;
  }

  /// Returns the [Widget] that will be displayed in case of an error.
  Widget buildErrorState(BuildContext context, VT viewModel, String error) {
    return Center(
      child: Text(
        error,
        style: TextStyle(
          color: Colors.red[300],
          fontSize: 14,
        ),
      ),
    );
  }

  /// Returns the [Widget] that will handle the data.
  Widget buildDataState(BuildContext context, VT viewModel);

  /// Returns the [Widget] that will be displayed during the loading state.
  Widget buildLoadingState(BuildContext context, VT viewModel) {
    return const Material(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Returns the [Widget] that will be displayed when the state is empty.
  Widget buildEmptyState(BuildContext context, VT viewModel) {
    return const SizedBox.shrink();
  }

  /// Returns the [Widget] that will be displayed in custom states.
  ///
  /// If the current state isn't one of the predefined states that the view can handle,
  /// then the view will call [buildCustomState] and expect a widget that will handle the custom state.
  ///
  /// Check the type of [state] to determine which custom state to render.
  Widget buildCustomState(BuildContext context, FlState state, VT viewModel) {
    return Text("Override buildCustomState to hande $state");
  }
}

class ViewState<VT extends FlViewModel> extends State<FlView<VT>> {
  late VT viewModel;

  /// Contains the view with a container if defined.
  Widget _contain(BuildContext context, Widget child, VT viewModel) {
    Widget? containedWidget = widget.buildContainer(context, child, viewModel);
    if (containedWidget != null) {
      return containedWidget;
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return _contain(
      context,
      Watch((context) {
        var state = viewModel.state();
        return switch (state) {
          FlDataState() => widget.buildDataState(context, viewModel),
          FlErrorState() => widget.buildErrorState(
              context, viewModel, viewModel.errorMessage ?? ''),
          FlLoadingState() => widget.buildLoadingState(context, viewModel),
          FlEmptyState() => widget.buildEmptyState(context, viewModel),
          _ => widget.buildCustomState(context, state, viewModel)
        };
      }),
      viewModel,
    );
  }

  @override
  void dispose() {
    if (!widget.keepViewModelAlive) viewModel.dispose();
    super.dispose();
  }

  @override
  void initState() {
    viewModel = widget.viewModel ?? widget.createViewModel()!;
    super.initState();
    if (!viewModel.isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        viewModel.onViewInitialized();
      });
    }
  }
}
