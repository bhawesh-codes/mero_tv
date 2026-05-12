// widgets/channel_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mero_tv/models/channel_model.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:mero_tv/ui/common/app_text.dart';
import 'package:mero_tv/ui/common/app_text_style.dart';
import 'package:mero_tv/ui/common/ui_helpers.dart';


class ChannelCard extends StatelessWidget {
  final ChannelModel channel;
  final String? logoUrl;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const ChannelCard({
    Key? key,
    required this.channel,
    this.logoUrl,
    required this.isFavorite,
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
    return ClipOval(
      clipBehavior: Clip.antiAlias,
      child: logoUrl != null
          ? Image.network(
              logoUrl!,
              width: 60.r,
              height: 60.r,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _buildLoadingPlaceholder();
              },
            )
          : _buildPlaceholder(),
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
            channel.name ?? '',
            overflow: TextOverflow.fade,
            maxLines: 2,
            style: titleMedium.copyWith(color: kcPrimaryTextColor),
          ),
          AppText(
            "● LIVE | ${channel.categories?.first.name ?? 'Unknown'}",
            overflow: TextOverflow.fade,
            style: bodySmall.copyWith(color: kcPrimaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return IconButton(
      onPressed: onFavoriteToggle,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? kcPrimaryColor : kcSecondaryTextColor,
      ),
    );
  }
}
