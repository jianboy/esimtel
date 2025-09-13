import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/utills/image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController subTitleController;
  final bool istitleRequired;
  final VoidCallback onSend;
  final bool canSend;

  const MessageInput({
    super.key,
    required this.titleController,
    required this.subTitleController,
    required this.onSend,
    required this.istitleRequired,
    required this.canSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: istitleRequired ? 12.h : 7.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            istitleRequired
                ? Expanded(
                    child: SizedBox(
                      width: 80.w,
                      child: TextField(
                        controller: titleController,
                        enabled: canSend,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(2.w),
                          isDense: true,
                          hintStyle: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.greyColor,
                              ),
                          hintText: 'Title',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.dividerColor,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(30.w),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.dividerColor,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(30.w),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.dividerColor,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(30.w),
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: subTitleController,
                    enabled: canSend,
                    decoration: InputDecoration(
                      isDense: true,
                      hintStyle: Theme.of(context).textTheme.bodyMedium!
                          .copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.greyColor,
                          ),
                      hintText: canSend
                          ? 'Type your message...'
                          : 'Please wait for response...',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.dividerColor,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(30.w),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.dividerColor,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(30.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.dividerColor,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(30.w),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(1.w),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.textColor,
                  ),
                  child: InkWell(
                    onTap: canSend ? onSend : null,
                    child: Image.asset(
                      Images.sendMessage,
                      height: 20.sp,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
