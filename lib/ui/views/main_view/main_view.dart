import 'package:flutter/material.dart';
import 'package:mero_tv/ui/common/app_colors.dart';
import 'package:mero_tv/ui/views/favorites/favorites_view.dart';
import 'package:mero_tv/ui/views/home/home_view.dart';
import 'package:mero_tv/ui/views/main_view/main_viewmodel.dart';
import 'package:stacked/stacked.dart';

class MainView extends StackedView<MainViewModel> {
  const MainView({super.key});

  @override
  Widget builder(BuildContext context, MainViewModel viewModel, Widget? child) {
    return Scaffold(
      body: viewModel.currentIndex == 0
          ? const HomeView()
          : const FavoritesView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: viewModel.currentIndex,
        onTap: viewModel.setIndex,
        backgroundColor: const Color.fromARGB(255, 11, 11, 11),
        selectedItemColor: kcPrimaryColor,
        unselectedItemColor: kcSecondaryTextColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }

  @override
  MainViewModel viewModelBuilder(BuildContext context) => MainViewModel();
}
