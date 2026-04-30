import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mero_tv/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.black87,
        title: Text(
          'Mero TV',
          style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: const FontWeight(600)),
        ),
        centerTitle: true,
      ),
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
            child: Column(
              children: [
                Text(
                  'All Channels',
                  style: TextStyle(
                      fontSize: 20.sp, fontWeight: const FontWeight(500)),
                ),
                verticalSpaceSmall,
                Expanded(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 120.r,
                          mainAxisSpacing: 12.h,
                          crossAxisSpacing: 8.w,
                          childAspectRatio: 0.7),
                      itemCount: viewModel.channelList!.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                            height: 60.h,
                            width: 50.w,
                            child: Card(
                              shape: Border.all(),
                              elevation: 4,
                              color: Colors.black87,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  verticalSpaceSmall,
                                  CircleAvatar(
                                    
                                    radius: 35.r,
                                  ),
                                  verticalSpaceMedium,
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(6, 0, 6, 0),
                                    child: Text(
                                      viewModel.channelList![index].name!,
                                      overflow: TextOverflow.fade,
                                      maxLines: 2,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      }),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) =>
      HomeViewModel()..fetchChannelData();
}
