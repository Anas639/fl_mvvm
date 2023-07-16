import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fl_view_model.dart';

abstract class FlView<VT extends FlViewModel> extends ConsumerStatefulWidget {
  const FlView({super.key});

  @override
  ConsumerState createState() {
    return ViewState();
  }

  VT createViewModel();

  Widget? buildContainer(
    BuildContext context,
    Widget child,
    VT viewModel,
  ) {
    return null;
  }

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

  Widget buildDataState(BuildContext context, VT viewModel);

  Widget buildLoadingState(BuildContext context, VT viewModel) {
    return const Material(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildEmptyState(BuildContext context, VT viewModel) {
    return const SizedBox.shrink();
  }
}

class ViewState<VT extends FlViewModel> extends ConsumerState<FlView<VT>> {
  late VT viewModel;

  Widget _contain(BuildContext context, Widget child, VT viewModel) {
    Widget? containedWidget = widget.buildContainer(context, child, viewModel);
    if (containedWidget != null) {
      return containedWidget;
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(viewModel.provider);
    return _contain(
      context,
      state.when(
        data: (data) {
          if (viewModel.hasData) {
            return widget.buildDataState(context, viewModel);
          }
          return widget.buildEmptyState(context, viewModel);
        },
        error: (error, stackTrace) {
          if (!viewModel.shouldBuildError) {
            return widget.buildDataState(context, viewModel);
          }

          return widget.buildErrorState(context, viewModel, error.toString());
        },
        loading: () {
          return widget.buildLoadingState(context, viewModel);
        },
      ),
      viewModel,
    );
  }

  @override
  void dispose() {
    viewModel.onDispose();
    super.dispose();
  }

  @override
  void initState() {
    viewModel = widget.createViewModel();
    viewModel.context = context;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      viewModel.onInit();
    });
  }
}
