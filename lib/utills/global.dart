import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/utills/image.dart';
import 'package:url_launcher/url_launcher.dart';

SharedPreferences? sp;
AndroidDeviceInfo? androidInfo;
IosDeviceInfo? iosInfo;
var appVersion = "1.0.0";
String? deviceId;
String? appName = "ESimTel";
String? fcmToken;
String? deviceLocation;
String? deviceManufacturer;
String? deviceModel;
String? activeCurrency = "";
DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

String paymentMode = '';
String UserkycStatus = '';

String getAppVersion() {
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    appVersion = packageInfo.version;
  });
  return appVersion;
}

extension StringExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

showToastMessage({required String message}) async => Fluttertoast.showToast(
  msg: message,
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 1,
  backgroundColor: AppColors.toastBackgroungColor,
  textColor: AppColors.toastTextColor,
  fontSize: 15.sp,
);

void copyToClipboard({required BuildContext context, required String text}) {
  Clipboard.setData(ClipboardData(text: text)).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Referral code copied to clipboard!')),
    );
  });
}

void launchPlayStore() async {
  const packageName = 'com.esimtel.app';
  final uri = Uri.parse("market://details?id=$packageName");
  if (await launchUrl(uri)) {
    await launchUrl(
      Uri.parse("https://play.google.com/store/apps/details?id=$packageName"),
    );
  }
}

void showLoader(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Center(
      child: Container(
        height: 60,
        width: 70.w,
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: Lottie.asset(
          Images.circleLoader,
          width: 80,
          height: 80,
          repeat: true,
        ),
      ),
    ),
  );
}

String referralLink = '';

Future<Map<String, dynamic>> getDeviceDetails() async {
  final deviceInfo = DeviceInfoPlugin();
  final packageInfo = await PackageInfo.fromPlatform();
  final fcmToken = Platform.isAndroid
      ? await FirebaseMessaging.instance.getToken()
      : await FirebaseMessaging.instance.getAPNSToken();

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    return {
      'deviceid': androidInfo.id,
      'fcmToken': fcmToken,
      'deviceLocation': '',
      'deviceManufacture': androidInfo.manufacturer,
      'deviceModel': androidInfo.model,
      'appVersion': packageInfo.version,
      'osVersion': androidInfo.version.release,
    };
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;

    return {
      'deviceid': iosInfo.identifierForVendor,
      'fcmToken': fcmToken,
      'deviceLocation': '',
      'deviceManufacture': 'Apple',
      'deviceModel': iosInfo.utsname.machine,
      'appVersion': packageInfo.version,
      'osVersion': iosInfo.systemVersion,
    };
  }
  return {};
}

Future<void> shareContent({required String text, String? subject}) async {
  await Share.share(text, subject: subject);
}

Widget showPaginationLoader(BuildContext context) {
  return SizedBox(
    height: 50,
    child: Column(
      children: [
        SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        SizedBox(height: 2.w),
        Text(
          "Hold on Loading content...",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: AppColors.textGreyColor,
            fontSize: 15.sp,
          ),
        ),
      ],
    ),
  );
}

String formatPrice(double? price) {
  if (price == null) return 'N/A';
  return price % 1 == 0
      ? price.toStringAsFixed(0) // no decimals
      : price.toStringAsFixed(1); // keep two decimals
}
