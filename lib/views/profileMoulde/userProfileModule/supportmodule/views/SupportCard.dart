import 'package:esimtel/widgets/CustomElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SupportCard extends StatelessWidget {
  final VoidCallback onContactSupport;

  const SupportCard({super.key, required this.onContactSupport});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.w),
        gradient: const LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFFFF3E0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Still having an issue?',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Our customer support team is ready to help you with any issue you may have.',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: CustomElevatedButton(
              onPressed: onContactSupport,
              text: "Connect to Support",
            ),
          ),
        ],
      ),
    );
  }
}
