
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/utills/image.dart';
import 'package:esimtel/views/homeModule/getUsageModule/model/dataUsage_Model.dart';
import 'package:esimtel/widgets/custiomOutlinedButton.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esimtel/views/homeModule/getUsageModule/views/stateWidget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PackageDetailCard extends StatelessWidget {
  Usage data_usage;
  Location? location;
  final bool? isloadingState;
  final VoidCallback onCardTap;
  final String? esimStatus;

  PackageDetailCard({
    super.key,
    this.esimStatus,
    this.location,
    required this.data_usage,
    this.isloadingState = false,
    required this.onCardTap,
  });

  double _getRemainingPercentage(double totalMB, double remainingMB) {
    if (totalMB == 0) return 0; // Avoid division by zero
    double percentage = (remainingMB / totalMB) * 100;
    return double.parse(percentage.toStringAsFixed(0)) / 100;
  }

  @override
  Widget build(BuildContext context) {
    final internetPercent = _getRemainingPercentage(
      data_usage.total?.toDouble() ?? 0,
      data_usage.remaining?.toDouble() ?? 0,
    );
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(2.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 2,
            blurStyle: BlurStyle.outer,
          ),
        ],
        gradient: const LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFFFF3E0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Package detail",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
              ).tr(),
              Spacer(),
              esimStatus == "NOT_ACTIVE"
                  ? StatusTag(status: esimStatus!)
                  : CustomOutlinedButton(
                      padding: EdgeInsets.all(0.w),
                      width: 20.w,
                      height: 8.w,
                      onPressed: onCardTap,
                      text: "Top Up",
                      fontSize: 15.sp,
                      borderRadius: 2.w,
                    ),
              isloadingState == true
                  ? SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                "${location?.name}",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                ),
              ),
              const Spacer(),
              CachedNetworkImage(
                imageUrl: "${location?.image}",
                placeholder: (context, url) => SizedBox(
                  width: 6.w,
                  height: 6.w,
                  child: Skeletonizer(
                    enabled: true,
                    child: Container(
                      width: 6.w,
                      height: 6.w,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    Image.asset(Images.earthImage, width: 6.w, height: 6.w),
                imageBuilder: (context, imageProvider) => Container(
                  width: 6.w,
                  height: 6.w,
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
          const SizedBox(height: 8),
          Row(
            children: [
              Image.asset(Images.signalIcon, height: 5.w),
              const SizedBox(width: 6),
              Text(
                "Internet",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontSize: 16),
              ).tr(),
              const Spacer(),
              Text(
                "${((data_usage.total?.toDouble() ?? 0) / 1024).toStringAsFixed(1)} GB",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearPercentIndicator(
            lineHeight: 5.0,
            percent: internetPercent,
            progressColor: internetPercent <= .30 ? Colors.red : Colors.green,
            backgroundColor: Colors.grey[300],
            barRadius: const Radius.circular(10),
          ),
          const SizedBox(height: 8),
          Text(
            "Expired at ${DateFormat('MMM dd, yyyy HH:mm a').format(DateTime.tryParse(data_usage.expiredAt ?? '') ?? DateTime.now())}",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.grey,
              fontSize: 15.sp,
              fontWeight: FontWeight.w300,
            ),
          ).tr(),
          const SizedBox(height: 6),
          Divider(color: Colors.grey.shade300),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatWidget(
                icon: Images.messageIcon,
                label: data_usage.totalText?.toInt() == 0
                    ? tr("SMS Not\nAvailable")
                    : "${data_usage.remainingText?.toDouble().toInt()} ${tr("SMS\nLeft")}",
                percent: _getRemainingPercentage(
                  data_usage.totalText?.toDouble() ?? 0,
                  data_usage.remainingText?.toDouble() ?? 0,
                ),
              ),
              Container(height: 6.h, width: 1, color: Colors.grey.shade300),
              StatWidget(
                icon: Images.CallIcon,
                label: data_usage.totalVoice?.toDouble().toInt() == 0
                    ? tr("Call Not\nAvailable")
                    : "${data_usage.remainingVoice?.toInt()} ${tr("Min\nCalls Left")}",
                percent: _getRemainingPercentage(
                  data_usage.totalVoice?.toDouble() ?? 0,
                  data_usage.remainingVoice?.toDouble() ?? 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

class StatusTag extends StatelessWidget {
  final String status;

  const StatusTag({Key? key, required this.status}) : super(key: key);

  Color _getBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF28A745); // A deep, professional green
      case 'pending':
        return const Color(0xFFFFC107); // A warm, professional orange
      case 'inactive':
        return const Color(0xFF6C757D); // A clean, neutral gray
      default:
        return const Color(0xFFDC3545); // A bold, error red
    }
  }

  Color _getForegroundColor(String status) {
    // Use white text for all dark backgrounds for maximum legibility.
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor(status);
    final foregroundColor = _getForegroundColor(status);

    return Container(
      // The padding is slightly larger for a more spacious feel.
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100.0), // Fully rounded corners
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2), // Gives a subtle lift
          ),
        ],
      ),
      child: Text(
        status.replaceAll('_', ' ').capitalizeFirstLetter(),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 12.sp, // Slightly larger font for better readability
          fontWeight: FontWeight.w700,
          color: foregroundColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
