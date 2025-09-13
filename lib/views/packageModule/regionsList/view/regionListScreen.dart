import 'package:esimtel/utills/failurewidget.dart';
import 'package:esimtel/utills/global.dart' as global;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esimtel/utills/global.dart';
import 'package:esimtel/utills/image.dart';
import 'package:esimtel/views/packageModule/packagesList/view/checkoutscreen.dart';
import 'package:esimtel/views/packageModule/regionsList/controller/regionalcontroller.dart';
import 'package:esimtel/views/packageModule/regionsList/model/regionDetailsModel.dart';
import 'package:esimtel/views/packageModule/regionsList/regionDetail_bloc/regionDetails_bloc.dart';
import 'package:esimtel/views/packageModule/regionsList/regionDetail_bloc/regionDetails_event.dart';
import 'package:esimtel/views/packageModule/regionsList/view/regionDetailScreen.dart';
import 'package:esimtel/widgets/custiomOutlinedButton.dart';
import 'package:esimtel/widgets/CustomElevatedButton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/widgets/loadingSkeletion.dart';

import '../../../homeModule/kycFormModule/view/KycFormScreen.dart';
import '../../../profileMoulde/userProfileModule/profile_bloc/userprofile_bloc.dart';

class RegionListScreen extends StatefulWidget {
  final String regionId;
  const RegionListScreen({super.key, required this.regionId});
  @override
  State<RegionListScreen> createState() => _RegionListScreenState();
}

