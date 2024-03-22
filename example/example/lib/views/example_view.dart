import 'package:example/models/example_model.dart';
import 'package:example/views/example_view_model.dart';
import 'package:fl_mvvm/fl_mvvm.dart';
import 'package:flutter/material.dart';

class ExampleView extends FlView<ExampleViewModel> {
  final int numberOfItems;

  const ExampleView({
    super.key,
    super.viewModel,
    required this.numberOfItems,
  });

  @override
  Widget? buildContainer(
    BuildContext context,
    Widget child,
    ExampleViewModel viewModel,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Total number of items: ${viewModel.exampleList.length}"),
      ),
      body: Column(
        children: [
          Expanded(child: child),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 20,
              children: [
                ElevatedButton(
                  onPressed: viewModel.reload,
                  child: const Text("Reload"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  ),
                  onPressed: viewModel.reloadWithError,
                  child: const Text("Reload with error"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildDataState(BuildContext context, ExampleViewModel viewModel) {
    List<ExampleModel> exampleList = viewModel.exampleList;
    return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
          leading: Text("#${exampleList[index].id}"),
          title: Text(
            exampleList[index].name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: exampleList.length,
    );
  }

  @override
  Widget buildErrorState(
    BuildContext context,
    ExampleViewModel viewModel,
    String error,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red[300],
      ),
      child: Center(
        child: Text(
          "😨 $error ${viewModel.exampleList.length}",
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  ExampleViewModel createViewModel() {
    return ExampleViewModel(numberOfItems: numberOfItems);
  }
}
