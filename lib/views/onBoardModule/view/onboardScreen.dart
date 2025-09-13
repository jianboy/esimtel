import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/utills/image.dart';
import 'package:esimtel/views/authModule/view/loginScreen.dart';
import 'package:esimtel/views/onBoardModule/controller/onboardController.dart';
import 'package:esimtel/views/onBoardModule/view/buttonWithPercentIndecator.dart';
import 'package:esimtel/views/onBoardModule/view/pageItems.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({super.key});
  final onboardcontroller = Get.find<OnBoardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldbackgroudColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F2F7), Color(0xFFF0F4F7), Color(0xFFFFFFFF)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: GetBuilder<OnBoardController>(
          builder: (onboardcontroller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 4.h),
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: onboardcontroller.pagecontroller,
                      children: [
                        PageItem(
                          imagePath: Images.connectAnyWhare,
                          head: "Connect Anywhere",
                          intro:
                              "Stay connected in over 200+ countries with instant eSIM activation, no physical SIM needed.",
                        ),
                        PageItem(
                          imagePath: Images.activeInMinutes,
                          head: "Activate in Minutes",
                          intro:
                              "Buy and install your eSIM directly from the app — travel ready in just a few taps.",
                        ),
                        PageItem(
                          imageheight: 40.h,
                          imagePath: Images.manageyourPlans,
                          head: "Almost Done...!\nManage Your Plans",
                          intro:
                              "Track data usage, recharge instantly, and switch between plans anytime, anywhere.",
                        ),
                      ],
                      onPageChanged: (value) {
                        onboardcontroller.percent = (value + 1) * 1 / 3;
                        onboardcontroller.currentPage = value;
                        if (onboardcontroller.percent == 1.0) {
                          onboardcontroller.govalue = true;
                        }
                        onboardcontroller.update();
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: ButtonWithLinearPercentIndicator(
                      onTap: () {
                        onboardcontroller.pagecontroller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                        );
                        onboardcontroller.update();
                        if (onboardcontroller.govalue == true) {
                          Get.off(() => LoginScreen());
                        }
                      },
                      percent: onboardcontroller.percent,
                      child: Text(
                        "Next",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
