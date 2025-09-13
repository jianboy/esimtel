import 'package:cached_network_image/cached_network_image.dart';
import 'package:esimtel/utills/global.dart';
import 'package:esimtel/utills/image.dart';
import 'package:esimtel/widgets/custiomOutlinedButton.dart';
import 'package:esimtel/widgets/CustomElevatedButton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/views/packageModule/packagesList/bloc/package_List_bloc/packageList_bloc.dart';
import 'package:esimtel/views/packageModule/packagesList/bloc/package_List_bloc/packageList_event.dart';
import 'package:esimtel/views/packageModule/packagesList/model/packageListModel.dart';
import 'package:esimtel/views/packageModule/packagesList/view/checkoutscreen.dart';
import 'package:esimtel/views/packageModule/packagesList/view/packageDetailsScreen.dart';
import 'package:esimtel/widgets/loadingSkeletion.dart';
import '../../../../utills/failurewidget.dart';
import '../../../homeModule/kycFormModule/view/KycFormScreen.dart';
import '../../../profileMoulde/userProfileModule/profile_bloc/userprofile_bloc.dart';
import '../../../profileMoulde/userProfileModule/profile_bloc/userprofile_event.dart';
import '../../regionsList/controller/regionalcontroller.dart';
import '../controller/packagelistcontorller.dart';
import 'package:esimtel/utills/global.dart' as global;

class PackageListScreen extends StatefulWidget {
  final String id;
  const PackageListScreen({super.key, required this.id});
  @override
  State<PackageListScreen> createState() => _PackageListScreenState();
}

