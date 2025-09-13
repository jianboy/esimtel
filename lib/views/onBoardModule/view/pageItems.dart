// ignore_for_file: must_be_immutable
import 'package:esimtel/utills/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PageItem extends StatelessWidget {
  String imagePath;
  String head;
  double? imageheight;
  String intro;
  PageItem({
    super.key,
    this.imageheight,
    required this.head,
    required this.intro,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Center(child: Image.asset(imagePath, height: imageheight)),
          SizedBox(height: 5.h),
          Text(
            head,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor, // Different color for app name
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5.h),
          Text(
            intro,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor, // Different color for app name
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }
}
