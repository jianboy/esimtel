import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:esimtel/utills/appcolors.dart';

class BottomContainer extends StatelessWidget {
  final String imagepath;
  final String label;
  const BottomContainer({
    super.key,
    required this.imagepath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              border: Border.all(width: 0.5, color: AppColors.dividerColor),
              shape: BoxShape.circle,
            ),
            child: Image.asset(imagepath, height: 24.sp),
          ),
          SizedBox(height: 2.w),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 15.sp,
              color: Colors.black45,
            ),
            maxLines: 2,
          ).tr(),
        ],
      ),
    );
  }
}
