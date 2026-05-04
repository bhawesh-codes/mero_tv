import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mero_tv/ui/common/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: const Color.fromARGB(255, 11, 11, 11),
        selectedItemColor: kcPrimaryColor,
        unselectedItemColor: kcDisabledTextColor,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.live_tv,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Favorites'),
        ]);
  }
}
