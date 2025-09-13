import 'package:esimtel/utills/global.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import '../views/bottomNavBarScreen.dart';

class BottomNavController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  DateTime? currentBackPressTime;
  PersistentTabController? globalController;

  void jumpToTab(int index) {
    selectedIndex.value = index;
    if (globalController != null && globalController!.index != index) {
      globalController!.jumpToTab(index);
    }
    update();
  }

  void navigateToTab(int index) {
    jumpToTab(index);
    Get.off(() => BottomNavigationBarScreen(key: UniqueKey(), index: index));
  }

  Future<bool> onBackPressed() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      showToastMessage(message: tr("Press again to exit"));
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void onClose() {
    globalController?.dispose();
    super.onClose();
  }
}
