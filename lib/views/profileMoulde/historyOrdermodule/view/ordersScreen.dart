import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/utills/image.dart';
import 'package:esimtel/widgets/loadingListSkeletion.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:esimtel/utills/global.dart' as global;
import '../../../../core/bloc/api_state.dart';
import '../controller/orderhistoryController.dart';
import '../model/order_history_model.dart';
import '../order_history_bloc/fetchOrderhistory_bloc.dart';
import '../order_history_bloc/fetch_history_event.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final orderhistorycontroller = Get.find<OrderHistoryController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<FetchOrderHistorybloc>().add(fetchOrderhistoryEvent());
      orderhistorycontroller.scrollController.addListener(_pagination);
    });
  }

  void _pagination() {
    if (orderhistorycontroller.scrollController.position.pixels ==
        orderhistorycontroller.scrollController.position.maxScrollExtent) {
      if (orderhistorycontroller.nextPageUrl != null &&
          !orderhistorycontroller.isLoadingMore) {
        context.read<FetchOrderHistorybloc>().add(
          fetchOrderhistoryEvent(url: orderhistorycontroller.nextPageUrl),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldbackgroudColor,
      appBar: AppBar(title: const Text("Orders History").tr()),
      body: GetBuilder<OrderHistoryController>(
        builder: (orderhistorycontroller) =>
            BlocConsumer<FetchOrderHistorybloc, ApiState<OrderHistoryModel>>(
              listener: (context, state) {
                if (state is ApiLoading &&
                    orderhistorycontroller.esimOrders.isNotEmpty) {
                  orderhistorycontroller.isLoadingMore = true;
                  orderhistorycontroller.update();
                } else if (state is ApiSuccess) {
                  if (state.data?.data.prevPageUrl == null) {
                    orderhistorycontroller.esimOrders =
                        state.data?.data.data ?? [];
                  } else {
                    orderhistorycontroller.esimOrders.addAll(
                      state.data?.data.data ?? [],
                    );
                  }
                  orderhistorycontroller.nextPageUrl =
                      state.data?.data.nextPageUrl;
                  orderhistorycontroller.isLoadingMore = false;
                  orderhistorycontroller.update();
                } else if (state is ApiFailure) {
                  orderhistorycontroller.isLoadingMore = false;
                  orderhistorycontroller.update();
                }
              },
              builder: (context, state) {
                if (state is ApiLoading &&
                    orderhistorycontroller.esimOrders.isEmpty) {
                  return LoadingListSkeletion(isLoading: state is ApiLoading);
                }

                if (state is ApiFailure &&
                    orderhistorycontroller.esimOrders.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.red.shade400,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.error ?? 'An unknown error occurred.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Colors.red.shade700,
                                  fontSize: 16,
                                ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<FetchOrderHistorybloc>().add(
                                fetchOrderhistoryEvent(),
                              );
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (orderhistorycontroller.esimOrders.isEmpty) {
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
                          'No eSIM orders found.',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                color: Colors.grey.shade600,
                                fontSize: 18,
                              ),
                        ).tr(),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<FetchOrderHistorybloc>().add(
                      fetchOrderhistoryEvent(),
                    );
                  },
                  child: ListView.builder(
                    controller: orderhistorycontroller.scrollController,
                    padding: EdgeInsets.only(
                      left: 2.w,
                      right: 2.w,
                      top: 5.w,
                      bottom: 5.w,
                    ),
                    itemCount:
                        orderhistorycontroller.esimOrders.length +
                        (orderhistorycontroller.nextPageUrl != null ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == orderhistorycontroller.esimOrders.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.w),
                          child: Center(
                            child: global.showPaginationLoader(context),
                          ),
                        );
                      }
                      final order = orderhistorycontroller.esimOrders[index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 1.w,
                          vertical: 1.w,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 1.w,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2.w),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order Ref: ${order.orderRef}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo,
                                        ),
                                  ).tr(args: ["${order.orderRef}"]),
                                ],
                              ),
                              SizedBox(height: 2.w),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: orderhistorycontroller
                                      .getStatusColor(order.status)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(2.w),
                                  border: Border.all(
                                    width: 0.5,
                                    color: orderhistorycontroller
                                        .getStatusColor(order.status),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Order Status",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: orderhistorycontroller
                                                .getStatusColor(order.status),
                                          ),
                                    ).tr(),
                                    Spacer(),
                                    Icon(
                                      orderhistorycontroller.getStatusIcon(
                                        order.status,
                                      ),
                                      size: 16,
                                      color: orderhistorycontroller
                                          .getStatusColor(order.status),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      order.status,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: orderhistorycontroller
                                                .getStatusColor(order.status),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 15),
                              if (order.activationDetails != null &&
                                  order.activationDetails?.error == null) ...[
                                _buildDetailRow(
                                  'Package:',
                                  '${order.activationDetails?.packageName ?? 'N/A'} - ${order.activationDetails?.data ?? 'N/A'}',

                                  Images.packageImage,
                                ),
                                _buildDetailRow(
                                  'Validity:',
                                  '${order.activationDetails?.validity ?? 'N/A'} Days',
                                  Images.calenderImage,
                                ),
                                _buildDetailRow(
                                  'Price:',
                                  '${order.activationDetails?.currency ?? 'N/A'} ${order.activationDetails?.netPrice.toStringAsFixed(1) ?? 'N/A'}',
                                  Images.priceImage,
                                ),
                              ] else ...[
                                _buildDetailRow(
                                  'Details:',
                                  'Activation details not available yet.',
                                  Images.infoImage,
                                  textColor: Colors.grey.shade600,
                                ),
                              ],
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.bottomRight,
                                child:
                                    Text(
                                      'Ordered on: ${DateFormat('dd MMM yyyy, hh:mm a').format(order.createdAt.toLocal())}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 12,
                                            color: Colors.grey.shade500,
                                          ),
                                    ).tr(
                                      args: [
                                        (DateFormat(
                                          'MMM dd, yyyy HH:mm',
                                        ).format(order.createdAt.toLocal())),
                                      ],
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    String icon, {
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(icon, height: 20, color: Colors.indigo.shade400),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ).tr(),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 15.sp,
                color: textColor ?? Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
