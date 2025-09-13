import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/utills/global.dart';
import 'package:esimtel/utills/global.dart' as global;
import 'package:esimtel/views/topUpModule/model/topupmodel.dart';
import 'package:esimtel/views/topUpModule/topup_bloc/topupbloc.dart';
import 'package:esimtel/views/topUpModule/topup_bloc/topupfeatchevent.dart';
import 'package:esimtel/views/topUpModule/topup_buy_bloc/topupbybloc.dart';
import 'package:esimtel/widgets/CustomElevatedButton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../packageModule/packagesList/view/checkoutscreen.dart';

class TopUpScreen extends StatefulWidget {
  final String iccid;
  const TopUpScreen({Key? key, required this.iccid}) : super(key: key);

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final scrollController = ScrollController();
  String? nextPageUrl;
  bool isLoadingMore = false;
  List<TopUp> _allTopUpList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TopUpBloc>().add(
        TopUpFetchEvent(ccid: widget.iccid.toString()),
      );
      scrollController.addListener(_pagination);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _pagination() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (nextPageUrl != null && !isLoadingMore) {
        isLoadingMore = true;
        context.read<TopUpBloc>().add(
          TopUpFetchEvent(ccid: widget.iccid.toString(), url: nextPageUrl),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldbackgroudColor,
      appBar: AppBar(title: const Text('Choose Your Top-Up').tr()),
      body: BlocConsumer<TopUpBloc, ApiState<TopUpOption>>(
        listener: (context, state) {
          if (state is ApiSuccess<TopUpOption>) {
            setState(() {
              if (state.data?.links?.prev == null) {
                _allTopUpList = state.data?.data ?? [];
              } else {
                _allTopUpList.addAll(state.data?.data ?? []);
              }
              nextPageUrl = state.data?.links?.next;
              isLoadingMore = false;
            });
          } else if (state is ApiLoading && _allTopUpList.isNotEmpty) {
            setState(() {
              isLoadingMore = true;
            });
          } else if (state is ApiFailure) {
            setState(() {
              isLoadingMore = false;
            });
          }
        },
        builder: (context, state) {
          if (state is ApiLoading && _allTopUpList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_allTopUpList.isEmpty) {
            return Center(child: Text("No top-up options available.").tr());
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: ListView.builder(
              controller: scrollController,
              itemCount: _allTopUpList.length + (nextPageUrl != null ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _allTopUpList.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.w),
                    child: Center(child: global.showPaginationLoader(context)),
                  );
                }
                final topUp = _allTopUpList[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.to(
                        () => Checkoutscreen(
                          iccid: widget.iccid,
                          isTopUp: true,
                          packageListInfo: topUp,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                topUp.data?.toString() ?? '0',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo.shade900,
                                ),
                              ),
                              Icon(
                                Icons.wifi,
                                size: 20,
                                color: Colors.indigo.shade500,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            topUp.shortInfo?.toString() ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Icon(
                                Icons.call,
                                size: 16,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${topUp.voice?.toString() ?? '0'} Min',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.message,
                                size: 16,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${topUp.text?.toString() ?? '0'} SMS',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${topUp.day?.toString() ?? '0'} Days',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(width: 8),
                              Text(
                                '$activeCurrency ${topUp.netPrice?.toStringAsFixed(2) ?? '0'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          BlocBuilder<TopUpBuyBloc, ApiState>(
                            builder: (context, state) {
                              bool isLoading = state is ApiLoading;
                              return CustomElevatedButton(
                                width: double.infinity,
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        Get.to(
                                          () => Checkoutscreen(
                                            iccid: widget.iccid,
                                            isTopUp: true,
                                            packageListInfo:
                                                _allTopUpList[index],
                                          ),
                                        );
                                      },
                                text: isLoading ? '' : tr("Buy Now"),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