class _PackageListScreenState extends State<PackageListScreen> {
  int? selectedLoadingIndex;
  final packagelistcontroller = Get.find<PackageListController>();
  bool showLoadMoreHint = false;
  FilterType selectedFilter = FilterType.none;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PackagelistBloc>().add(
        PackagelistEvent(countrycode: widget.id),
      );
      context.read<UserProfileBloc>().add(UserProfileEvent());
      packagelistcontroller.scrollController.addListener(_pagination);
      packagelistcontroller.selectedindex = 0;
      packagelistcontroller.update();
    });
  }

  @override
  void dispose() {
    packagelistcontroller.scrollController.removeListener(_pagination);
    super.dispose();
  }

  void _pagination() {
    final position = packagelistcontroller.scrollController.position;
    if (position.pixels < position.maxScrollExtent - 200) {
      if (!showLoadMoreHint) {
        setState(() => showLoadMoreHint = true);
      }
    } else {
      if (showLoadMoreHint) {
        setState(() => showLoadMoreHint = false);
      }
    }
    if (position.pixels >= position.maxScrollExtent &&
        packagelistcontroller.nextPageUrl != null &&
        !packagelistcontroller.isLoadingMore) {
      if (mounted) {
        final bool isUnlimited = selectedFilter == FilterType.unlimitedPlans;
        final bool isDataPack = selectedFilter == FilterType.dataPack;
        final bool isLowToHigh = selectedFilter == FilterType.priceLowToHigh;
        final bool isHighToLow = selectedFilter == FilterType.priceHighToLow;
        context.read<PackagelistBloc>().add(
          PackagelistEvent(
            countrycode: widget.id,
            url: packagelistcontroller.nextPageUrl!,
            isUnlimited: isUnlimited,
            dataPack: isDataPack,
            isLowToHigh: isLowToHigh,
            isHighToLow: isHighToLow,
          ),
        );
        packagelistcontroller.selectedindex = 0;
        packagelistcontroller.update();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: BlocListener<UserProfileBloc, ApiState>(
        listener: (context, state) {
          if (state is ApiSuccess) {
            // String kycStatus = state.data?.data?.kycstatus ?? 'Not applied';
            global.paymentMode = state.data?.data?.payment_mode ?? '';
            global.UserkycStatus = state.data?.data?.kycstatus ?? '';
          }
        },
        child: Scaffold(
          floatingActionButton: showLoadMoreHint
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
                      packagelistcontroller.scrollController.animateTo(
                        packagelistcontroller.scrollController.offset + 200,
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
          body: GetBuilder<PackageListController>(
            builder: (packagelistcontroller) =>
                BlocConsumer<PackagelistBloc, ApiState<PackagesListModel>>(
                  listener: (context, state) {
                    if (state is ApiLoading) {
                      packagelistcontroller.isLoadingMore = true;
                      packagelistcontroller.update();
                    } else if (state is ApiSuccess) {
                      // Logic for adding new data to the list
                      if (state.data?.links?.prev == null) {
                        packagelistcontroller.packageListdata =
                            state.data?.data ?? [];
                      } else {
                        packagelistcontroller.packageListdata.addAll(
                          state.data?.data ?? [],
                        );
                      }
                      packagelistcontroller.nextPageUrl =
                          state.data?.links?.next;
                      packagelistcontroller.isLoadingMore = false;
                      packagelistcontroller.update();
                    } else if (state is ApiFailure) {
                      packagelistcontroller.isLoadingMore = false;
                      packagelistcontroller.update();
                    }
                  },
                  builder: (context, state) {
                    final packageList = packagelistcontroller.packageListdata;
                    final isLoadingInitial =
                        state is ApiLoading && packageList.isEmpty;
                    final isInitialError =
                        state is ApiFailure && packageList.isEmpty;

                    if (isLoadingInitial) {
                      return Center(
                        child: Skeletonizer(
                          enabled: true,
                          child: ScrollViewSkeletion(),
                        ),
                      );
                    }

                    if (isInitialError) {
                      return ApiFailureWidget(
                        error: state.error,
                        onRetry: () {
                          context.read<PackagelistBloc>().add(
                            PackagelistEvent(countrycode: widget.id),
                          );
                        },
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<PackagelistBloc>().add(
                          PackagelistEvent(countrycode: widget.id),
                        );
                      },
                      child: CustomScrollView(
                        controller: packagelistcontroller.scrollController,
                        slivers: [
                          SliverAppBar(
                            backgroundColor: AppColors.primaryColor,
                            pinned: true,
                            expandedHeight: 230,
                            title: const Text('Choose Data Plans').tr(),
                            flexibleSpace: FlexibleSpaceBar(
                              background: Container(
                                alignment: Alignment.bottomCenter,
                                color: AppColors.blackColor,
                                child: Image.asset(
                                  Images.silverAppBarImage,
                                  fit: BoxFit.cover,
                                  height: 20.h,
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              color: AppColors.scaffoldbackgroudColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 15.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Choose data plan',
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
                                      _showFilterOptions();
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
                          if (packageList.isEmpty)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Center(
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
                            )
                          else
                            SliverGrid(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                return GestureDetector(
                                  onTap: () {
                                    packagelistcontroller.selectedindex = index;
                                    packagelistcontroller.packageListdata =
                                        packageList;
                                    packagelistcontroller.update();
                                  },
                                  child: _buildDataPlanCard(
                                    context,
                                    index: index,
                                    packageListdata: packageList,
                                    name: "${packageList[index].name}",
                                    imagePath:
                                        '${packageList[index].country?.image}',
                                    title:
                                        '${packageList[index].country?.name}',
                                    coverage:
                                        '${packageList[index].country?.name}',
                                    data: '${packageList[index].data}',
                                    validity: '${packageList[index].day} Day',
                                    price: '${packageList[index].netPrice}',
                                    pckgid: '${packageList[index].id}',
                                    isSelected: index == 3 ? true : false,
                                    selectdindex: index,
                                    onpressed: () {
                                      Get.to(
                                        () => PackageDetailsScreen(
                                          packageId: "${packageList[index].id}",
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }, childCount: packageList.length),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 0,
                                    childAspectRatio: 0.8,
                                  ),
                            ),
                          if (packagelistcontroller.isLoadingMore)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                ),
                                child: Center(
                                  child: global.showPaginationLoader(context),
                                ),
                              ),
                            ),
                          SliverToBoxAdapter(
                            child: Column(children: [SizedBox(height: 12.h)]),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          ),
          bottomSheet: _buildBottomBar(context),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return GetBuilder<PackageListController>(
      builder: (packagelistcontroller) {
        if (packagelistcontroller.packageListdata.isEmpty) {
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
                  '$activeCurrency ${packagelistcontroller.packageListdata[packagelistcontroller.selectedindex].netPrice}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteColor,
                  ),
                ),
                CustomElevatedButton(
                  onPressed: () {
                    dynamic mins =
                        ((packagelistcontroller
                                            .packageListdata[packagelistcontroller
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
                        ((packagelistcontroller
                                            .packageListdata[packagelistcontroller
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
                              📦 Normal Buying Info:
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
                            packagelistcontroller
                                .packageListdata[packagelistcontroller
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
    required dynamic title,
    required String name,
    required List<PackageList>? packageListdata,
    required int index,
    required dynamic coverage,
    required dynamic data,
    required dynamic validity,
    required dynamic price,
    required dynamic imagePath,
    required dynamic pckgid,
    required VoidCallback onpressed,
    bool isSelected = false,
    required int selectdindex,
  }) {
    return GetBuilder<PackageListController>(
      builder: (packagelistcontroller) {
        // Check if any of the special flags are true
        bool showSpecialLabel =
            packageListdata?[index].is_recommend == true ||
            packageListdata?[index].is_popular == true ||
            packageListdata?[index].is_best_value == true;

        final List<String> nameParts = (name).split(" - ");
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
                color: packageListdata?[index].is_recommend == true
                    ? AppColors.greenColor.withOpacity(0.1)
                    : packageListdata?[index].is_popular == true
                    ? Colors.orange.withOpacity(0.1)
                    : packageListdata?[index].is_best_value == true
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: packagelistcontroller.selectedindex == index
                      ? AppColors.primaryColor
                      : packageListdata?[index].is_recommend == true
                      ? AppColors.greenColor
                      : packageListdata?[index].is_popular == true
                      ? Colors.orange
                      : packageListdata?[index].is_best_value == true
                      ? Colors.blue
                      : Colors.grey[300]!,
                  width: packagelistcontroller.selectedindex == index
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
                  (showSpecialLabel)
                      ? Align(
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
                              color:
                                  packageListdata?[index].is_recommend == true
                                  ? AppColors.greenColor
                                  : packageListdata?[index].is_popular == true
                                  ? Colors.orange
                                  : packageListdata?[index].is_best_value ==
                                        true
                                  ? Colors.blue
                                  : Colors.grey[300]!,
                              borderRadius: BorderRadius.circular(30.w),
                            ),
                            child: Text(
                              packageListdata?[index].is_recommend == true
                                  ? "✅ Recomonded"
                                  : packageListdata?[index].is_popular == true
                                  ? "🔥 Most Popuper"
                                  : packageListdata?[index].is_best_value ==
                                        true
                                  ? "🏆 Best Value"
                                  : "",
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.whiteColor,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      : Align(
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
                            child: Image.asset(
                              Images.ESimTel_TextLogo,
                              width: 40,
                            ),
                          ),
                        ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "coverage",
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textGreyColor,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ).tr(args: ['$title']),
                      ),
                      const SizedBox(width: 5),
                      CachedNetworkImage(
                        imageUrl: imagePath,
                        placeholder: (context, url) => const SizedBox(
                          width: 27,
                          height: 27,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          Images.earthImage,
                          width: 27,
                          height: 27,
                        ),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 27,
                          height: 27,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.w),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildFeatureIconAndText(
                          imagePath: Images.signalIcon,
                          iconColor: AppColors.primaryColor,
                          value: data,
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

                  const SizedBox(height: 5),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        validity,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textGreyColor,
                        ),
                      ),
                      Text(
                        "$activeCurrency $price",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: packageListdata?[index].is_recommend == true
                        ? AppColors.greenColor
                        : packageListdata?[index].is_popular == true
                        ? Colors.orange
                        : packageListdata?[index].is_best_value == true
                        ? Colors.blue
                        : Colors.grey[300]!,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
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
            packagelistcontroller.selectedindex == index
                ? Positioned(
                    right: 15,
                    top: 10,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
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

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    BuildContext context,
  ) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 16),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 16.sp,
            color: AppColors.greyColor,
          ),
        ).tr(),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 16.sp,
            color: AppColors.textColor,
            fontWeight: FontWeight.w500,
          ),
        ).tr(),
      ],
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
                      groupValue: selectedFilter,
                      onChanged: (FilterType? value) {
                        modalSetState(() {
                          selectedFilter = value!;
                        });
                        _applyFilter(context);
                      },
                    ),
                    RadioListTile<FilterType>(
                      title: Text(tr("Price high to low")),
                      value: FilterType.priceHighToLow,
                      groupValue: selectedFilter,
                      onChanged: (FilterType? value) {
                        modalSetState(() {
                          selectedFilter = value!;
                        });
                        _applyFilter(context);
                      },
                    ),
                    RadioListTile<FilterType>(
                      title: Text(tr("Unlimited Plans")),
                      value: FilterType.unlimitedPlans,
                      groupValue: selectedFilter,
                      onChanged: (FilterType? value) {
                        modalSetState(() {
                          selectedFilter = value!;
                        });
                        _applyFilter(context);
                      },
                    ),
                    RadioListTile<FilterType>(
                      title: Text(tr("Data Pack")),
                      value: FilterType.dataPack,
                      groupValue: selectedFilter,
                      onChanged: (FilterType? value) {
                        modalSetState(() {
                          selectedFilter = value!;
                        });
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
    bool isLowToHigh = selectedFilter == FilterType.priceLowToHigh;
    bool isHighToLow = selectedFilter == FilterType.priceHighToLow;
    bool isUnlimited = selectedFilter == FilterType.unlimitedPlans;
    bool isDataPack = selectedFilter == FilterType.dataPack;

    Navigator.of(context).pop();

    packagelistcontroller.selectedindex = 0;
    packagelistcontroller.update();

    // Dispatch the event to the bloc
    context.read<PackagelistBloc>().add(
      PackagelistEvent(
        countrycode: widget.id,
        isUnlimited: isUnlimited,
        dataPack: isDataPack,
        isLowToHigh: isLowToHigh,
        isHighToLow: isHighToLow,
      ),
    );
  }
}
