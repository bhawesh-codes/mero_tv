// widgets/home_body.dart
import 'package:flutter/material.dart';
import 'package:mero_tv/ui/views/home/widgets/error_widgets.dart';
import 'package:mero_tv/ui/views/home/widgets/loading_widgets.dart';
import 'package:stacked/stacked.dart';
import '../home_viewmodel.dart';
import 'channel_list_widget.dart';

class HomeBody extends ViewModelWidget<HomeViewModel> {

  const HomeBody({Key? key}) : super(key: key);
  @override
  Widget build (BuildContext context, HomeViewModel viewModel) {
    return SafeArea(
      child: Builder(builder: (context) {
        if (viewModel.isLoading) {
          return const LoadingWidget();
        }

        if (viewModel.errorMessage != null &&
            viewModel.errorMessage!.isNotEmpty) {
          return ErrorWidgets(
            errorMessage: viewModel.errorMessage!,
            onRetry: viewModel.refreshData,
          );
        }

        

        return const ChannelListWidget();
      }),
    );
  }
  // @override
  // HomeViewModel viewModelBuilder(BuildContext context) =>HomeViewModel()..fetchChannelData();
}
