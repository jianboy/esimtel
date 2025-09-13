import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esimtel/utills/paymentUtils/RazorpayService.dart';
import 'package:esimtel/utills/paymentUtils/StripeService.dart';
import 'package:esimtel/utills/UserService.dart';
import 'package:esimtel/utills/appColors.dart';
import 'package:esimtel/utills/paymentUtils/cashfreeservice.dart';
import 'package:esimtel/views/packageModule/packagesList/bloc/order_bloc/order_now_bloc.dart';
import 'package:esimtel/views/packageModule/packagesList/model/ordernowModel.dart';
import 'package:esimtel/views/packageModule/packagesList/view/GPaymentUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/global.dart' as global;
import 'package:esimtel/views/navbarModule/bloc/navbar_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../bloc/order_bloc/package_datail_event.dart';
import '../bloc/payment_verify_bloc/bloc/payment_verify_bloc.dart';
import '../bloc/payment_verify_bloc/bloc/payment_verify_event.dart';
import '../bloc/payment_verify_bloc/model/paymentverifyModel.dart';
import '../bloc/razorpay_error_bloc/razorpay_error_bloc.dart';
import '../bloc/razorpay_error_bloc/razorpay_error_event.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

class Checkoutscreen extends StatefulWidget {
  dynamic packageListInfo;
  final bool isTopUp;
  final String? iccid;
  Checkoutscreen({
    super.key,
    required this.packageListInfo,
    this.isTopUp = false,
    this.iccid,
  });

  @override
  State<Checkoutscreen> createState() => _CheckoutscreenState();
}

class _CheckoutscreenState extends State<Checkoutscreen> {
  dynamic formattedRupees;
  dynamic esimOrderId;
  bool isloading = false;
  final userService = UserService.to;
  late GPaymentUtils _gpaymentUtils;
  String? selectedPaymentMethod;
  dynamic verified_esim_order_id = '';
  dynamic payment_order_id = '';

  @override
  void initState() {
    super.initState();
    final paiseString = widget.packageListInfo.netPrice.toString();
    final rupees = (double.tryParse(paiseString) ?? 0);
    formattedRupees = rupees.toStringAsFixed(0);

    // ✅ Initialize RazorpayService
    RazorpayService.instance.init(
      onSuccess: _handlePaymentSuccess,
      onFailure: _handlePaymentError,
    );

    // ✅ Initialize Google Payment Billing
    _initializeGoogleBilling();

    // ✅ Initialize Alternative Google Payment Billing
    _setupAlternativeBillingListener();
  }

