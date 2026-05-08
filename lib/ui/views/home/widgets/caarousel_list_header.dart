// widgets/channel_list_header.dart
import 'package:flutter/material.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:mero_tv/ui/common/app_text.dart';
import 'package:mero_tv/ui/common/app_text_style.dart';

class ChannelListHeader extends StatelessWidget {
  const ChannelListHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AppText(
            'All Channels',
            style: titleMedium.copyWith(color: kcPrimaryTextColor),
          ),
        ),
        AppText(
          'All',
          style: bodySmall.copyWith(color: kcPrimaryColor),
        ),
        const Icon(
          Icons.keyboard_arrow_down,
          color: kcPrimaryColor,
        ),
      ],
    );
  }
}
