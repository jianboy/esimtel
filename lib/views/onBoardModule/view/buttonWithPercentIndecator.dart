// ignore_for_file: must_be_immutable

import 'package:esimtel/utills/appColors.dart';
import 'package:flutter/material.dart';

class ButtonWithLinearPercentIndicator extends StatelessWidget {
  final VoidCallback onTap;
  final double percent;
  final Widget child;
  final double height;
  final double width;
  final Duration animationDuration;

  const ButtonWithLinearPercentIndicator({
    super.key,
    required this.onTap,
    required this.percent,
    required this.child,
    this.height = 43,
    this.width = double.infinity,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Smooth progress background
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: const Color(0xffFFF1B1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: percent),
                duration: animationDuration,
                builder: (context, value, _) {
                  return LinearProgressIndicator(
                    value: value,
                    backgroundColor: AppColors.primaryColor.withOpacity(0.7),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryColor,
                    ),
                  );
                },
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
