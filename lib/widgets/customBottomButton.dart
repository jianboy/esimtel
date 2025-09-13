import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CustomBottomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final double? height;
  final double? fontSize;

  final bool isLoading;

  const CustomBottomButton({
    Key? key,
    required this.title,
    this.fontSize,
    this.height,
    required this.onTap,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: height ?? 40,
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.circular(2.w),
        ),
        alignment: Alignment.center,
        width: double.infinity,
        child: isLoading
            ? SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                title,
                style: Get.theme.textTheme.titleMedium!.copyWith(
                  fontSize: fontSize ?? 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
