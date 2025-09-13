import 'package:esimtel/utills/UserService.dart';
import 'package:esimtel/utills/image.dart';
import 'package:esimtel/views/homeModule/kycFormModule/view/kycwidget.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/Model/deleteAccount_model.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/views/profileCardWidget.dart';
import 'package:esimtel/widgets/customElevatedButton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/utills/global.dart' as global;
import 'package:esimtel/utills/services/ApiService.dart';
import 'package:esimtel/views/authModule/logout_bloc/LogoutUser.dart';
import 'package:esimtel/views/authModule/logout_bloc/logoutbloc.dart';
import 'package:esimtel/views/authModule/model/logoutModel.dart';
import 'package:esimtel/views/authModule/view/loginScreen.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/profile_bloc/userprofile_bloc.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/profile_bloc/userprofile_event.dart';
import 'package:esimtel/views/profileMoulde/editProfileModule/views/editProfileScreen.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/Model/userProfileModel.dart';
import 'package:esimtel/views/profileMoulde/privacyPolicyMudule/views/privacyPolicyScreen.dart';
import 'package:esimtel/views/profileMoulde/referAndEarn.dart';
import 'package:esimtel/views/profileMoulde/historyOrdermodule/view/ordersScreen.dart';
import 'package:esimtel/widgets/customDialogWidget.dart';

