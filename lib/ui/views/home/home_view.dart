// home_view.dart
import 'package:flutter/material.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';
import 'home_viewmodel.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_body.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: HomeAppBar(viewModel: viewModel,),
      backgroundColor: kcBackgroundColor,
      body: HomeBody(viewModel: viewModel,),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) =>
      HomeViewModel()..fetchChannelData();
}
