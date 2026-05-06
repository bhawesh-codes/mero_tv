// widgets/home_body.dart
import 'package:flutter/material.dart';
import 'package:mero_tv/ui/common/app_text.dart';
import 'package:mero_tv/ui/common/app_text_style.dart';
import 'package:mero_tv/ui/views/home/widgets/error_widgets.dart';
import 'package:mero_tv/ui/views/home/widgets/loading_widgets.dart';
import '../home_viewmodel.dart';
import 'channel_list_widget.dart';

class HomeBody extends StatelessWidget {
  final HomeViewModel viewModel;

  const HomeBody({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(builder: (context) {
        if (viewModel.isLoading) {
          return const LoadingWidget();
        }

        if (viewModel.errorMessage != null &&
            viewModel.errorMessage!.isNotEmpty) {
          return ErrorWidgets(
            errorMessage: viewModel.errorMessage!,
            onRetry: viewModel.retry,
          );
        }

        if (viewModel.channelList == null) {
          return Center(
            child: AppText("No data", style: bodyMedium),
          );
        }

        return ChannelListWidget(viewModel: viewModel);
      }),
    );
  }
}
