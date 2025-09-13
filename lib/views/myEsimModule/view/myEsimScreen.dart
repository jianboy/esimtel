import 'package:esimtel/utills/failurewidget.dart';
import 'package:esimtel/utills/global.dart' as global;
import 'package:esimtel/utills/services/ApiService.dart';
import 'package:esimtel/views/myEsimModule/instructions_bloc/getInstructions_bloc.dart';
import 'package:esimtel/views/myEsimModule/instructions_bloc/getInstructions_event.dart';
import 'package:esimtel/widgets/skeletionListWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/utills/image.dart';
import 'package:esimtel/views/myEsimModule/model/EsimListModel.dart';
import 'package:esimtel/views/myEsimModule/myesimbloc/fetch_esim_list_bloc.dart';
import 'package:esimtel/views/myEsimModule/myesimbloc/fetch_esim_event.dart';
import 'package:esimtel/views/myEsimModule/view/myEsimDetails.dart';
import 'package:esimtel/widgets/custiomOutlinedButton.dart';

class MyEsimsScreen extends StatefulWidget {
  const MyEsimsScreen({super.key});

  @override
  State<MyEsimsScreen> createState() => _MyEsimsScreenState();
}

class _MyEsimsScreenState extends State<MyEsimsScreen> {
  final scrollController = ScrollController();
  bool showLoadMoreHint = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.addListener(() {
        if (scrollController.position.pixels <
            scrollController.position.maxScrollExtent - 200) {
          if (!showLoadMoreHint) {
            setState(() => showLoadMoreHint = true);
          }
        } else {
          if (showLoadMoreHint) {
            setState(() => showLoadMoreHint = false);
          }
        }
      });
    });
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

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'not_active':
        return Icons.power_off;
      case 'active':
        return Icons.check_circle_outline;
      case 'expired':
        return Icons.history_toggle_off_rounded;
      case 'pending':
        return Icons.hourglass_empty;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: showLoadMoreHint
          ? FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              highlightElevation: 0,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onPressed: () {
                scrollController.animateTo(
                  scrollController.offset + 200,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              ),
            )
          : null,
      backgroundColor: AppColors.scaffoldbackgroudColor,
      body: BlocConsumer<FetchEsimListbloc, ApiState<EsimListModel>>(
        builder: (context, state) {
          if (state is ApiInitial) {
            context.read<FetchEsimListbloc>().add(fetchEsimEvent());
          }
          if (state is ApiLoading) {
            return SkeletonListScreen(isLoading: state is ApiLoading);
          }
          if (state is ApiFailure) {
            return ApiFailureWidget(
              onRetry: () {
                context.read<FetchEsimListbloc>().add(fetchEsimEvent());
              },
            );
          }
          if (state is ApiSuccess) {
            final esimItems = state.data?.data ?? [];
            if (esimItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sim_card_outlined,
                      color: Colors.grey.shade400,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No eSIMs found.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<FetchEsimListbloc>().add(fetchEsimEvent());
              },
              child: ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.all(3.w),
                itemCount: esimItems.length + 1,
                itemBuilder: (context, index) {
                  if (index >= esimItems.length) {
                    return SizedBox(height: 10.h);
                  }
                  final esim = esimItems[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 5.w),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 1.w),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(2.w),
                                topRight: Radius.circular(2.w),
                              ),
                            ),
                            height: 30,
                            width: 45.w,
                            child: Center(
                              child: Text(
                                "Package Details",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 1.w,
                            vertical: 0.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(2.w),
                              bottomLeft: Radius.circular(2.w),
                              bottomRight: Radius.circular(2.w),
                            ),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (esim.order?.activationDetails != null) ...[
                                _buildDetailRow(
                                  'Package',
                                  '${esim.order!.activationDetails?.packageName ?? 'N/A'} - ${esim.order!.activationDetails!.data ?? 'N/A'}',
                                  Images.packageImage,
                                ),
                                _buildDetailRow(
                                  'Validity',
                                  '${esim.order!.activationDetails!.validity ?? 'N/A'} Days',
                                  Images.calenderImage,
                                ),
                                _buildDetailRow(
                                  'Price',
                                  '${esim.order!.activationDetails!.currency} ${global.formatPrice(esim.order!.activationDetails!.price)}',
                                  Images.priceImage,
                                ),
                              ] else ...[
                                _buildDetailRow(
                                  'Order Ref',
                                  esim.order?.orderRef ?? 'N/A',
                                  Images.lockImage,
                                ),
                                _buildDetailRow(
                                  'Package Details',
                                  'Not available',
                                  Images.infoImage,
                                  textColor: Colors.grey.shade600,
                                ),
                              ],
                              if (esim.remaining != null)
                                _buildDetailRow(
                                  'Remaining Data',
                                  esim.remaining.toString(),
                                  Images.validityImage,
                                ),
                              if (esim.activatedAt != null)
                                _buildDetailRow(
                                  'Activated On',
                                  DateFormat(
                                    'MMM dd, yyyy HH:mm',
                                  ).format(esim.activatedAt!.toLocal()),
                                  Images.validityImage,
                                  iconColor: AppColors.greenColor,
                                ),
                              if (esim.expiredAt != null)
                                _buildDetailRow(
                                  'Expires On',
                                  DateFormat(
                                    'MMM dd, yyyy HH:mm',
                                  ).format(esim.expiredAt!.toLocal()),
                                  Images.expireImage,
                                ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 3.w,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(
                                          esim.status,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            "eSim Status:",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.textColor,
                                                ),
                                          ).tr(),
                                          const SizedBox(width: 4),
                                          Text(
                                            esim.status
                                                .replaceAll('_', ' ')
                                                .firstLetterToUpper(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: _getStatusColor(
                                                    esim.status,
                                                  ),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    CustomOutlinedButton(
                                      width: 25.w,
                                      height: 9.w,
                                      padding: EdgeInsets.all(2.w),
                                      onPressed: () async {
                                        Map<String, dynamic> deviceDetails =
                                            await global.getDeviceDetails();
                                        Get.to(
                                          () => BlocProvider(
                                            create: (context) =>
                                                GetESimInstructionsBloc(
                                                  ApiService(),
                                                )..add(
                                                  GetESimInstructionsEvent(
                                                    icicId: esim.iccid
                                                        .toString(),
                                                  ),
                                                ),
                                            child: EsimDetailScreen(
                                              esim: esim,
                                              iosVersion:
                                                  deviceDetails["osversion"],
                                            ),
                                          ),
                                        );
                                      },
                                      text: tr("View"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
        listener: (BuildContext context, ApiState<EsimListModel> state) {
          // Optional: Add listeners for specific state changes here
        },
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    String imagePath, {
    Color? textColor,
    Color? iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.dividerColor)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 45.w,
            padding: EdgeInsets.only(
              left: 3.w,
              right: 2.w,
              top: 3.w,
              bottom: 3.w,
            ),
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: AppColors.dividerColor)),
            ),
            child: Row(
              children: [
                Image.asset(
                  imagePath,
                  height: 20,
                  color: iconColor ?? AppColors.blueColor,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ).tr(),
              ],
            ),
          ),
          Container(
            width: 45.w,
            padding: EdgeInsets.only(left: 2.w, right: 1.w),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                color: textColor ?? Colors.black54,
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
