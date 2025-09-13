
import 'package:esimtel/utills/TimeZoneHelper.dart';
import 'package:esimtel/utills/failurewidget.dart';
import 'package:esimtel/utills/global.dart' as global;
import 'package:esimtel/utills/image.dart';
import 'package:esimtel/utills/services/ApiService.dart';
import 'package:esimtel/views/notificationModule/noti_bloc/noti_bloc.dart';
import 'package:esimtel/views/notificationModule/noti_bloc/noti_event.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esimtel/views/profileMoulde/historyOrdermodule/order_history_bloc/fetchOrderhistory_bloc.dart';
import 'package:esimtel/views/profileMoulde/historyOrdermodule/view/ordersScreen.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/views/myTicketScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../model/NotificationResponse.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final scrollController = ScrollController();
  String? nextPageUrl;
  bool isLoadingMore = false;
  List<Datum> _notificationList = [];
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<FetchNotificationbloc>().add(
        fetchNotiEvent(isAllread: "all"),
      );
      scrollController.addListener(_pagination);
    });
  }

  void _pagination() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (nextPageUrl != null && !isLoadingMore) {
        context.read<FetchNotificationbloc>().add(
          fetchNotiEvent(isAllread: "all", url: nextPageUrl),
        );
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldbackgroudColor,
      appBar: AppBar(title: const Text("Notifications").tr()),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<FetchNotificationbloc>().add(
            fetchNotiEvent(isAllread: "all"),
          );
        },
        child:
            BlocConsumer<FetchNotificationbloc, ApiState<NotificationResponse>>(
              listener: (context, state) {
                if (state is ApiLoading && _notificationList.isNotEmpty) {
                  isLoadingMore = true;
                  setState(() {});
                } else if (state is ApiSuccess) {
                  setState(() {
                   
                    if (state.data?.data?.prevPageUrl == null) {
                      _notificationList = state.data?.data?.data ?? [];
                    } else {
                      _notificationList.addAll(state.data?.data?.data ?? []);
                    }
                    nextPageUrl = state.data?.data?.nextPageUrl;
                    isLoadingMore = false;
                  });
                } else if (state is ApiFailure) {
                  isLoadingMore = false;
                  setState(() {});
                }
              },

              builder: (context, state) {
                if (state is ApiLoading && _notificationList.isEmpty) {
                  return ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 4.w,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Skeletonizer(
                        enabled: true,
                        child: Container(
                          height: 10.h,
                          margin: EdgeInsets.only(bottom: 1.w),
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2.w),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 2.w,
                                width: 60.w,
                                color: Colors.grey.shade300,
                              ),
                              SizedBox(height: 1.5.w),
                              Container(
                                height: 2.w,
                                width: 40.w,
                                color: Colors.grey.shade300,
                              ),
                              SizedBox(height: 1.5.w),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  height: 2.w,
                                  width: 20.w,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                if (state is ApiFailure) {
                  // Show failure widget on error
                  return ApiFailureWidget(
                    onRetry: () {
                      context.read<FetchNotificationbloc>().add(
                        fetchNotiEvent(isAllread: "all"),
                      );
                    },
                  );
                }
                if (_notificationList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sim_card_outlined,
                          color: Colors.grey.shade400,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No notification found.',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                color: Colors.grey.shade600,
                                fontSize: 18,
                              ),
                        ).tr(),
                      ],
                    ),
                  );
                }
                  final filteredList = _notificationList
                        .where((item) => item.type != 10)
                        .toList();
                return ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.w),
                  itemCount:
                      filteredList.length + (nextPageUrl != null ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == filteredList.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.w),
                        child: Center(
                          child: global.showPaginationLoader(context),
                        ),
                      );
                    }
                  
                    final item = filteredList[index];
                    return GestureDetector(
                      onTap: () {
                        if (item.type == 1) {
                          Get.to(
                            () => BlocProvider(
                              create: (context) =>
                                  FetchOrderHistorybloc(ApiService()),
                              child: OrdersScreen(),
                            ),
                          );
                        } else if (item.type == 9) {
                          Get.to(() => MyTicketsScrren());
                        } else {
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 1.w),
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 3.w,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2.w),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: item.title ?? "",
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      fontSize: 16.sp,
                                      color: AppColors.textColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                                children: [
                                  WidgetSpan(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 2),
                                      child: item.title == "Order Placed"
                                          ? Image.asset(
                                              Images.kycapproved,
                                              height: 15,
                                            )
                                          : item.title == "Your Esim Activated!"
                                          ? Image.asset(
                                              Images.intantTopUp,
                                              height: 15,
                                            )
                                          : item.title == "Plan Expiring"
                                          ? Image.asset(
                                              Images.kycpending,
                                              height: 15,
                                            )
                                          : SizedBox(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 1.w),
                            Text(
                              item.description!,
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    fontSize: 15.sp,
                                    color: AppColors.textGreyColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                TimeZoneHelper().formatUtcToLocal(
                                  item.createdAt!,
                                ),
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      fontSize: 13.sp,
                                      color: AppColors.textGreyColor,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      ),
    );
  }
}
