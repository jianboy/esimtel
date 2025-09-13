import 'package:cached_network_image/cached_network_image.dart';
import 'package:esimtel/utills/global.dart';
import 'package:esimtel/utills/image.dart';
import 'package:esimtel/views/packageModule/regionsList/model/regionDetailsModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/widgets/CustomElevatedButton.dart';
import '../../../../utills/global.dart' as global;
import '../../packagesList/view/checkoutscreen.dart';

class RegionDetailScreen extends StatelessWidget {
  final dynamic regionDatailsList;
  const RegionDetailScreen({super.key, required this.regionDatailsList});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldbackgroudColor,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: AppColors.primaryColor,
              pinned: true,
              expandedHeight: 250.0,
              title: Text("Regional Plan Details"),
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
                        imageUrl: regionDatailsList.region?.image ?? "",
                        placeholder: (context, url) => SizedBox(
                          width: 15.w,
                          height: 15.w,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          Images.earthImage,
                          width: 15.w,
                          height: 15.w,
                        ),
                        imageBuilder: (context, imageProvider) => Container(
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
                        "${regionDatailsList.region?.name}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      regionDatailsList.region?.countries?.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                coutriesSheetForRegion(
                                  context,
                                  regionDatailsList,
                                );
                              },
                              child: Container(
                                width: 65.w,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: AppColors.blackColor,
                                  borderRadius: BorderRadius.circular(10.w),
                                  border: Border.all(
                                    color: AppColors.whiteColor,
                                    width: 0.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 2.w),
                                    Icon(
                                      Icons.language,
                                      color: AppColors.whiteColor,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      "${regionDatailsList.region?.countries?.length} Countries Included",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w300,
                                            color: AppColors.whiteColor,
                                          ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Icon(
                                      Icons.arrow_drop_down_outlined,
                                      color: AppColors.whiteColor,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 5.w),
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
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 2.w),
                    ],
                  ),
                ),
                _buildDataPlanCard(
                  context,
                  totalmin:
                      ((regionDatailsList.name ?? "").split(" - ")
                              as List<String>)
                          .firstWhere(
                            (part) => part.contains("Mins"),
                            orElse: () => "N/A",
                          ),
                  totalSMS:
                      ((regionDatailsList.name ?? "").split(" - ")
                              as List<String>)
                          .firstWhere(
                            (part) => part.contains("SMS"),
                            orElse: () => "N/A",
                          ),
                  title: regionDatailsList.name.toString(),
                  data: regionDatailsList.data.toString(),
                  validity: "${regionDatailsList.day.toString()} Days",
                  price:
                      "$activeCurrency ${global.formatPrice(double.parse(regionDatailsList.netPrice.toString()))}",
                ),
                SizedBox(height: 10.h),
              ]),
            ),
          ],
        ),

        bottomSheet: _buildBottomBar(context),
      ),
    );
  }

  Future<dynamic> coutriesSheetForRegion(
    BuildContext context,
    Datum? regionDatailsList,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // so it can expand more
      backgroundColor: Colors.transparent, // for rounded edges
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.85,
          expand: false, // important for inside bottom sheet
          builder: (context, scrollController) {
            final countriesList = regionDatailsList?.region?.countries;
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.w),
                controller: scrollController,
                itemCount: countriesList?.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 2.w),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: countriesList![index].image.toString(),
                          placeholder: (context, url) => SizedBox(
                            width: 12.w,
                            height: 12.w,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            Images.earthImage,
                            width: 12.w,
                            height: 12.w,
                          ),
                          imageBuilder: (context, imageProvider) => Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Text(countriesList[index].name.toString()),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  // Widget for the main plan details card.
  Widget _buildDataPlanCard(
    BuildContext context, {
    required String totalmin,
    required String totalSMS,
    required String title,
    required String data,
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
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2),
            Divider(color: AppColors.dividerColor),
            const SizedBox(height: 5),
            _buildInfoRow(Icons.swap_vert, 'Data', data, context),
            const SizedBox(height: 5),
            Divider(color: AppColors.dividerColor),
            _buildInfoRow(Icons.call, 'Total MIN', totalmin, context),
            const SizedBox(height: 5),
            Divider(color: AppColors.dividerColor),
            _buildInfoRow(Icons.sms_outlined, 'Total SMS', totalSMS, context),
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

  // Helper for a single row in the plan details card.
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

  // Helper for a single row in the "Additional Information" card.
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
              '$activeCurrency ${regionDatailsList.netPrice.toString()}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
              ),
            ),
            CustomElevatedButton(
              onPressed: () {
                Get.to(
                  () => Checkoutscreen(packageListInfo: regionDatailsList),
                );
              },
              text: tr('Buy Now'),
            ),
          ],
        ),
      ),
    );
  }
}
