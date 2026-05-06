// widgets/loading_widget.dart
import 'package:flutter/material.dart';
import 'package:mero_tv/ui/common/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: kcPrimaryColor,
      ),
    );
  }
}
