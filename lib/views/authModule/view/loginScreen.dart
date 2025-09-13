import 'dart:convert';
import 'dart:developer';
import 'package:esimtel/utills/UserService.dart';
import 'package:esimtel/utills/image.dart';
import 'package:esimtel/views/profileMoulde/privacyPolicyMudule/views/privacyPolicyScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/appColors.dart';
import 'package:esimtel/utills/global.dart';
import 'package:esimtel/utills/services/ApiService.dart';
import 'package:esimtel/views/authModule/login_bloc/LoginUser.dart';
import 'package:esimtel/views/authModule/login_bloc/loginbloc.dart';
import 'package:esimtel/views/authModule/view/otpScreen.dart';
import 'package:esimtel/widgets/custiomOutlinedButton.dart';
import 'package:esimtel/widgets/customElevatedButton.dart';
import 'package:esimtel/widgets/textFieldWidget.dart';
import 'package:esimtel/widgets/CanvasStyle/waveClipper.dart';
import '../../navbarModule/views/bottomNavBarScreen.dart';
import '../auth_controller/LoginController.dart';
import '../model/usermodel.dart';
import '../model/verifymodel.dart';
import '../verify_bloc/VerifyUser.dart';
import '../verify_bloc/Verifybloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginController = Get.find<LoginController>();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Status bar background color
        statusBarIconBrightness: Brightness.dark, // Dark icons
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: 100.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE0F2F7),
                    Color(0xFFF0F4F7),
                    Color(0xFFFFFFFF),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipPath(
                  clipper: BottomWaveClipper(),
                  child: Container(
                    height: 25.h,
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 5.h, left: 5.w, right: 5.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFE0F2F7),
                          Color(0xFFE3E4F9),
                          Color(0xFFFAE0E8),
                          Color(0xFFFDE9D9),
                        ],
                        stops: [0.0, 0.3, 0.7, 1.0],
                      ),
                      color: AppColors.primaryColor,
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100.w),
                          child: Image.asset(
                            Images.splasImage,
                            width: 25.w,
                            height: 25.w,
                          ),
                        ),
                        SizedBox(height: 2.w),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: appName,
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors
                                          .primaryColor, // Different color for app name
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter your email to manage your eSIM',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 4.w),
                      TextFieldWidget(
                        textEditingController: loginController.emailController,
                        focusNode: loginController.femailfocusnode,
                        labelText: "Email",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                BlocProvider(
                  create: (_) => LoginBloc(ApiService()),
                  child: Builder(
                    builder: (context) {
                      return BlocListener<LoginBloc, ApiState<LoginModel>>(
                        listener: (context, state) {
                          if (state is ApiSuccess<LoginModel>) {
                            if (state.data?.success == true) {
                              Get.to(
                                () => OtpScreen(
                                  emailid: loginController.emailController.text,
                                ),
                              );
                            } else {
                              showToastMessage(message: "Invalid login");
                            }
                          } else if (state is ApiFailure) {
                            showToastMessage(
                              message: "Login failed: ${state.error}",
                            );
                          }
                        },
                        child: BlocBuilder<LoginBloc, ApiState<LoginModel>>(
                          builder: (context, state) {
                            final isLoading = state is ApiLoading;
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: CustomElevatedButton(
                                elevation: 0,
                                width: double.infinity,
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                        final email = loginController
                                            .emailController
                                            .text
                                            .trim();
                                        loginController.femailfocusnode
                                            .unfocus();

                                        if (email.isEmpty) {
                                          showToastMessage(
                                            message: "Please enter an email",
                                          );
                                          return;
                                        }

                                        if (!loginController.isValidEmail(
                                          email,
                                        )) {
                                          showToastMessage(
                                            message:
                                                "Please enter a valid email",
                                          );
                                          return;
                                        }
                                        context.read<LoginBloc>().add(
                                          LoginUser(email),
                                        );
                                     
                                      },
                                text: isLoading ? '' : tr('Continue'),
                                progressIndicator:
                                    const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.whiteColor,
                                    ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(color: Colors.grey, thickness: 0.5),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          tr('Or log in with'),
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor,
                              ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: Colors.grey, thickness: 0.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),

                // -------------Google Sign-in Button----------------
                BlocListener<Verifybloc, ApiState<VerifyModel>>(
                  listener: (context, state) async {
                    if (state is! ApiLoading) {
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                    if (state is ApiSuccess) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString(
                        'UserProfileData',
                        jsonEncode(state.data),
                      );
                      final savedUser = prefs.getString('UserProfileData');
                      log('🔐 Saved user data SharedPreferences: $savedUser');
                      UserService.to.loadUserData(); // after save Load all data
                      Get.off(() => BottomNavigationBarScreen(index: 0));
                    } else if (state is ApiFailure) {
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                    ), // Using a fixed value for demonstration
                    child: CustomOutlinedButton(
                      width: double.infinity,
                      text: _isLoading ? '' : 'Continue with Google',
                      onPressed: _isLoading
                          ? null // Disable the button while loading
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });

                              final userCredential = await loginController
                                  .signInWithGoogle();
                              if (userCredential != null) {
                                final user = userCredential.user;
                                String? emailid = user?.email;
                                context.read<Verifybloc>().add(
                                  VerifyUser(
                                    emailid!,
                                    isLoginUsingFirebase: true,
                                  ),
                                );
                              } else {
                                if (mounted) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Google Sign-in failed or was cancelled',
                                    ),
                                  ),
                                );
                              }
                            },
                    ),
                  ),
                ),
                Spacer(),

                // ----------Terms and Conditions-------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: tr('By continuing, you accept our '),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 15.sp,
                        color: AppColors.textColor,
                      ),
                      children: [
                        TextSpan(
                          text: tr('Terms and conditions'),
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                color: AppColors.primaryColor,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.primaryColor,
                              ),

                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              debugPrint('Term and Conditions');
                              loginController.femailfocusnode.unfocus();
                              Get.to(() => PrivacyPolicyScreen(index: 1));
                            },
                        ),
                        TextSpan(
                          text: tr(' and the '),
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontSize: 15.sp,
                                color: AppColors.textColor,
                              ),
                        ),
                        TextSpan(
                          text: tr('Privacy Policy'),
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                color: AppColors.primaryColor,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.primaryColor,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              debugPrint('Privacy tapped');
                              loginController.femailfocusnode.unfocus();
                              Get.to(() => PrivacyPolicyScreen(index: 0));
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
