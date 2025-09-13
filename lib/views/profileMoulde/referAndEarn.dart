import 'package:esimtel/utills/UserService.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/utills/global.dart' as global;
import 'package:esimtel/utills/image.dart';
import 'package:esimtel/widgets/CustomElevatedButton.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  final currentUser = UserService.to;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], 
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: AppColors.primaryColor,
            pinned: true,
            expandedHeight: 200,
            title: Text('Refer & Earn').tr(),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                alignment: Alignment.center,
                color: AppColors.blackColor,
                padding: EdgeInsets.symmetric(horizontal: 7.w),
                child: Container(
                  margin: EdgeInsets.only(top: 15.w),
                  child:
                      Text(
                        "Refer a friend and get for you and your friend. It’s a win-win!",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 16.sp,
                          color: AppColors.whiteColor,
                        ),
                      ).tr(
                        args: [
                          '${global.activeCurrency} ${currentUser.currentUserData?.data.referral_point}',
                        ],
                      ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'How it Work\'s',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ).tr(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4.w),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildHowItWorksCard(
                            context,
                            number: '1',
                            title: 'Share your link',
                            description:
                                'copy and send the code or press the Share Now button',
                            image: Images.linkShare,
                            imageheight: 80,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: _buildHowItWorksCard(
                            context,
                            number: '2',
                            title: tr(
                              "friend_bonus",
                              args: [
                                '${global.activeCurrency} ${currentUser.currentUserData?.data.referral_point}',
                              ],
                            ),
                            description: tr(
                              "friend_signup_offer",
                              args: [
                                '${currentUser.currentUserData?.data.referral_point}',
                              ],
                            ),
                            image: Images.referAndEarn,
                            imageheight: 50,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.w),
                    Text(
                      'Share your referral code',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColor,
                      ),
                    ).tr(),
                    SizedBox(height: 3.w),
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.w),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.time,
                                size: 18,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Your referral code',
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textColor,
                                    ),
                              ).tr(),
                            ],
                          ),
                          SizedBox(height: 4.w),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  currentUser
                                          .currentUserData
                                          ?.data
                                          .user
                                          .refCode ??
                                      'N/A',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    CustomElevatedButton(
                      width: double.infinity,
                      onPressed: () async {},
                      text: tr("Share Now"),
                      textStyle: Theme.of(context).textTheme.bodyMedium!
                          .copyWith(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteColor,
                          ),
                    ),
                    const SizedBox(height: 18.0),
                    SizedBox(height: 10.h), 
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksCard(
    BuildContext context, {
    required String number,
    required String title,
    required String description,
    required String image,
    required double imageheight,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Text(
              number,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade300,
              ),
            ).tr(),
          ),
          SizedBox(height: 2.w),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ).tr(),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.normal,
              color: AppColors.textGreyColor,
            ),
          ).tr(),
          const SizedBox(height: 8),
          Image.asset(image, height: imageheight),
        ],
      ),
    );
  }
}
