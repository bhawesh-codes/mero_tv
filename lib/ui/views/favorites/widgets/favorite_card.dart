// widgets/favorite_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mero_tv/models/channel_model.dart';
import '../../../common/app_colors.dart';
import '../../../common/app_text.dart';
import '../../../common/app_text_style.dart';
import '../../../common/ui_helpers.dart';

class FavoriteCard extends StatelessWidget {
  final ChannelModel channel;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const FavoriteCard({
    Key? key,
    required this.channel,
    required this.onTap,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 70.h,
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 4,
          color: const Color.fromRGBO(19, 19, 19, 1),
          child: Row(
            children: [
              horizontalSpaceSmall,
              _buildChannelLogo(),
              horizontalSpaceSmall,
              _buildChannelInfo(),
              _buildFavoriteButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChannelLogo() {
    return Container(
      width: 64.r,
      height: 64.r,
      padding: EdgeInsets.all(1.5.r), // space for border
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: kcDisabledTextColor,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: channel.logoUrl != null
            ? Image.network(
                channel.logoUrl!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholder(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildLoadingPlaceholder();
                },
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 60.r,
      height: 60.r,
      color: Colors.grey[300],
      child: const Icon(Icons.tv, color: Colors.white),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: 60.r,
      height: 60.r,
      color: Colors.grey[300],
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildChannelInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            channel.name ?? 'Unknown',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: titleMedium.copyWith(color: kcPrimaryTextColor),
          ),
          // AppText(
          //   "● LIVE | ${channel.categories?.first.name[0].toUpperCase()}${channel.categories?.first.name.substring(1) ?? 'Unknown'}",
          //   overflow: TextOverflow.fade,
          //   style: bodySmall.copyWith(color: kcPrimaryColor),
          // )
        ],
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return IconButton(
      onPressed: onFavoriteToggle,
      icon: const Icon(
        Icons.favorite,
        color: kcPrimaryColor,
      ),
    );
  }
}
