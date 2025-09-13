import 'package:esimtel/utills/UserService.dart' show UserService;
import 'package:esimtel/utills/services/ApiService.dart';
import 'package:esimtel/views/homeModule/bannersModule/bloc/banner_bloc.dart';
import 'package:esimtel/views/homeModule/bannersModule/bloc/banner_event.dart';
import 'package:esimtel/views/homeModule/bannersModule/view/bannersList.dart';
import 'package:esimtel/views/homeModule/datapackModule/bloc/datapack_bloc.dart';
import 'package:esimtel/views/homeModule/getUsageModule/views/bottomContainer.dart';
import 'package:esimtel/views/homeModule/getUsageModule/views/getusageSkelton.dart';
import 'package:esimtel/views/homeModule/getUsageModule/views/regionalPlans.dart';
import 'package:esimtel/views/homeModule/getUsageModule/views/swithExample.dart';
import 'package:esimtel/views/homeModule/popularModule/popularbloc/mostpopularbloc.dart';
import 'package:esimtel/views/homeModule/popularModule/views/popularEsims.dart';
import 'package:esimtel/views/homeModule/getUsageModule/views/populardestination.dart';
import 'package:esimtel/views/packageModule/regionsList/regionList_bloc/region_bloc.dart';
import 'package:esimtel/views/packageModule/regionsList/regionList_bloc/region_event.dart';
import 'package:esimtel/views/profileMoulde/historyOrdermodule/order_history_bloc/fetchOrderhistory_bloc.dart';
import 'package:esimtel/views/profileMoulde/historyOrdermodule/view/ordersScreen.dart';
import 'package:esimtel/widgets/CanvasStyle/topWaveCliper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/utills/image.dart';
import 'package:esimtel/views/homeModule/getUsageModule/bloc/home_bloc.dart';
import 'package:esimtel/views/homeModule/getUsageModule/bloc/home_event.dart';
import 'package:esimtel/views/homeModule/getUsageModule/model/dataUsage_Model.dart';
import 'package:esimtel/views/homeModule/getUsageModule/views/quickActions.dart';
import 'package:esimtel/views/packageModule/packagesList/bloc/country_bloc/countriesListbloc.dart';
import 'package:esimtel/views/packageModule/packagesList/bloc/country_bloc/country_event.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../utills/global.dart' as global;
import '../../../navbarModule/bloc/navbar_bloc.dart';
import '../../../notificationModule/noti_bloc/noti_bloc.dart';
import '../../../notificationModule/noti_bloc/noti_event.dart';
import '../../../profileMoulde/userProfileModule/Model/userProfileModel.dart';
import '../../../profileMoulde/userProfileModule/profile_bloc/userprofile_bloc.dart';
import '../../../profileMoulde/userProfileModule/profile_bloc/userprofile_event.dart';
import '../../datapackModule/bloc/datapack_event.dart';
import '../../deviceinfo/view/device_info_screen.dart';
import 'PackageCarousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final navController = Get.find<BottomNavController>();
  final currentUser = UserService.to;
  bool isDataAvailable = true;
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(HomeEvent());
    context.read<UserProfileBloc>().add(UserProfileEvent());
    context.read<RegionsListBloc>().add(RegionsListEvent());
    context.read<BannerBloc>().add(BannerEvent());
    context.read<CountryBloc>().add(CountryEvent());
    context.read<DataPackBloc>().add(DatapackEvent(isdatapack: true));
    context.read<FetchNotificationbloc>().add(fetchNotiEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(HomeEvent());
          context.read<UserProfileBloc>().add(UserProfileEvent());
          context.read<MostPopularbloc>().add(popularEvent(is_popular: '1'));
          context.read<FetchNotificationbloc>().add(fetchNotiEvent());
        },
        child: Scaffold(
          backgroundColor: AppColors.scaffoldbackgroudColor,
          body: SingleChildScrollView(
            child: BlocListener<UserProfileBloc, ApiState<UserProfileModel>>(
              listener: (context, state) {
                if (state is ApiSuccess) {
                  global.paymentMode = state.data?.data?.payment_mode ?? '';
                  global.UserkycStatus = state.data?.data?.kycstatus ?? '';
                }
              },
              child: Column(
                children: [
                  SizedBox(height: 2.w),
                  BlocConsumer<HomeBloc, ApiState<DataUsageModel>>(
                    listener: (context, state) {
                      if (state is ApiFailure) {}
                      if (state is ApiSuccess) {
                        if (state.data?.data!.isEmpty ?? false) {
                          setState(() {
                            isDataAvailable = false;
                          });
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state is ApiLoading) {
                        return Skeletonizer(
                          enabled: state is ApiLoading,
                          child: GetUsageCardSkeleton(),
                        );
                      } else if (state is ApiSuccess) {
                        if (state.data?.data!.isEmpty ?? false) {
                          isDataAvailable = false;
                          return const BuildBannerWidget();
                        } else {
                          return PackageCarousel(
                            data: state.data!.data!,
                            isLoading: false,
                          );
                        }
                      } else if (state is ApiFailure) {
                        return SizedBox.shrink();
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Quick Actions",
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                        ).tr(),
                        SizedBox(height: 4.w),
                        SizedBox(
                          height: 12.h,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              QuickAction(
                                onpressed: () {
                                  debugPrint('clicked data pack NO');
                                  navController.jumpToTab(1);
                                },
                                icon: Icons.data_usage,
                                label: tr("Data Pack"),
                              ),
                              QuickAction(
                                onpressed: () {
                                  debugPrint('clicked Myesim');
                                  navController.jumpToTab(2);
                                },
                                icon: Icons.sim_card,
                                label: tr("My eSims"),
                              ),
                              QuickAction(
                                onpressed: () {
                                  debugPrint('Device Compatibility');
                                  Get.to(() => DeviceInfoScreen());
                                },
                                icon: Icons.devices,
                                label: tr("Device"),
                              ),
                              QuickAction(
                                onpressed: () {
                                  debugPrint('Going to Installation Guide');
                                  Get.to(
                                    () => BlocProvider(
                                      create: (context) =>
                                          FetchOrderHistorybloc(ApiService()),
                                      child: OrdersScreen(),
                                    ),
                                  );
                                },
                                icon: Icons.history,
                                label: tr("My Orders"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.w),
                  PopularEsims(),
                  SizedBox(height: 5.w),
                  SwitchExample(),
                  SizedBox(height: 5.w),
                  Regionalplans(),
                  SizedBox(height: 10.w),
                  isDataAvailable == false ? SizedBox() : BuildBannerWidget(),
                  SizedBox(height: 5.w),
                  PopularDistinctios(),
                  SizedBox(height: 12.w),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipPath(
                      clipper: WaveClipper(top: true),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 10.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.w),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE3F2FD), Color(0xFFFFF3E0)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BottomContainer(
                              imagepath: Images.secureTransactions,
                              label: tr("Secure\nTransactions"),
                            ),
                            BottomContainer(
                              imagepath: Images.guaranteedRewards,
                              label: tr("Instant\nActivation"),
                            ),
                            BottomContainer(
                              imagepath: Images.intantTopUp,
                              label: tr("Top-Up\nAnytime"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
