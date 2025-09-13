import 'package:cached_network_image/cached_network_image.dart';
import 'package:esimtel/utills/global.dart';
import 'package:esimtel/utills/global.dart' as global;
import 'package:esimtel/utills/image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/utills/services/ApiService.dart';
import 'package:esimtel/views/packageModule/packagesList/bloc/package_detail_bloc/package_datail_event.dart';
import 'package:esimtel/views/packageModule/packagesList/bloc/package_detail_bloc/package_details_bloc.dart';
import 'package:esimtel/views/packageModule/packagesList/model/packageDetailsModel.dart';
import 'package:esimtel/widgets/CustomElevatedButton.dart';
import 'package:esimtel/widgets/loadingSkeletion.dart';
import 'checkoutscreen.dart';

class PackageDetailsScreen extends StatelessWidget {
  final String packageId;
  const PackageDetailsScreen({super.key, required this.packageId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: BlocProvider<PackageDetailsBloc>(
        create: (context) =>
            PackageDetailsBloc(ApiService())
              ..add(PackageDetailsEvent(packageId: packageId)),
        child: Scaffold(
          backgroundColor: AppColors.scaffoldbackgroudColor,
          body: BlocBuilder<PackageDetailsBloc, ApiState<PackageDetailsModel>>(
            builder: (context, state) {
              if (state is ApiLoading) {
                return Center(
                  child: Skeletonizer(
                    enabled: state is ApiLoading,
                    child: ScrollViewSkeletion(),
                  ),
                );
              } else if (state is ApiFailure) {
                return Center(child: Text("Error: ${state.error}"));
              } else if (state is ApiSuccess<PackageDetailsModel>) {
                final packageDatailsList = state.data?.data;
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: AppColors.primaryColor,
                      pinned: true,
                      expandedHeight: 230,
                      title: const Text('Additional Details').tr(),
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
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          20.0,
                          16.0,
                          8.0,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldbackgroudColor,
                        ),
                        child: Text(
                          'Plan details',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor,
                              ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        _buildDataPlanCard(
                          context,
                          title: packageDatailsList?.country?.name ?? "Global",
                          imagePath: '${packageDatailsList?.country?.image}',
                          coverage: '${packageDatailsList?.country?.name}',
                          data: '${packageDatailsList?.data}',
                          SMS:
                              ((packageDatailsList?.name ?? "")
                                      .toString()
                                      .split(" - "))
                                  .firstWhere(
                                    (part) => part.contains("SMS"),
                                    orElse: () => "N/A",
                                  ),
                          call:
                              ((packageDatailsList?.name ?? "")
                                      .toString()
                                      .split(" - "))
                                  .firstWhere(
                                    (part) => part.contains("Mins"),
                                    orElse: () => "N/A",
                                  ),
                          validity: '${packageDatailsList?.day} Days',
                          price:
                              '$activeCurrency ${global.formatPrice(double.parse(packageDatailsList!.netPrice.toString()))}',
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Additional information',
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textColor,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Column(
                                  children: [
                                    _buildAdditionalInfoRow(
                                      context,
                                      icon: Icons.wifi,
                                      label: 'OPERATOR',
                                      imagePath: packageDatailsList
                                          .dataOperator
                                          ?.image,
                                      value:
                                          '${packageDatailsList.dataOperator?.name}',
                                    ),
                                    packageDatailsList.fairUsagePolicy != null
                                        ? Divider(color: AppColors.dividerColor)
                                        : SizedBox.shrink(),
                                    packageDatailsList.fairUsagePolicy != null
                                        ? _buildAdditionalInfoRow(
                                            context,
                                            icon: Icons.policy_outlined,
                                            label: 'USAGE POLICY',
                                            value:
                                                '${packageDatailsList.fairUsagePolicy}',
                                          )
                                        : SizedBox.shrink(),
                                    Divider(color: AppColors.dividerColor),
                                    _buildAdditionalInfoRow(
                                      context,
                                      icon: Icons.policy_outlined,
                                      label: 'ACTIVATION POLICY',
                                      value:
                                          '${packageDatailsList.dataOperator?.activationPolicy}',
                                    ),
                                    Divider(color: AppColors.dividerColor),
                                    _buildAdditionalInfoRow(
                                      context,
                                      icon: Icons.lock,
                                      label: 'KYC STATUS',
                                      value:
                                          packageDatailsList
                                                  .dataOperator
                                                  ?.isKycVerify ==
                                              0
                                          ? "Not Required"
                                          : "Not Required",
                                    ),
                                    Divider(color: AppColors.dividerColor),
                                    _buildAdditionalInfoRow(
                                      context,
                                      icon: Icons.sim_card_outlined,
                                      label: 'ESim TYPE',
                                      value:
                                          " ${packageDatailsList.dataOperator?.esimType}",
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 17.h),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          bottomSheet: _buildBottomBar(context),
        ),
      ),
    );
  }

  Widget _buildDataPlanCard(
    BuildContext context, {
    required String title,
    required String coverage,
    required String data,
    required String call,
    required String SMS,
    required String imagePath,
    required String validity,
    required String price,
  }) {
    return Container(
      color: AppColors.scaffoldbackgroudColor,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
                CachedNetworkImage(
                  imageUrl: imagePath,
                  placeholder: (context, url) => const SizedBox(
                    width: 27,
                    height: 27,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (context, url, error) =>
                      Image.asset(Images.earthImage, width: 27, height: 27),
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
            SizedBox(height: 2),
            Divider(color: AppColors.dividerColor),
            const SizedBox(height: 5),
            coverage != null && coverage != 'null'
                ? _buildInfoRow(Icons.public, 'Coverage', coverage, context)
                : SizedBox.shrink(),
            const SizedBox(height: 5),
            Divider(color: AppColors.dividerColor),
            _buildInfoRow(Icons.swap_vert, 'Data', data, context),
            const SizedBox(height: 5),
            Divider(color: AppColors.dividerColor),
            _buildInfoRow(Icons.call, 'Call', call, context),
            const SizedBox(height: 5),
            Divider(color: AppColors.dividerColor),
            _buildInfoRow(Icons.sms, 'SMS', SMS, context),
            const SizedBox(height: 5),
            Divider(color: AppColors.dividerColor),
            _buildInfoRow(Icons.calendar_today, 'Validity', validity, context),
            const SizedBox(height: 5),
            Divider(color: AppColors.dividerColor),
            _buildInfoRow(Icons.sell_outlined, 'Price', price, context),
          ],
        ),
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
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 16.sp,
            color: AppColors.textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoRow(
    BuildContext context, {
    required IconData icon,
    String? imagePath = "",
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.greyColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        imagePath != ""
            ? CachedNetworkImage(
                imageUrl: "$imagePath",
                placeholder: (context, url) => const SizedBox(
                  width: 27,
                  height: 27,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) =>
                    Image.asset(Images.earthImage, width: 27, height: 27),
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
              )
            : SizedBox(),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return BlocBuilder<PackageDetailsBloc, ApiState<PackageDetailsModel>>(
      builder: (context, state) {
        if (state is ApiSuccess<PackageDetailsModel>) {
          final packageDatailsList = state.data?.data;
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
                    '$activeCurrency ${packageDatailsList?.netPrice}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  CustomElevatedButton(
                    onPressed: () {
                      Get.to(
                        () =>
                            Checkoutscreen(packageListInfo: packageDatailsList),
                      );
                    },
                    text: tr('Buy Now'),
                  ),
                ],
              ),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