  @override
  void dispose() {
    _gpaymentUtils.dispose();
    RazorpayService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(title: const Text('Checkout Screen').tr()),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<OrderNowBloc, ApiState<OrderNowModel>>(
            listener: (context, state) async {
              if (state is ApiLoading) {
                setState(() {
                  isloading = true;
                });
              }
              if (state is ApiFailure) {
                setState(() {
                  isloading = false;
                });
              }
              if (state is ApiSuccess) {
                setState(() {
                  isloading = false;
                  esimOrderId = state.data!.data!.esimOrderId;
                });
                String isStripeEnabled = global.paymentMode;
                if (Platform.isIOS) {
                  RazorpayService.instance.openPayment(
                    data: state.data!.data,
                    packageInfo: widget.packageListInfo,
                  );
                } else {
                  if (isStripeEnabled == 'Razorpay') {
                    RazorpayService.instance.openPayment(
                      data: state.data!.data,
                      packageInfo: widget.packageListInfo,
                    );
                  } else if (isStripeEnabled == 'Stripe') {
                    // STRIPE
                    _initiateStripePayment(state.data!.data);
                  } else if (isStripeEnabled == 'Cashfree') {
                    _initiatecashfreePaymentGateway(state.data!.data);
                  } else if (isStripeEnabled == 'GpayInAppPurchase') {
                    await _gpaymentUtils.buyConsumableProduct(
                      state.data!.data!.gatewayOrderId.toString(),
                    );
                    setState(() {
                      verified_esim_order_id = state.data?.data?.esimOrderId;
                      payment_order_id = state.data?.data?.gatewayOrderId;
                    });
                  }
                }
              }
            },

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.dividerColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Package Details',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            widget.packageListInfo!.country != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${widget.packageListInfo!.country?.image}",
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Skeletonizer(
                                            child: Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey[200],
                                            ),
                                          ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                            width: 60,
                                            height: 60,
                                            color: Colors.grey[200],
                                            child: const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                          ),
                                    ),
                                  )
                                : SizedBox(),
                            const SizedBox(width: 16),
                            widget.packageListInfo!.country != null
                                ? Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.packageListInfo!.country?.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontSize: 16.sp,
                                                color: AppColors.textColor,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Coverage: ${widget.packageListInfo!.country?.name}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                fontSize: 16.sp,
                                                color: AppColors.textGreyColor,
                                              ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                        SizedBox(height: 5.w),
                        _buildDetailRow('Data', widget.packageListInfo!.data),
                        Divider(color: AppColors.dividerColor),
                        _buildDetailRow(
                          'Validity',
                          widget.packageListInfo!.day,
                        ),
                        Divider(color: AppColors.dividerColor),
                        _buildDetailRow(
                          'Package ID',
                          widget.packageListInfo!.id,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Payment Summary Section
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.dividerColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Summary',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Divider(color: AppColors.dividerColor),
                        _buildDetailRow(
                          'Subtotal',

                          '${global.activeCurrency} ${global.formatPrice(double.parse(formattedRupees))}',
                        ),
                        Divider(color: AppColors.dividerColor),
                        _buildDetailRow(
                          'Tax',
                          '${global.activeCurrency} ${global.formatPrice(0.00)}',
                        ),
                        Divider(color: AppColors.dividerColor),
                        _buildDetailRow(
                          'Total',
                          '${global.activeCurrency} ${global.formatPrice(double.parse(formattedRupees))}',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: EdgeInsets.only(bottom: 3.w, left: 3.w, right: 3.w),
          child: BlocConsumer<PaymentVerifybloc, ApiState<PaymentVerifyModel>>(
            listener: (context, state) {
              if (state is ApiFailure) {
                global.showToastMessage(message: state.error!);
              }
              if (state is ApiSuccess) {
                Get.find<BottomNavController>().navigateToTab(2);
                global.showToastMessage(message: state.data!.message!);
              }
            },
            builder: (context, state) {
              return ElevatedButton(
                onPressed: isloading
                    ? null
                    : () {
                        if (widget.isTopUp == true) {
                          context.read<OrderNowBloc>().add(
                            BuyNowEvent(
                              isTopu: true,
                              topUpiccid: widget.iccid,
                              packageid: widget.packageListInfo.id.toString(),
                            ),
                          );
                        } else {
                          context.read<OrderNowBloc>().add(
                            BuyNowEvent(
                              packageid: widget.packageListInfo.id.toString(),
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: isloading ? Colors.grey[400] : null,
                ),
                child: isloading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Pay ${global.activeCurrency} $formattedRupees ',
                        style: TextStyle(fontSize: 17.sp),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(dynamic label, dynamic value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor,
          ),
        ),
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }

  void _initializeGoogleBilling() {
    if (!Platform.isAndroid) return;

    _gpaymentUtils = GPaymentUtils(
      onMessage: (message) {
        global.showToastMessage(message: message);
        setState(() {
          isloading = false;
        });
      },
      onPurchaseVerified: (purchaseDetails) {
        // Decode into Map
        final Map<String, dynamic> decoded = jsonDecode(
          purchaseDetails.verificationData.localVerificationData,
        );

        final _esim_order_id = verified_esim_order_id; //get from insert db data
        final _gateway_order_id = payment_order_id; //get from insert db data

        final _packageName = decoded["packageName"]; //get from google response
        final _purchaseToken = decoded["purchaseToken"];
        final _googleorderid = decoded["orderId"];
        final _quantitiy = decoded["quantity"];

        print('''
            📦 Verify Purchase Info:
              • esim_order_id   : $_esim_order_id
              • gateway_order_id: $_gateway_order_id
              • packageName     : ${decoded["packageName"]}
              • google_order_id : ${decoded["orderId"]}
              • purchaseToken   : ${decoded["purchaseToken"]}
              • quantity        : $_quantitiy
            ''');

        context.read<PaymentVerifybloc>().add(
          PaymentVerifyEvent(
            isTopup: widget.isTopUp,
            iccid: widget.iccid,
            esim_order_id: _esim_order_id,
            packageName: _packageName,
            gateway_order_id: _gateway_order_id,
            purchaseToken: _purchaseToken,
            googleorderid: _googleorderid,
          ),
        );
      },

      onPurchasedError: (purchaseDetails) {
        final Map<String, dynamic> errorData = {
          'status': purchaseDetails.status.toString(),
          'error': {
            'source': purchaseDetails.error?.source,
            'code': purchaseDetails.error?.code,
            'message': purchaseDetails.error?.message,
            'details': purchaseDetails.error?.details,
          },
        };
        final String jsonError = jsonEncode(errorData);
        context.read<RazorpayErrorBloc>().add(
          RazorpayEvent(esimOrderId: esimOrderId, code: jsonError),
        );
      },

      onPurchasePending: () {
        global.showToastMessage(message: 'Payment is pending...');
        setState(() {
          isloading = true;
        });
      },
    );

    _gpaymentUtils.initialize();
  }

  void _setupAlternativeBillingListener() async {
    if (Platform.isAndroid) {
      final androidAddition = InAppPurchase.instance
          .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();

      androidAddition.userChoiceDetailsStream.listen((details) async {});
    } else if (Platform.isIOS) {
      final iosAddition = InAppPurchase.instance
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosAddition.showPriceConsentIfNeeded();
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    context.read<PaymentVerifybloc>().add(
      PaymentVerifyEvent(
        paymentid: response.paymentId!,
        gateway_order_id: response.orderId!,
        signature: response.signature!,
        isTopup: widget.isTopUp,
        iccid: widget.iccid,
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: 'Payment Failed: ${response.message}');
    context.read<RazorpayErrorBloc>().add(
      RazorpayEvent(
        esimOrderId: esimOrderId,
        code: jsonEncode({
          'code': response.code,
          'message': response.message,
          'error': response.error,
        }),
      ),
    );
  }

  void _initiateStripePayment(Data? data) async {
    await StripeService.instance.openPayment(
      context: context,
      data: data,
      onSuccess: () {
        context.read<PaymentVerifybloc>().add(
          PaymentVerifyEvent(
            paymentid: data?.gatewayOrderId?.toString(), //! intenid here
            gateway_order_id: esimOrderId.toString(),
            signature: 'stripe',
          ),
        );

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Payment Successful")));
      },
      onFailure: (errorData) {
        context.read<RazorpayErrorBloc>().add(
          RazorpayEvent(esimOrderId: esimOrderId, code: jsonEncode(errorData)),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Failed: ${errorData['message']}")),
        );
      },
    );
  }

  void _initiatecashfreePaymentGateway(Data? data) {
    CashfreeService.instance.openPayment(
      data: data,
      onSuccess: (orderId) {
        context.read<PaymentVerifybloc>().add(
          PaymentVerifyEvent(
            isTopup: widget.isTopUp,
            iccid: widget.iccid,
            paymentid: orderId,
          ),
        );
      },
      onFailure: (errorResponse, orderId) {
        context.read<RazorpayErrorBloc>().add(
          RazorpayEvent(
            esimOrderId: esimOrderId,
            code: jsonEncode({
              'orderId': orderId,
              'message': errorResponse.getMessage(),
              'status': errorResponse.getStatus(),
              'code': errorResponse.getCode(),
            }),
          ),
        );
      },
    );
  }
}
