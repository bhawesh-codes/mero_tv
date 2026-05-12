// widgets/carousel_slider_widget.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:mero_tv/ui/common/app_text.dart';
import 'package:mero_tv/ui/common/app_text_style.dart';

class CarouselSliderWidget extends StatelessWidget {
  const CarouselSliderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff666666)),
      ),
      child: CarouselSlider(
        items: [
          _buildSliderItem(
            imagePath: 'assets/images/main_slider.png',
            title1: 'Live TV',
            title2: 'Anywhere',
            subtitle1: 'Watch all TV',
            subtitle2: 'channels in high quality.',
          ),
          _buildSliderItem(
            imagePath: 'assets/images/favorites.png',
            title1: 'Your',
            subtitle1: 'Watch your favorite',
            subtitle2: 'TV shows in high quality.',
            title2: 'Favorites.',
          ),
          _buildSliderItem(
            imagePath: 'assets/images/trending.png',
            title1: 'Watch',
            title2: 'Trending.',
            subtitle1: 'Watch popular',
            subtitle2: 'shows and movies.',
          ),
        ],
        options: CarouselOptions(
          height: 130.sp,
          enlargeCenterPage: false,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          viewportFraction: 1.0,
        ),
      ),
    );
  }

  Widget _buildSliderItem({
    required String imagePath,
    required String title1,
    required String title2,
    required String subtitle1,
    required String subtitle2,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(title1,
                style: bodyLarge.copyWith(color: kcPrimaryTextColor)),
            AppText(
              title2,
              style: bodyLarge.copyWith(color: kcPrimaryColor),
            ),
            AppText(
              subtitle1,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: bodyMedium.copyWith(
                  color: kcSecondaryTextColor.withAlpha(200), fontSize: 16),
            ),
            AppText(
              subtitle2,
              overflow: TextOverflow.fade,
              maxLines: 1,
              style: bodyMedium.copyWith(
                  color: kcSecondaryTextColor.withAlpha(200), fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
