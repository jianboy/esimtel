import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/config.dart';
import 'package:esimtel/views/homeModule/controller/homeController.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/Model/userProfileModel.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/profile_bloc/userprofile_bloc.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/profile_bloc/userprofile_event.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/utills/image.dart';
import 'package:esimtel/views/homeModule/getUsageModule/views/homeScreen.dart';
import 'package:esimtel/views/myEsimModule/view/myEsimScreen.dart';
import 'package:esimtel/views/navbarModule/bloc/navbar_bloc.dart';
import 'package:esimtel/views/packageModule/packagesList/view/packageScreen.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/views/profileScreen.dart';
import 'package:esimtel/utills/global.dart' as global;
import 'package:skeletonizer/skeletonizer.dart';
import '../../homeModule/datapackModule/bloc/datapack_bloc.dart';
import '../../homeModule/datapackModule/bloc/datapack_event.dart';
import '../../notificationModule/view/notificationScreen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  final int index;
  const BottomNavigationBarScreen({super.key, this.index = 0});
  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  List<String> iconList = [
    Images.homeIcon,
    Images.packagesIcon,
    Images.eSIMIcon,
    Images.userProfileIcon,
  ];
  List<String> boldiconList = [
    Images.homeBoldIcon,
    Images.packagesBoldIcon,
    Images.eSIMBoldIcon,
    Images.userProfileBoldIcon,
  ];

  List<String> tabList = ['Home', 'Packages', 'My eSims', 'Profile'];
  final navController = Get.find<BottomNavController>();
  late PersistentTabController persistancecontroller;

  @override
  void initState() {
    super.initState();
    persistancecontroller = PersistentTabController(initialIndex: widget.index);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      navController.globalController = persistancecontroller;
      navController.selectedIndex.value = widget.index;
      context.read<UserProfileBloc>().add(UserProfileEvent());
      global.getAppVersion();
    });
  }

  List<Widget> screens() {
    return [HomeScreen(), PackagesScreen(), MyEsimsScreen(), ProfileScreen()];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool isExit = await navController.onBackPressed();
        if (isExit) {
          exit(0);
        }
        return isExit;
      },
      child: GetBuilder<BottomNavController>(
        builder: (navController) => Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.scaffoldbackgroudColor,
          appBar: AppBar(
            surfaceTintColor: AppColors.whiteColor,
            backgroundColor: AppColors.scaffoldbackgroudColor,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: AppColors.whiteColor,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
            ),
            automaticallyImplyLeading: false,
            flexibleSpace: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Images.worldMapImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.5), 
                        Colors.white, 
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ],
            ),
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: navController.selectedIndex.value == 0
                  ? BlocConsumer<UserProfileBloc, ApiState<UserProfileModel>>(
                      listener: (context, state) async {
                        if (state is ApiSuccess) {
                          global.sp = await SharedPreferences.getInstance();
                          await global.sp!.setString(
                            "Currency",
                            (state.data?.data?.currency?.symbol.toString() ??
                                ''),
                          );
                          global.activeCurrency = global.sp?.getString(
                            "Currency",
                          );
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is ApiLoading;
                        Widget profileImageWidget;
                        if (isLoading) {
                          return Skeletonizer(
                            enabled: true,
                            child: profileDataWidget(
                              profileImageWidget: Container(
                                height: 10.w,
                                width: 10.w,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              userData: null,
                            ),
                          );
                        }

                        if (state is ApiSuccess) {
                          final userData = state.data?.data;
                          final hasValidImage =
                              userData?.imagePath != null &&
                              userData?.imagePath != "null";
                          if (hasValidImage) {
                            profileImageWidget = CachedNetworkImage(
                              imageUrl: "$imageBaseUrl/${userData!.imagePath!}",
                              placeholder: (context, url) => const SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.1,
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                child: Image.asset(
                                  Images.userProfileIcon,
                                  fit: BoxFit.cover,
                                  color: AppColors.primaryColor,
                                  height: 10.w,
                                  width: 10.w,
                                ),
                              ),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    height: 10.w,
                                    width: 10.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            );
                          } else {
                            profileImageWidget = Container(
                              height: 10.w,
                              width: 10.w,
                              padding: EdgeInsets.all(1.w),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              child: Image.asset(
                                Images.userProfileIcon,
                                fit: BoxFit.cover,
                                color: AppColors.primaryColor,
                                height: 10.w,
                                width: 10.w,
                              ),
                            );
                          }
                          return profileDataWidget(
                            profileImageWidget: profileImageWidget,
                            userData: userData,
                          );
                        }
                        return SizedBox();
                      },
                    )
                  : Text(
                      navController.selectedIndex.value == 1
                          ? tr("Data Packages")
                          : navController.selectedIndex.value == 2
                          ? tr("My eSims")
                          : tr('My Profile'),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 17.sp,
                        color: AppColors.textColor,
                      ),
                    ),
            ),
          ),
          body: SizedBox(
            height: double.infinity,
            child: PersistentTabView(
              controller: persistancecontroller,
              onTabChanged: (index) async {
                navController.jumpToTab(index);
                debugPrint("Tab changed to $index");
                if (index == 0) {
                  context.read<DataPackBloc>().add(
                    DatapackEvent(isdatapack: true),
                  );
                  Get.find<HomeController>().isSelected[0] = true;
                  Get.find<HomeController>().isSelected[1] = false;
                  Get.find<HomeController>().update();
                }
              },
              handleAndroidBackButtonPress: true,
              stateManagement: false,
              tabs: List.generate(iconList.length, (index) {
                if (index == 0) {
                  return PersistentTabConfig(
                    screen: screens().elementAt(index),
                    item: ItemConfig(
                      activeForegroundColor: AppColors.primaryColor,
                      inactiveForegroundColor: Colors.grey.shade500,
                      icon: Image.asset(
                        boldiconList[index],
                        height: 6.w,
                        color: AppColors.primaryColor,
                      ),
                      inactiveIcon: Image.asset(iconList[index], height: 6.w),
                      title: tr(tabList[index]),
                    ),
                  );
                } else if (index == 1) {
                  return PersistentTabConfig(
                    screen: screens().elementAt(index),
                    item: ItemConfig(
                      activeForegroundColor: AppColors.primaryColor,
                      inactiveForegroundColor: Colors.grey.shade500,
                      icon: Image.asset(
                        boldiconList[index],
                        height: 6.w,
                        color: AppColors.primaryColor,
                      ),
                      inactiveIcon: Image.asset(iconList[index], height: 6.w),
                      title: tr(tabList[index]),
                    ),
                  );
                } else {
                  return PersistentTabConfig(
                    screen: screens().elementAt(index),
                    item: ItemConfig(
                      activeForegroundColor: AppColors.primaryColor,
                      inactiveForegroundColor: Colors.grey.shade500,
                      title: tr(tabList[index]),
                      icon: Image.asset(
                        boldiconList[index],
                        height: 6.w,
                        color: AppColors.primaryColor,
                      ),
                      inactiveIcon: Image.asset(iconList[index], height: 6.w),
                    ),
                  );
                }
              }),
              navBarBuilder: (navBarConfig) => Style6BottomNavBar(
                navBarDecoration: NavBarDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                navBarConfig: navBarConfig,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class profileDataWidget extends StatelessWidget {
  const profileDataWidget({
    super.key,
    required this.profileImageWidget,
    required this.userData,
  });
  final Widget profileImageWidget;
  final Data? userData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Get.find<BottomNavController>().jumpToTab(3);
          },
          child: profileImageWidget,
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(Images.ESimTel_TextLogo, width: 60),
            Text(
              "${userData?.name ?? "User"}",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.textColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            Get.to(() => NotificationScreen());
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(Images.notificationIcon, height: 7.w),
              userData?.totalUnreadNoti != null &&
                      userData?.totalUnreadNoti.toString() != "0"
                  ? Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.redColor,
                        ),
                        child: Text(
                          "${userData?.totalUnreadNoti}",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
