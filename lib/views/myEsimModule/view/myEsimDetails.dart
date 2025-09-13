import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/views/myEsimModule/instructions_bloc/getInstructions_bloc.dart';
import 'package:esimtel/views/myEsimModule/model/getInstructionsModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esimtel/views/myEsimModule/view/RowInfoWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/utills/global.dart' as global;
import 'package:esimtel/utills/image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/EsimListModel.dart';

class EsimDetailScreen extends StatelessWidget {
  final EsimItem esim;
  final String? iosVersion;
  const EsimDetailScreen({super.key, required this.esim, this.iosVersion});

  @override
  Widget build(BuildContext context) {
    final activationDetails = esim.order?.activationDetails;
    if (activationDetails == null) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text('eSIM ID: ${esim.id}')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Activation details are not available for this eSIM.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  if (esim.order?.activationDetails?.data != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${esim.order!.activationDetails?.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Go Back'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldbackgroudColor,
        appBar: AppBar(title: Text('eSIM Instructions').tr()),
        body: NestedScrollView(
          physics: NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 2.w),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 2.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2.w),
                        child: ExpansionTile(
                          dense: true,
                          childrenPadding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                          ),
                          tilePadding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 0.w,
                          ),
                          backgroundColor: Colors.grey.shade200,
                          title: Text(
                            "OverView",
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textColor,
                                ),
                          ).tr(),
                          subtitle: Text(
                            "Tap to see all details",
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  fontSize: 16.sp.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textGreyColor,
                                ),
                          ).tr(),
                          leading: Image.asset(Images.infoImage, height: 18),
                          expandedAlignment: Alignment.topLeft,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "eSIM Summary",
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              // padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2.w),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                children: [
                                  InfoRow(
                                    label: 'ICCID:',
                                    value: esim.iccid,
                                    enableCopy: true,
                                    flex: 3,
                                  ),
                                  InfoRow(
                                    label: 'Matching ID:',
                                    value: esim.matchingId,
                                    enableCopy: true,
                                    flex: 3,
                                  ),
                                  InfoRow(
                                    label: "Status:",
                                    value: esim.status
                                        .replaceAll('_', ' ')
                                        .firstLetterToUpper(),
                                    flex: 3,
                                  ),
                                ],
                              ),
                            ),
                            if (esim.remaining != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Remaining Data:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                    ).tr(),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        esim.remaining.toString(),
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(height: 10),
                            _buildSectionTitle('Order Details', context),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              // padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2.w),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: [
                                  InfoRow(
                                    label: 'Order ID:',
                                    value: esim.order?.id.toString() ?? 'N/A',
                                  ),
                                  InfoRow(
                                    label: 'Order Reference:',
                                    value: esim.order?.orderRef ?? 'N/A',
                                  ),
                                  InfoRow(
                                    label: 'Created on:',
                                    value: DateFormat(
                                      'MMM dd, yyyy HH:mm',
                                    ).format(esim.createdAt.toLocal()),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildSectionTitle('Package Details', context),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2.w),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: [
                                  InfoRow(
                                    label: 'Package Name:',
                                    value:
                                        activationDetails.packageName ?? 'N/A',
                                  ),
                                  InfoRow(
                                    label: 'Data:',
                                    value: activationDetails.data ?? 'N/A',
                                  ),
                                  InfoRow(
                                    label: 'Validity:',
                                    value:
                                        "${activationDetails.validity ?? 'N/A'} Days",
                                  ),
                                  InfoRow(
                                    label: 'Price:',
                                    value:
                                        '${activationDetails.currency ?? 'N/A'} ${global.formatPrice(activationDetails.price)}',
                                  ),
                                  InfoRow(
                                    label: 'eSIM Type:',
                                    value: activationDetails.esimType ?? 'N/A',
                                  ),
                                  InfoRow(
                                    label: 'Activation Code:',
                                    value: activationDetails.code ?? 'N/A',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (esim.activatedAt != null ||
                                esim.expiredAt != null ||
                                esim.finishedAt != null)
                              _buildSectionTitle('Additional Details', context),
                            if (esim.activatedAt != null ||
                                esim.expiredAt != null ||
                                esim.finishedAt != null)
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2.w),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    if (esim.activatedAt != null)
                                      InfoRow(
                                        label: "Activated On:",
                                        value: DateFormat(
                                          'MMM dd, yyyy HH:mm',
                                        ).format(esim.activatedAt!.toLocal()),
                                      ),
                                    if (esim.expiredAt != null)
                                      InfoRow(
                                        label: "Expires On:",
                                        value: DateFormat(
                                          'MMM dd, yyyy HH:mm',
                                        ).format(esim.expiredAt!.toLocal()),
                                      ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 10),
                            _buildSectionTitle('APN Details', context),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2.w),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: [
                                  InfoRow(
                                    label: 'APN Type (eSIM):',
                                    value: esim.apnType
                                        .toString()
                                        .firstLetterToUpper(),
                                  ),
                                  InfoRow(
                                    label: 'APN Value (eSIM):',
                                    value: esim.apnValue
                                        .toString()
                                        .toLowerCase(),
                                  ),
                                  InfoRow(
                                    label: 'Roaming Enabled:',
                                    value: esim.isRoaming == 1 ? 'Yes' : 'No',
                                  ),
                                  InfoRow(
                                    label: 'iOS APN Type:',
                                    value: esim.apn.ios.apnType
                                        .toString()
                                        .firstLetterToUpper(),
                                  ),
                                  InfoRow(
                                    label: 'iOS APN Value:',
                                    value: esim.apn.ios.apnType
                                        .toString()
                                        .toLowerCase(),
                                  ),
                                  InfoRow(
                                    label: 'Android APN Type:',
                                    value: esim.apn.android.apnType
                                        .toString()
                                        .firstLetterToUpper(),
                                  ),
                                  InfoRow(
                                    label: 'Android APN Value:',
                                    value: esim.apn.android.apnType
                                        .toString()
                                        .toLowerCase(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5.w, top: 4.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Installation Guide",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ).tr(),
                ),
              ),
              Container(
                height: 6.h,
                padding: EdgeInsets.symmetric(vertical: 1.w, horizontal: 0.w),
                margin: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: AppColors.primaryColor,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(2.w),
                    color: Colors.white,
                  ),
                  indicatorPadding: EdgeInsets.symmetric(
                    horizontal: 1.w,
                    vertical: 0,
                  ),
                  labelPadding: EdgeInsets.symmetric(horizontal: 0.w),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(text: 'Andriod'),
                    Tab(text: 'IOS'),
                  ],
                ),
              ),

              Expanded(
                child: BlocBuilder<GetESimInstructionsBloc, ApiState<ESimInstructionsModel>>(
                  builder: (context, state) {
                    if (state is ApiLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is ApiFailure) {
                      return Center(child: Text("No Instructions Found"));
                    } else if (state is ApiSuccess) {
                      final directAppleInstall = state
                          .data
                          ?.data
                          .instructions
                          .ios[0]
                          .directAppleInstallationUrl;
                      final list = state
                          .data
                          ?.data
                          .instructions
                          .android[0]
                          .installationViaQrCode;
                      final manualInstall = state
                          .data
                          ?.data
                          .instructions
                          .android[0]
                          .installationManual;
                      final iosList = state.data?.data.instructions.ios
                          .firstWhere((item) {
                            final versions = item.version!
                                .split(',') // handle multiple versions
                                .map(
                                  (v) => v.trim().split('.').first,
                                ) // take only major
                                .toList();
                            return versions.contains(iosVersion ?? "16");
                          })
                          .installationViaQrCode;
                      final manualIosInstall = state.data?.data.instructions.ios
                          .firstWhere((item) {
                            final versions = item.version!
                                .split(',') // split by comma if multiple
                                .map((v) => v.trim().split('.').first)
                                .toList();
                            return versions.contains(iosVersion ?? "16");
                          })
                          .installationManual;
                      return TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildSectionTitle(
                                  'QR Code Installation',
                                  context,
                                ),

                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.w),
                                    border: Border.all(
                                      color: AppColors.dividerColor,
                                    ),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFE3F2FD),
                                        Color(0xFFFFF3E0),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        itemCount: list?.steps.length ?? 0,
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          final keys = list!.steps.keys.toList()
                                            ..sort(
                                              (a, b) => int.parse(
                                                a,
                                              ).compareTo(int.parse(b)),
                                            );
                                          final stepNumber = keys[index];
                                          final stepText =
                                              list.steps[stepNumber] ?? "";

                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal: 2.w,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor:
                                                      AppColors.primaryColor,
                                                  child: Text(
                                                    stepNumber,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    stepText,
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.bodyMedium,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),

                                      SizedBox(height: 2.h),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                0.2,
                                              ),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: QrImageView(
                                          data: list!.qrCodeData,
                                          version: QrVersions.auto,
                                          size: 200.0,
                                          gapless: true,
                                          backgroundColor: Colors.white,
                                          errorStateBuilder: (cxt, err) {
                                            return const Center(
                                              child: Text(
                                                'Uh oh! Something went wrong generating QR Code.',
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 1.h),
                                      if (list.qrCodeUrl.isNotEmpty)
                                        SizedBox(
                                          width: 75.w,
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              final url = list.qrCodeUrl;
                                              global.shareContent(
                                                text:
                                                    "Scan this QR to activate the eSIM: $url",
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.share_outlined,
                                            ),
                                            label: const Text(
                                              'Share QR Code URL',
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.blue.shade700,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                      SizedBox(height: 2.h),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 25),
                                _buildSectionTitle(
                                  'Manual Installation',
                                  context,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.w),
                                    border: Border.all(
                                      color: AppColors.dividerColor,
                                    ),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFE3F2FD),
                                        Color(0xFFFFF3E0),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        itemCount:
                                            manualInstall?.steps.length ?? 0,
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          final keys =
                                              manualInstall!.steps.keys.toList()
                                                ..sort(
                                                  (a, b) => int.parse(
                                                    a,
                                                  ).compareTo(int.parse(b)),
                                                );

                                          final stepNumber = keys[index];
                                          final stepText =
                                              manualInstall.steps[stepNumber] ??
                                              "";

                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal: 2.w,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor:
                                                      AppColors.primaryColor,
                                                  child: Text(
                                                    stepNumber,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    stepText,
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.bodyMedium,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(height: 2.h),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle(
                                  'QR Code Installation',
                                  context,
                                ),

                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.w),
                                    border: Border.all(
                                      color: AppColors.dividerColor,
                                    ),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFE3F2FD),
                                        Color(0xFFFFF3E0),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(1.w),
                                    child: Column(
                                      children: [
                                        ListView.builder(
                                          itemCount: iosList?.steps.length ?? 0,
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            // Sort step keys numerically
                                            final keys =
                                                iosList!.steps.keys.toList()
                                                  ..sort(
                                                    (a, b) => int.parse(
                                                      a,
                                                    ).compareTo(int.parse(b)),
                                                  );

                                            final stepNumber = keys[index];
                                            final stepText =
                                                iosList.steps[stepNumber] ?? "";

                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal: 2.w,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 15,
                                                    backgroundColor:
                                                        AppColors.primaryColor,
                                                    child: Text(
                                                      stepNumber,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      stepText,
                                                      style: Theme.of(
                                                        context,
                                                      ).textTheme.bodyMedium,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),

                                        SizedBox(height: 2.h),
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                  0.2,
                                                ),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: QrImageView(
                                            data: iosList!.qrCodeData,
                                            version: QrVersions.auto,
                                            size: 200.0,
                                            gapless: true,
                                            backgroundColor: Colors.white,
                                            errorStateBuilder: (cxt, err) {
                                              return const Center(
                                                child: Text(
                                                  'Uh oh! Something went wrong generating QR Code.',
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        if (directAppleInstall!.isNotEmpty)
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 3.w,
                                              vertical: 2.w,
                                            ),
                                            child: SizedBox(
                                              width: 75.w,
                                              height: 5.h,
                                              child: ElevatedButton.icon(
                                                onPressed: () async {
                                                  if (await canLaunchUrl(
                                                    Uri.parse(
                                                      directAppleInstall,
                                                    ),
                                                  )) {
                                                    await launchUrl(
                                                      Uri.parse(
                                                        directAppleInstall,
                                                      ),
                                                      mode: LaunchMode
                                                          .externalApplication,
                                                    );
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Could not launch Apple Installation URL: $directAppleInstall',
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                icon: const Icon(Icons.apple),
                                                label: const Text(
                                                  'Direct Apple Installation',
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.grey.shade900,
                                                  foregroundColor: Colors.white,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 5,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (iosList.qrCodeUrl.isNotEmpty)
                                          SizedBox(
                                            width: 75.w,
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                final url = iosList.qrCodeUrl;
                                                global.shareContent(
                                                  text:
                                                      "Scan this QR to activate the eSIM: $url",
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.share_outlined,
                                              ),
                                              label: const Text(
                                                'Share QR Code URL',
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.blue.shade700,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                        SizedBox(height: 2.h),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.w),
                                _buildSectionTitle(
                                  'Manual Installation',
                                  context,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.w),
                                    border: Border.all(
                                      color: AppColors.dividerColor,
                                    ),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFE3F2FD),
                                        Color(0xFFFFF3E0),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(1.w),
                                    child: Column(
                                      children: [
                                        ListView.builder(
                                          itemCount:
                                              manualIosInstall?.steps.length ??
                                              0,
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            final keys =
                                                manualIosInstall!.steps.keys
                                                    .toList()
                                                  ..sort(
                                                    (a, b) => int.parse(
                                                      a,
                                                    ).compareTo(int.parse(b)),
                                                  );

                                            final stepNumber = keys[index];
                                            final stepText =
                                                manualIosInstall
                                                    .steps[stepNumber] ??
                                                "";

                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal: 2.w,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 15,
                                                    backgroundColor:
                                                        AppColors.primaryColor,
                                                    child: Text(
                                                      stepNumber,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      stepText,
                                                      style: Theme.of(
                                                        context,
                                                      ).textTheme.bodyMedium,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(height: 2.h),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 0.w, bottom: 3.w, top: 0.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ).tr(),
      ),
    );
  }

  Widget _buildInfoRowWithCopy(
    String label,
    String value,
    BuildContext context, {
    bool isfromtop = false,
    double? height,
  }) {
    return Container(
      height: height,
      margin: EdgeInsets.all(0.w),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0),
      decoration: BoxDecoration(
        border: Border(
          top: isfromtop
              ? BorderSide(color: AppColors.dividerColor, width: 0.8)
              : BorderSide(color: Colors.transparent),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 25.w,
            margin: EdgeInsets.all(0),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: AppColors.dividerColor)),
            ),
            child: Expanded(
              flex: 5,
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.start,
              ).tr(),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 16.sp,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              global.showToastMessage(message: '$label copied to clipboard!');
            },
            child: Icon(Icons.copy, size: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'not_active':
        return Colors.blue.shade600;
      case 'active':
        return Colors.green.shade600;
      case 'expired':
        return Colors.red.shade600;
      case 'pending':
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
}

// Extension to capitalize first letter of a string, useful for enum names
extension StringExtension on String {
  String firstLetterToUpper() {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