class _RegionListScreenState extends State<RegionListScreen> {
  final reglController = Get.find<RegionalListController>();
  List<Datum> dataList = List.empty(growable: true);
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.removeListener(_pagination);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegionDatailsBloc>().add(
        RegionsDetailsEvent(regionId: widget.regionId),
      );
      reglController.selectedFilter = FilterType.none;
      reglController.regionDatailsList.clear();
      scrollController.addListener(_pagination);
      reglController.selectedindex = 0;
      reglController.update();
    });
  }

  void _pagination() {
    final position = scrollController.position;
    if (position.pixels < position.maxScrollExtent - 200) {
      if (!reglController.showLoadMoreHint) {
        reglController.showLoadMoreHint = true;
        reglController.update();
      }
    } else {
      if (reglController.showLoadMoreHint) {
        reglController.showLoadMoreHint = false;
        reglController.update();
      }
    }
    if (position.pixels >= position.maxScrollExtent &&
        reglController.nextPageUrl != null &&
        !reglController.isLoadingMore) {
      reglController.isLoadingMore = true;
      reglController.update();

      if (mounted) {
        context.read<RegionDatailsBloc>().add(
          RegionsDetailsEvent(
            regionId: widget.regionId,
            url: reglController.nextPageUrl,
            isUnlimited:
                reglController.selectedFilter == FilterType.unlimitedPlans,
            dataPack: reglController.selectedFilter == FilterType.dataPack,
            isLowToHigh:
                reglController.selectedFilter == FilterType.priceLowToHigh,
            isHighToLow:
                reglController.selectedFilter == FilterType.priceHighToLow,
          ),
        );
        reglController.selectedindex = 0;
        reglController.update();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: RefreshIndicator(
        onRefresh: () async {
          reglController.regionDatailsList.clear();
          reglController.selectedFilter = FilterType.none;
          context.read<RegionDatailsBloc>().add(
            RegionsDetailsEvent(regionId: widget.regionId),
          );
          scrollController.addListener(_pagination);
          reglController.selectedindex = 0;
          reglController.update();
        },
        child: BlocListener<UserProfileBloc, ApiState>(
          listener: (context, state) {
            if (state is ApiSuccess) {
              global.paymentMode = state.data?.data?.payment_mode ?? '';
              global.UserkycStatus = state.data?.data?.kycstatus ?? '';

            }
          },
          child: GetBuilder<RegionalListController>(
            builder: (reglController) => Scaffold(
              floatingActionButton: reglController.showLoadMoreHint
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 15.w),
                      child: FloatingActionButton(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        highlightElevation: 0,
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onPressed: () {
                          scrollController.animateTo(
                            scrollController.offset + 200,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : null,
              backgroundColor: AppColors.scaffoldbackgroudColor,
              body: GetBuilder<RegionalListController>(
                builder: (reglController) {
                  return BlocConsumer<
                    RegionDatailsBloc,
                    ApiState<RegionDetailsModel>
                  >(
                    listener: (context, state) {
                      if (state is ApiLoading) {
                        reglController.isLoadingMore = true;
                        reglController.update();
                      } else if (state is ApiSuccess<RegionDetailsModel>) {
                        if (state.data!.links!.prev == null) {
                          reglController.regionDatailsList.addAll(
                            state.data!.data ?? [],
                          );

                          reglController.update();
                        } else {
                          reglController.regionDatailsList.addAll(
                            state.data!.data ?? [],
                          );
                          reglController.update();
                        }
                        reglController.nextPageUrl = state.data!.links!.next;
                        reglController.isLoadingMore = false;
                      } else if (state is ApiFailure) {
                        reglController.isLoadingMore = false;
                      }
                      reglController.update();
                    },
                    builder: (context, state) {
                      dataList = reglController.regionDatailsList;
                      if (state is ApiLoading && dataList.isEmpty) {
                        return Center(
                          child: Skeletonizer(
                            enabled: true,
                            child: ScrollViewSkeletion(),
                          ),
                        );
                      } else if (state is ApiFailure && dataList.isEmpty) {
                        return ApiFailureWidget(
                          onRetry: () {
                            context.read<RegionDatailsBloc>().add(
                              RegionsDetailsEvent(regionId: widget.regionId),
                            );
                          },
                        );
                      }
                      return CustomScrollView(
                        controller: scrollController,
                        slivers: <Widget>[
                          SliverAppBar(
                            backgroundColor: AppColors.primaryColor,
                            pinned: true,
                            expandedHeight: 230.0,
                            title: Text("Regional Palns"),
                            flexibleSpace: FlexibleSpaceBar(
                              background: Container(
                                padding: EdgeInsets.only(left: 5.w),
                                alignment: Alignment.bottomLeft,
                                color: AppColors.blackColor,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: dataList.isNotEmpty
                                          ? dataList[0].region!.image.toString()
                                          : '',
                                      placeholder: (context, url) => SizedBox(
                                        width: 15.w,
                                        height: 15.w,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                            Images.earthImage,
                                            width: 15.w,
                                            height: 15.w,
                                          ),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                            width: 15.w,
                                            height: 15.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                    ),
                                    SizedBox(height: 3.h),
                                    Text(
                                      dataList.isNotEmpty
                                          ? dataList[0].region!.name ?? 'N/A'
                                          : 'N/A',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.whiteColor,
                                          ),
                                    ),
                                    SizedBox(height: 7.h),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(
                                16.0,
                                20.0,
                                16.0,
                                8.0,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.scaffoldbackgroudColor,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Choose Days',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textColor,
                                        ),
                                  ).tr(),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(30.w),
                                    onTap: () {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            _showFilterOptions();
                                          });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          30.w,
                                        ),
                                        color: AppColors.primaryColor
                                            .withOpacity(0.1),
                                        border: Border.all(
                                          color: AppColors.primaryColor,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Filter",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.primaryColor,
                                                ),
                                          ).tr(),
                                          SizedBox(width: 1.w),
                                          Icon(
                                            Icons.filter_list_rounded,
                                            color: AppColors.primaryColor,
                                            size: 18.sp,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          if (dataList.isNotEmpty)
                            SliverGrid(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final Datum plan = dataList[index];
                                return GestureDetector(
                                  onTap: () {
                                    reglController.selectedindex = index;
                                    reglController.regionDatailsList = dataList;
                                    reglController.update();
                                  },
                                  child: _buildDataPlanCard(
                                    context,
                                    index: index,
                                    plan: plan,
                                    onpressed: () {
                                      Get.to(
                                        () => RegionDetailScreen(
                                          regionDatailsList: reglController
                                              .regionDatailsList[index],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }, childCount: dataList.length),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 0,
                                    childAspectRatio: 0.8,
                                  ),
                            )
                          else if (reglController.regionDatailsList.isEmpty &&
                              state is ApiSuccess)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Container(
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
                                      'No Packages available Currently',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Colors.grey.shade600,
                                            fontSize: 18,
                                          ),
                                    ).tr(),
                                  ],
                                ),
                              ),
                            ),

                          if (reglController.isLoadingMore)
                            SliverToBoxAdapter(
                              child: global.showPaginationLoader(context),
                            ),

                          SliverToBoxAdapter(child: SizedBox(height: 10.h)),
                        ],
                      );
                    },
                  );
                },
              ),
              bottomSheet: (reglController.regionDatailsList.isNotEmpty)
                  ? _buildBottomBar(context)
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return GetBuilder<RegionalListController>(
      builder: (regionallistcontroller) {
        if (regionallistcontroller.regionDatailsList.isEmpty) {
          return const SizedBox.shrink();
        }
        return Container(
          height: 9.h,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.blackColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$activeCurrency ${regionallistcontroller.regionDatailsList[regionallistcontroller.selectedindex].netPrice}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteColor,
                  ),
                ),
                CustomElevatedButton(
                  onPressed: () {
                
                    dynamic mins =
                        ((regionallistcontroller
                                            .regionDatailsList[regionallistcontroller
                                                .selectedindex]
                                            .name ??
                                        "")
                                    .split(" - ")
                                as List<String>)
                            .firstWhere(
                              (part) => part.contains("Mins"),
                              orElse: () => "0",
                            );
                    dynamic sms =
                        ((regionallistcontroller
                                            .regionDatailsList[regionallistcontroller
                                                .selectedindex]
                                            .name ??
                                        "")
                                    .split(" - ")
                                as List<String>)
                            .firstWhere(
                              (part) => part.contains("SMS"),
                              orElse: () => "0",
                            );
                    int minsValue =
                        int.tryParse(mins.replaceAll(RegExp(r'[^0-9]'), "")) ??
                        0;
                    int smsValue =
                        int.tryParse(sms.replaceAll(RegExp(r'[^0-9]'), "")) ??
                        0;
                    print('''
                          📦 Regional Buying Info:
                            • kyc Status   : ${global.UserkycStatus}
                            • sms Status   : $smsValue
                            • mins Status  : $minsValue
              
                     ''');
                    if (global.UserkycStatus != "approved" &&
                        (int.parse(smsValue.toString()) > 0 ||
                            int.parse(minsValue.toString()) > 0)) {
                      Get.to(() => KycFormScreen());
                      // 🚫 Block action
                      global.showToastMessage(
                        message: "Please complete KYC first.",
                      );
                      return;
                    }

                    Get.to(
                      () => Checkoutscreen(
                        packageListInfo:
                            regionallistcontroller
                                .regionDatailsList[regionallistcontroller
                                .selectedindex],
                      ),
                    );
                  },
                  text: tr('Buy Now'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDataPlanCard(
    BuildContext context, {
    required Datum plan,
    required VoidCallback onpressed,
    required int index,
  }) {
    return GetBuilder<RegionalListController>(
      builder: (regionalListController) {
        bool showSpecialLabel =
            plan.is_recommend == true ||
            plan.is_popular == true ||
            plan.is_best_value == true;

        final List<String> nameParts = (plan.name ?? "").split(" - ");
        final String totalMins = nameParts.firstWhere(
          (part) => part.contains("Mins"),
          orElse: () => "N/A",
        );
        final String totalSMS = nameParts.firstWhere(
          (part) => part.contains("SMS"),
          orElse: () => "N/A",
        );

        return Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
              decoration: BoxDecoration(
                color: plan.is_recommend == true
                    ? AppColors.greenColor.withOpacity(0.1)
                    : plan.is_popular == true
                    ? Colors.orange.withOpacity(0.1)
                    : plan.is_best_value == true
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: regionalListController.selectedindex == index
                      ? AppColors.primaryColor
                      : plan.is_recommend == true
                      ? AppColors.greenColor
                      : plan.is_popular == true
                      ? Colors.orange
                      : plan.is_best_value == true
                      ? Colors.blue
                      : Colors.grey[300]!,
                  width: regionalListController.selectedindex == index
                      ? 1.5
                      : 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showSpecialLabel)
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 35.w,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: plan.is_recommend == true
                              ? AppColors.greenColor
                              : plan.is_popular == true
                              ? Colors.orange
                              : plan.is_best_value == true
                              ? Colors.blue
                              : Colors.grey[300]!,
                          borderRadius: BorderRadius.circular(30.w),
                        ),
                        child: Text(
                          plan.is_recommend == true
                              ? "✅ Recommended"
                              : plan.is_popular == true
                              ? "🔥 Most Popular"
                              : plan.is_best_value == true
                              ? "🏆 Best Value"
                              : "",
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  else
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 35.w,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30.w),
                        ),
                        child: Image.asset(Images.ESimTel_TextLogo, width: 40),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Coverage: ${plan.region?.name}",
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textGreyColor,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.w),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildFeatureIconAndText(
                          imagePath: Images.signalIcon,
                          iconColor: AppColors
                              .primaryColor, // Or use Images.signalIcon
                          value: plan.data,
                        ),
                        if (totalMins != "N/A")
                          _buildFeatureIconAndText(
                            imagePath: Images.CallIcon,
                            iconColor: AppColors.redColor,
                            value: totalMins,
                          ),
                        if (totalSMS != "N/A")
                          _buildFeatureIconAndText(
                            imagePath: Images.messageIcon,
                            iconColor: AppColors.darkgreen,
                            value: totalSMS,
                          ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${plan.day} Day",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textGreyColor,
                        ),
                      ),
                      Text(
                        "$activeCurrency ${plan.netPrice}",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: plan.is_recommend == true
                        ? AppColors.greenColor
                        : plan.is_popular == true
                        ? Colors.orange
                        : plan.is_best_value == true
                        ? Colors.blue
                        : Colors.grey[300]!,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomOutlinedButton(
                      borderRadius: 2.w,
                      padding: EdgeInsets.all(0.w),
                      width: 15.w,
                      height: 6.w,
                      onPressed: onpressed,
                      text: tr('View'),
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            if (regionalListController.selectedindex == index)
              Positioned(
                right: 15,
                top: 10,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 14),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildFeatureIconAndText({
    required String imagePath,
    required Color iconColor,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Image.asset(imagePath, height: 17.sp, color: iconColor),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return SafeArea(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Filter",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 18.sp,
                        color: AppColors.textColor,
                      ),
                    ).tr(),
                    SizedBox(height: 16.0),
                    RadioListTile<FilterType>(
                      title: Text(tr("Price low to high")),
                      value: FilterType.priceLowToHigh,
                      groupValue: reglController.selectedFilter,
                      onChanged: (FilterType? value) {
                        reglController.selectedFilter = value!;
                        reglController.update();
                        _applyFilter(context);
                      },
                    ),
                    RadioListTile<FilterType>(
                      title: Text(tr("Price high to low")),
                      value: FilterType.priceHighToLow,
                      groupValue: reglController.selectedFilter,
                      onChanged: (FilterType? value) {
                        reglController.selectedFilter = value!;
                        reglController.update();
                        _applyFilter(context);
                      },
                    ),
                    RadioListTile<FilterType>(
                      title: Text(tr("Unlimited Plans")),
                      value: FilterType.unlimitedPlans,
                      groupValue: reglController.selectedFilter,
                      onChanged: (FilterType? value) {
                        reglController.selectedFilter = value!;
                        reglController.update();
                        _applyFilter(context);
                      },
                    ),
                    RadioListTile<FilterType>(
                      title: Text(tr("Data Pack")),
                      value: FilterType.dataPack,
                      groupValue: reglController.selectedFilter,
                      onChanged: (FilterType? value) {
                        reglController.selectedFilter = value!;
                        reglController.update();
                        _applyFilter(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _applyFilter(BuildContext context) {
    bool isLowToHigh =
        reglController.selectedFilter == FilterType.priceLowToHigh;
    bool isHighToLow =
        reglController.selectedFilter == FilterType.priceHighToLow;
    bool isUnlimited =
        reglController.selectedFilter == FilterType.unlimitedPlans;
    bool isDataPack = reglController.selectedFilter == FilterType.dataPack;
    reglController.selectedindex = 0;
    reglController.regionDatailsList.clear();
    reglController.update();
    Navigator.of(context).pop();

    context.read<RegionDatailsBloc>().add(
      RegionsDetailsEvent(
        regionId: widget.regionId,
        isUnlimited: isUnlimited,
        dataPack: isDataPack,
        isLowToHigh: isLowToHigh,
        isHighToLow: isHighToLow,
      ),
    );
  }
}
