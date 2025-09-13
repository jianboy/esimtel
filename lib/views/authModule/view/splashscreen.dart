import 'dart:developer';
import 'dart:io';
import 'package:esimtel/utills/UserService.dart';
import 'package:esimtel/utills/image.dart';
import 'package:esimtel/views/onBoardModule/view/onboardScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esimtel/views/authModule/view/loginScreen.dart';
import 'package:esimtel/views/navbarModule/views/bottomNavBarScreen.dart';
import 'package:sizer/sizer.dart';
import 'package:esimtel/utills/global.dart' as global;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
    _fetcCurrency();
  }

  void _fetcCurrency() async {
    global.sp = await SharedPreferences.getInstance();
    global.activeCurrency = global.sp!.getString("Currency");
    final fcmToken = Platform.isAndroid
        ? await FirebaseMessaging.instance.getToken()
        : await FirebaseMessaging.instance.getAPNSToken();
    log('FCM TOKEN is $fcmToken');
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));

    final userService = UserService.to;
    await userService.loadUserData();

    if (userService.currentUserData != null) {
     
      if (userService.currentUserData?.data.token.isNotEmpty ?? false) {
        Get.off(() => BottomNavigationBarScreen(index: 0));
        return;
      } else {
        Get.off(() => LoginScreen());
      }
    } else {
      Get.off(() => OnBoardingScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100.w),
              child: Image.asset(Images.splasImage, width: 40.w, height: 40.w),
            ),
          ],
        ),
      ),
    );
  }
}
