import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';
import 'package:mero_tv/ui/common/ui_helpers.dart';

import 'startup_viewmodel.dart';

class StartupView extends StackedView<StartupViewModel> {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    StartupViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText( text: const TextSpan(children: [TextSpan(text: 'Mero',style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: kcPrimaryTextColor),), TextSpan(text: 'TV',style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: kcPrimaryColor),)])
              
              
            ),
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Loading ...',
                    style: TextStyle(fontSize: 16, color: kcPrimaryTextColor)),
                horizontalSpaceSmall,
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: kcPrimaryTextColor,
                    strokeWidth: 6,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  StartupViewModel viewModelBuilder(BuildContext context) => StartupViewModel();

  @override
  void onViewModelReady(StartupViewModel viewModel) => SchedulerBinding.instance
      .addPostFrameCallback((timeStamp) => viewModel.runStartupLogic());
}
