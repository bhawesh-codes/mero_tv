// widgets/error_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:mero_tv/ui/common/app_text.dart';
import 'package:mero_tv/ui/common/app_text_style.dart';
import 'package:mero_tv/ui/common/ui_helpers.dart';

class ErrorWidgets extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorWidgets({
    Key? key,
    required this.errorMessage,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 64.r, color: kcSecondaryTextColor),
            verticalSpaceSmall,
            AppText(
              errorMessage,
              textAlign: TextAlign.center,
              style: bodyMedium.copyWith(color: kcPrimaryTextColor),
            ),
            verticalSpaceMedium,
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: AppText('Retry', style: bodyMedium),
              style: ElevatedButton.styleFrom(
                backgroundColor: kcPrimaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
