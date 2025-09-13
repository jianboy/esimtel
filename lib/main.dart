import 'dart:async';
import 'dart:developer';
import 'package:esimtel/utills/TimeZoneHelper.dart';
import 'package:esimtel/utills/UserService.dart';
import 'package:esimtel/utills/binding/networkBinding.dart';
import 'package:esimtel/utills/connectivity/connectivity_bloc.dart';
import 'package:esimtel/utills/notificationUtils.dart';
import 'package:esimtel/views/authModule/auth_controller/LoginController.dart';
import 'package:esimtel/views/authModule/auth_controller/OtpController.dart';
import 'package:esimtel/views/homeModule/controller/homeController.dart';
import 'package:esimtel/views/myEsimModule/controller/myesimController.dart';
import 'package:esimtel/views/onBoardModule/controller/onboardController.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:esimtel/theme/bloc/them_block.dart';
import 'package:esimtel/theme/bloc/theme_state.dart';
import 'package:esimtel/theme/nativetheme.dart';
import 'package:esimtel/utills/FallbackLocalizationDelegate.dart';
import 'package:esimtel/utills/app_providers.dart';
import 'package:esimtel/utills/firebase_options.dart';
import 'package:esimtel/views/authModule/view/splashscreen.dart';
import 'package:esimtel/views/navbarModule/bloc/navbar_bloc.dart';
import 'views/packageModule/packagesList/controller/packagelistcontorller.dart';
import 'views/packageModule/regionsList/controller/regionalcontroller.dart';
import 'views/profileMoulde/historyOrdermodule/controller/orderhistoryController.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotificationUtils().foregroundNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EasyLocalization.ensureInitialized();
  InAppPurchaseAndroidPlatform.registerPlatform();
  await dotenv.load(fileName: ".env");
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;// For STRIP create .env file and add its key in it STRIPE_PUBLISHABLE_KEY= ""
  await Stripe.instance.applySettings();
  TimeZoneHelper.initialize();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Get.put(UserService()); //! getting current user data globally
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('hi', 'IN')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: const Locale('en', 'US'),
      saveLocale: true,
      child: MultiProvider(
        providers: [...appProviders],
        child: BlocProvider(
          create: (context) => ConnectivityBloc(),
          child: MyApp(),
        ),
      ),
    ),
  );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xff2323FF),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final loginController = Get.put(LoginController());
  final otpController = Get.put(OtpController());
  final orderHistoryController = Get.put(OrderHistoryController());
  final packagelistcontorller = Get.put(PackageListController());
  final myeSimController = Get.put(MyESimController());
  final homeController = Get.put(HomeController());
  final bottmconrolltre = Get.put(BottomNavController());
  final onboardController = Get.put(OnBoardController());
  final regionalListCntroller = Get.put(RegionalListController());
  bool _isSnackbarActive = false;

  @override
  void initState() {
    super.initState();
    NotificationUtils().requestNotificationPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationUtils().foregroundNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Notification data: ${message.data['type']}');
      if (message.data['type'] == '3') {
        Get.find<BottomNavController>().navigateToTab(2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, state) {
        if (state is Disconnected) {
          if (!_isSnackbarActive) {
            _isSnackbarActive = true;
            Get.showSnackbar(
              GetSnackBar(
                messageText: Center(
                  child: Text(
                    'No internet connection!',
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ).tr(),
                ),
                backgroundColor: Colors.red,
                duration: Duration(days: 1),
                isDismissible: false,
                margin: EdgeInsets.zero,
                snackPosition: SnackPosition.TOP,
                barBlur: 0,
              ),
            );
          }
        } else if (state is Connected) {
          if (_isSnackbarActive) {
            Get.back();
            Get.showSnackbar(
              GetSnackBar(
                messageText: Center(
                  child: Text(
                    'Internet is back!',
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ).tr(),
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
                snackPosition: SnackPosition.TOP,
                margin: EdgeInsets.zero,
                barBlur: 0,
              ),
            );
            _isSnackbarActive = false;
          }
        }
      },
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return Sizer(
            builder: (context, orientation, screenType) {
              return GetMaterialApp(
                defaultTransition: Transition.rightToLeftWithFade,
                debugShowCheckedModeBanner: false,
                locale: context.locale,
                localizationsDelegates: [
                  ...context.localizationDelegates,
                  FallbackLocalizationDelegate(),
                ],
                initialBinding: NetworkBinding(),
                supportedLocales: context.supportedLocales,
                theme: nativeTheme(
                  appPrimaryColor: state.primaryColor,
                  primaryColorInt: state.pickIntColor,
                ),
                title: "Esim",
                home: SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
