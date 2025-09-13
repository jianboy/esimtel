import 'package:cached_network_image/cached_network_image.dart';
import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/utills/config.dart';
import 'package:esimtel/utills/global.dart';
import 'package:esimtel/utills/image.dart';
import 'package:flutter/material.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/Model/userProfileModel.dart';
import 'package:sizer/sizer.dart';

class ProfileCardWidget extends StatelessWidget {
  const ProfileCardWidget({super.key, required this.userProfileData});

  final Data? userProfileData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(width: 0.2, color: AppColors.greyColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              userProfileData?.imagePath != null
                  ? CachedNetworkImage(
                      imageUrl: "$imageBaseUrl/${userProfileData?.imagePath}",
                      placeholder: (context, url) => SizedBox(
                        height: 10.w,
                        width: 10.w,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 18.w,
                        width: 18.w,
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryColor),
                        ),
                        child: Image.asset(
                          Images.userProfileIcon,
                          fit: BoxFit.cover,
                          color: AppColors.whiteColor,
                          height: 15.w,
                          width: 15.w,
                        ),
                      ),
                      imageBuilder: (context, imageProvider) => Container(
                        height: 18.w,
                        width: 18.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 18.w,
                      width: 18.w,
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryColor),
                      ),
                      child: Image.asset(
                        Images.userProfileIcon,
                        fit: BoxFit.cover,
                        color: AppColors.primaryColor,
                        height: 15.w,
                        width: 15.w,
                      ),
                    ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    userProfileData?.name != null
                        ? Text(
                            "${userProfileData?.name}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 16.sp,
                                  color: AppColors.textColor,
                                  fontWeight: FontWeight.w500,
                                ),
                          )
                        : SizedBox(),
                    SizedBox(height: 4),
                    userProfileData?.country != null
                        ? Text(
                            "${userProfileData?.country}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 15.sp,
                                  color: AppColors.greyColor,
                                  fontWeight: FontWeight.normal,
                                ),
                          )
                        : SizedBox(),
                    userProfileData?.email != null
                        ? Text(
                            "${userProfileData?.email}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 15.sp,
                                  color: AppColors.greyColor,
                                  fontWeight: FontWeight.normal,
                                ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
          SizedBox(height: 4.w),
          Divider(color: AppColors.dividerColor),
          Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Currency",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 15.sp,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
              Text(
                userProfileData?.currency?.name ?? "",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 16.sp,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          userProfileData?.kycstatus != null && userProfileData?.kycstatus != ""
              ? Row(
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "KYC Status",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 15.sp,
                              color: AppColors.textColor,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                    Text(
                      userProfileData?.kycstatus
                              .toString()
                              .capitalizeFirstLetter() ??
                          "",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 15.sp,
                            color: userProfileData?.kycstatus == "approved"
                                ? AppColors.greenColor
                                : userProfileData?.kycstatus == "rejected"
                                    ? AppColors.redColor
                                    : userProfileData?.kycstatus == "pending"
                                        ? AppColors.darkYellow
                                        : AppColors.textGreyColor,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    SizedBox(width: 2),
                    userProfileData?.kycstatus == "approved"
                        ? Image.asset(Images.kycapproved, height: 18)
                        : userProfileData?.kycstatus == "rejected"
                            ? Image.asset(Images.kycrejected, height: 18)
                            : userProfileData?.kycstatus == "pending"
                                ? Image.asset(Images.kycpending, height: 16)
                                : SizedBox(),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
