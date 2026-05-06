// favorites_view.dart
import 'package:flutter/material.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';
import 'favorites_viewmodel.dart';
import 'widgets/favorites_app_bar.dart';
import 'widgets/favorites_body.dart';

class FavoritesView extends StackedView<FavoritesViewModel> {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, FavoritesViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      appBar: const FavoritesAppBar(),
      body: FavoritesBody(viewModel: viewModel),
    );
  }

  @override
  FavoritesViewModel viewModelBuilder(BuildContext context) =>
      FavoritesViewModel();
}
