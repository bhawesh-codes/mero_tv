import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:mero_tv/ui/common/ui_helpers.dart';
import 'package:mero_tv/ui/views/video_player/video_player_view.dart';
import 'package:mero_tv/ui/widgets/bottom_nav_bar.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
        bottomNavigationBar: const BottomNavBar(),
        appBar: AppBar(
          elevation: 5,
          backgroundColor: kcBackgroundColor,
          title: viewModel.isSearching
              ? SizedBox(
                  height: 40.h,
                  child: const SearchBar(
                    backgroundColor: WidgetStatePropertyAll(kcSurfaceColor),
                    hintText: 'Search channels..',
                  ),
                )
              : RichText(
                  text: TextSpan(children: [
                  TextSpan(
                      text: 'Mero ',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 24.sp)),
                  TextSpan(
                      text: 'TV',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24.sp,
                          color: kcPrimaryColor))
                ])),
          actions: [
            IconButton(
                onPressed: () {
                  viewModel.toggleSearch();
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ))
          ],
        ),
        backgroundColor: kcBackgroundColor,
        body: SafeArea(
          child: Builder(builder: (context) {
            if (viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (viewModel.errorMessage != null &&
                viewModel.errorMessage!.isNotEmpty) {
              return Center(
                child: Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.orange),
                ),
              );
            }
            if (viewModel.channelList == null) {
              return const Center(
                child: Text("No data"),
              );
            }
            return Padding(
              padding: EdgeInsets.all(12.0.r),
              child: ListView.builder(
                  itemCount: viewModel.channelList!.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xff666666))),
                            child: CarouselSlider(
                              items: [
                                //3rd Image of Slider
                                Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/main_slider.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Live TV',
                                          style: TextStyle(
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'Anywhere.',
                                          style: TextStyle(
                                              color: kcPrimaryColor,
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const Text(
                                          'Watch your favotite',
                                          style: TextStyle(
                                              color: kcSecondaryTextColor),
                                        ),
                                        const Text(
                                          'channels in high quality.',
                                          style: TextStyle(
                                              color: kcSecondaryTextColor),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                //4th Image of Slider
                                Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/favorites.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Watch Your',
                                          style: TextStyle(
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'Favorites.',
                                          style: TextStyle(
                                              color: kcPrimaryColor,
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const Text(
                                          'Watch your favotite',
                                          style: TextStyle(
                                              color: kcSecondaryTextColor),
                                        ),
                                        const Text(
                                          'TV showsin high quality.',
                                          style: TextStyle(
                                              color: kcSecondaryTextColor),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                //5th Image of Slider

                                Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/trending.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Watch',
                                          style: TextStyle(
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'Trending.',
                                          style: TextStyle(
                                              color: kcPrimaryColor,
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const Text(
                                          'Watch popular',
                                          style: TextStyle(
                                              color: kcSecondaryTextColor),
                                        ),
                                        const Text(
                                          'shows and movies.',
                                          style: TextStyle(
                                              color: kcSecondaryTextColor),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],

                              //Slider Container properties
                              options: CarouselOptions(
                                height: 180.0,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                aspectRatio: 16 / 9,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                viewportFraction: 1.0,
                              ),
                            ),
                          ),
                          verticalSpaceSmall,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'All Channels',
                                  style: TextStyle(
                                      color: kcPrimaryTextColor,
                                      fontSize: 18.sp),
                                ),
                              ),
                              const Text(
                                'All',
                                style: TextStyle(color: kcPrimaryColor),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: kcPrimaryColor,
                              )
                            ],
                          ),
                          verticalSpaceSmall,
                        ],
                      );
                    }
                    final channel = viewModel.channelList![index];
                    final url = viewModel.logoUrlMap[channel.channel];
                    print(
                        'index $index | channel: ${channel.channel} | url: $url'); // add this

                    return GestureDetector(
                      // Wrap your card with GestureDetector
                      onTap: () {
                        final streamUrl = viewModel.channelList![index].url;
                        final title =
                            viewModel.channelList![index].title ?? 'Live TV';
                        if (streamUrl != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VideoPlayerView(
                                  streamUrl: streamUrl, title: title),
                            ),
                          );
                        }
                      },

                      child: SizedBox(
                          height: 70.h,
                          width: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r)),
                            elevation: 4,
                            color: const Color.fromRGBO(19, 19, 19, 1),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                horizontalSpaceSmall,
                                ClipOval(
                                  clipBehavior: Clip.antiAlias,
                                  child: url != null
                                      ? Image.network(
                                          url,
                                          width: 60.r,
                                          height: 60.r,
                                          fit: BoxFit.fill,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            width: 60.r,
                                            height: 60.r,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.tv,
                                                color: Colors.white),
                                          ),
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Container(
                                              width: 60.r,
                                              height: 60.r,
                                              color: Colors.grey[300],
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2),
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          width: 60.r,
                                          height: 60.r,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.tv,
                                              color: Colors.white),
                                        ),
                                ),
                                horizontalSpaceSmall,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        viewModel.channelList![index].title!,
                                        overflow: TextOverflow.fade,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: kcPrimaryTextColor),
                                      ),
                                      const Text(
                                        "●LIVE",
                                        style: TextStyle(color: kcPrimaryColor),
                                      )
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.favorite_border,
                                      color: kcSecondaryTextColor,
                                    ))
                              ],
                            ),
                          )),
                    );
                  }),
            );
          }),
        ));
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) =>
      HomeViewModel()..fetchChannelData();
}