import '../../historyOrdermodule/order_history_bloc/fetchOrderhistory_bloc.dart';
import '../deleteAccount_bloc/deleteAccount_bloc.dart';
import '../deleteAccount_bloc/deleteAccount_event.dart';
import '../supportmodule/views/SupportCustomerScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'countryCode': 'US'},
    {'code': 'hi', 'name': 'Hindi', 'countryCode': 'IN'},
  ];
  final currentUser = UserService.to;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<UserProfileBloc>().add(UserProfileEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldbackgroudColor,
        body: MultiBlocListener(
          listeners: [
            BlocListener<LogOutBloc, ApiState<LogoutModel>>(
              listener: (context, state) async {
                if (state is ApiLoading) {
                  Get.dialog(
                    const Center(child: CircularProgressIndicator()),
                    barrierDismissible: false,
                  );
                } else if (state is ApiSuccess) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Get.offAll(() => const LoginScreen());
                } else if (state is ApiFailure) {
                  Get.back();
                  global.showToastMessage(message: tr('Logout failed'));
                }
              },
            ),
            BlocListener<DeleteAccountBloc, ApiState<DeleteModel>>(
              listener: (context, state) async {
                if (state is ApiLoading) {
                  Get.dialog(
                    const Center(child: CircularProgressIndicator()),
                    barrierDismissible: false,
                  );
                } else if (state is ApiSuccess) {
                  Get.back();
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  global.showToastMessage(
                    message: tr('Account deleted successfully'),
                  );

                  Get.offAll(() => const LoginScreen());
                } else if (state is ApiFailure) {
                  Get.back();
                  global.showToastMessage(
                    message: tr('Deleting account failed'),
                  );
                }
              },
            ),
          ],
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // ------------------Profile Data-----------------
                      BlocBuilder<UserProfileBloc, ApiState<UserProfileModel>>(
                        builder: (context, state) {
                          if (state is ApiLoading) {
                            final userProfileData = state.data?.data;
                            return Center(
                              child: Skeletonizer(
                                enabled: state is ApiLoading,
                                child: ProfileCardWidget(
                                  userProfileData: userProfileData,
                                ),
                              ),
                            );
                          } else if (state is ApiFailure) {
                            return SizedBox();
                          } else if (state is ApiSuccess) {
                            final userProfileData = state.data?.data;
                            return InkWell(
                              onTap: () {
                                Get.to(
                                  () => EditUserProfile(
                                    name: userProfileData?.name,
                                    email: userProfileData?.email,
                                    currencyId: userProfileData?.currencyId
                                        .toString(),
                                    imagePath: userProfileData!.imagePath,
                                    currencyName:
                                        userProfileData.currency?.symbol,
                                  ),
                                );
                              },
                              child: ProfileCardWidget(
                                userProfileData: userProfileData,
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildReferralBanner(context),
                      const SizedBox(height: 16),
                      BlocConsumer<UserProfileBloc, ApiState<UserProfileModel>>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          if (state is ApiLoading) {
                            return SizedBox.shrink();
                          } else if (state is ApiSuccess) {
                            String kycStatus =
                                state.data?.data?.kycstatus ?? 'Not applied';
                            global.paymentMode =
                                state.data?.data?.payment_mode ?? '';

                            if (kycStatus.toLowerCase() == 'approved') {
                              return const SizedBox.shrink();
                            }
                            return KycNotificationWidget(
                              kycStatus: kycStatus,
                              isLoading: false,
                            );
                          } else if (state is ApiFailure) {
                            return SizedBox.shrink();
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildOption(
                        onpressed: () {
                          Get.to(
                            () => BlocProvider(
                              create: (context) =>
                                  FetchOrderHistorybloc(ApiService()),
                              child: OrdersScreen(),
                            ),
                          );
                        },
                        context: context,
                        icon: Images.orderHistory,
                        label: "Order history",
                      ),
                      _buildOption(
                        onpressed: () {
                          _showLanguageBottomSheet(context);
                        },
                        context: context,
                        icon: Images.language,
                        label: "Language",
                      ),
                      _buildOption(
                        onpressed: () {
                          Get.to(() => PrivacyPolicyScreen(index: 0));
                        },
                        context: context,
                        icon: Images.privacy,
                        label: "Privacy Policy",
                      ),
                      _buildOption(
                        onpressed: () {
                          Get.to(() => PrivacyPolicyScreen(index: 1));
                        },
                        context: context,
                        icon: Images.termAndCondition,
                        label: "Terms and Conditions",
                      ),
                      _buildOption(
                        onpressed: () {
                          Get.to(() => SupportCustomerScreen());
                        },
                        context: context,
                        icon: Images.customerSupport,
                        label: "Customer Support",
                      ),
                      _buildOption(
                        onpressed: () {
                          global.launchPlayStore();
                        },
                        context: context,
                        icon: Images.rateUs,
                        label: "Rate App",
                      ),
                      _buildOption(
                        onpressed: () async {
                          showCustomDialog(
                            title: tr("Logout...?"),
                            subtitle: tr("Are you sure you want to logout?"),
                            primaryButtonText: tr("Logout"),
                            secondaryButtonText: tr("Cancle"),
                            onSecondaryPressed: () {
                              Get.back();
                            },
                            onPrimaryPressed: () async {
                              context.read<LogOutBloc>().add(LogoutUser());
                            },
                          );
                        },
                        context: context,
                        icon: Images.logOut,
                        label: "Logout",
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: tr("App Version"),
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(fontSize: 16.sp),
                              children: [
                                TextSpan(text: ": "),
                                TextSpan(
                                  text: global.appVersion,
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.w),
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
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      text: tr("Want_to"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(fontSize: 16.sp),
                                      children: [
                                        TextSpan(
                                          text: tr("Delete"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.redColor,
                                              ),
                                        ),
                                        TextSpan(text: tr("your_account")),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Image.asset(
                                  Images.deleteAccount,
                                  height: 40,
                                  fit: BoxFit.contain,
                                  color: AppColors.redColor,
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              child: CustomElevatedButton(
                                onPressed: () {
                                  showCustomDialog(
                                    title: tr(
                                      "Are you sure you want to Delete your account ?",
                                    ),
                                    subtitle: tr(
                                      "This action will permanently delete your account and remove all associated data to confirm click on Delete.",
                                    ),
                                    primaryButtonText: tr("Delete"),
                                    primaryButtonColor: AppColors.redColor,
                                    primaryButtonTextStyle: TextStyle(
                                      color: AppColors.whiteColor,
                                    ),
                                    secondaryButtonText: tr("Cancel"),
                                    secondaryButtonColor:
                                        AppColors.primaryColor,
                                    onSecondaryPressed: () {
                                      Get.back();
                                    },
                                    onPrimaryPressed: () async {
                                      Get.back();
                                      context.read<DeleteAccountBloc>().add(
                                        DeleteAccountEvent(),
                                      );
                                    },
                                  );
                                },
                                text: tr("Delete Account"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final currentLangCode = context.locale.languageCode;
    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.scaffoldbackgroudColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Your App Language',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ).tr(),
              const SizedBox(height: 16),
              ...languages.map((lang) {
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 2.w),
                      decoration: BoxDecoration(
                        color: currentLangCode == lang['code']
                            ? AppColors.primaryColor.withOpacity(0.1)
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(2.w),
                        border: Border.all(
                          color: currentLangCode == lang['code']
                              ? AppColors.primaryColor
                              : AppColors.dividerColor,
                        ),
                      ),
                      child: ListTile(
                        leading: Image.asset(
                          Images.language,
                          height: 7.w,
                          color: currentLangCode == lang['code']
                              ? AppColors.primaryColor
                              : AppColors.textColor,
                        ),
                        title: Text(
                          lang['name']!,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                color: currentLangCode == lang['code']
                                    ? AppColors.primaryColor
                                    : AppColors.textColor,
                                fontSize: 16.sp,
                                fontWeight: currentLangCode == lang['code']
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                              ),
                        ),
                        trailing: currentLangCode == lang['code']
                            ? Container(
                                padding: EdgeInsets.all(0.5.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.2,
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                    width: 0.5,
                                  ),
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: AppColors.primaryColor,
                                ),
                              )
                            : null,
                        onTap: () async {
                          Locale newLocale = Locale(
                            lang['code']!,
                            lang['countryCode']!,
                          );
                          await context.setLocale(newLocale);
                          await Get.updateLocale(newLocale);
                          Get.back();
                        },
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReferralBanner(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ReferAndEarnScreen());
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Refer a friend and get for you and your friend. It’s a win-win!",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 15.sp,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ).tr(
                    args: [
                      "${global.activeCurrency} ${currentUser.currentUserData?.data.referral_point}",
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "Click Here To Learn More",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.darkYellow,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp,
                        ),
                      ).tr(),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward,
                        color: AppColors.darkYellow,
                        size: 18.sp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    final VoidCallback? onpressed,
    required BuildContext context,
    required String icon,
    Color? iconColor,
    double? iconSize,
    required String label,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2.w),
          border: Border.all(width: 0.2, color: AppColors.greyColor),
        ),
        child: Row(
          children: [
            Image.asset(
              icon,
              color: iconColor ?? AppColors.primaryColor,
              height: iconSize ?? 7.w,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontSize: 16.sp),
              ).tr(),
            ),
            trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
