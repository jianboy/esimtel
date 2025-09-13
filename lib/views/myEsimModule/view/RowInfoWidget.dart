import 'package:esimtel/utills/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool enableCopy;
  final int? flex;

  const InfoRow({
    Key? key,
    required this.label,
    required this.value,
    this.enableCopy = false,
    this.flex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: flex ?? 3,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 1.w, horizontal: 12),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: AppColors.dividerColor, width: 0.8),
                  bottom: BorderSide(color: AppColors.dividerColor, width: 0.5),
                ),
              ),
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
            ),
          ),

          // Value Section
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.dividerColor, width: 0.8),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16.sp,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  if (enableCopy)
                    IconButton(
                      icon: const Icon(Icons.copy, size: 18),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: value));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Copied to clipboard")),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
