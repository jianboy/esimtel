import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/utills/image.dart';
import 'package:esimtel/utills/services/ApiService.dart';
import 'package:esimtel/views/profileMoulde/privacyPolicyMudule/Model/privacyPolicyModel.dart';
import 'package:esimtel/widgets/loadingSkeletion.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../privacyPolicy_bloc/privacyPolicy_bloc.dart';
import '../privacyPolicy_bloc/privacyPolicy_event.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  int index;
  PrivacyPolicyScreen({super.key, required this.index});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PrivacypolicyBloc>(
      create: (context) =>
          PrivacypolicyBloc(ApiService())..add(PrivacyPolicyEvent()),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldbackgroudColor,
        body: BlocBuilder<PrivacypolicyBloc, ApiState<PrivacyPolicyModel>>(
          builder: (context, state) {
            if (state is ApiLoading) {
              return Center(
                child: Skeletonizer(
                  enabled: state is ApiLoading,
                  child: ScrollViewSkeletion(),
                ),
              );
            } else if (state is ApiFailure) {
              return Center(child: Text("Error: ${state.error}"));
            } else if (state is ApiSuccess<PrivacyPolicyModel>) {
              final policylist = state.data!.data ?? [];
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: AppColors.primaryColor,
                    pinned: true,
                    expandedHeight: 230,
                    title: Text(
                      widget.index == 0
                          ? tr("Privacy Policy")
                          : tr("Terms and Conditions"),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        color: AppColors.blackColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: Color(0xFF002A3A),
                                border: Border.all(
                                  color: AppColors.whiteColor,
                                  width: 0.2,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                widget.index == 0
                                    ? Images.privacy
                                    : Images.termAndCondition,
                                color: AppColors.whiteColor,
                                height: 25.w,
                              ),
                            ),
                            SizedBox(height: 5.h),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SliverList(
                    delegate: SliverChildListDelegate([
                      SizedBox(height: 5.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 1.w,
                        ),
                        child: Html(
                          data: "${policylist[widget.index].shortDesc}",
                          style: {
                            "body": Style(
                              fontSize: FontSize(16),
                              color: AppColors.textColor,
                              fontWeight: FontWeight.normal,
                              textAlign: TextAlign.justify,
                            ),
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.w,
                        ),
                        child: Html(
                          data: sanitizeHtml(policylist[widget.index].longDesc!),
                          style: {
                            "body": Style(
                              fontSize: FontSize(16),
                              color: AppColors.textColor,
                              fontWeight: FontWeight.normal,
                              textAlign: TextAlign.justify,
                            ),
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ]),
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

String sanitizeHtml(String html) {
  
  return html.replaceAll(RegExp(r'font-feature-settings:[^;"]*;?'), '');
}
