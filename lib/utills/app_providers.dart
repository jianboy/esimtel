import 'package:esimtel/views/homeModule/bannersModule/bloc/banner_bloc.dart';
import 'package:esimtel/views/homeModule/datapackModule/bloc/datapack_bloc.dart';
import 'package:esimtel/views/homeModule/popularModule/popularbloc/mostpopularbloc.dart';
import 'package:esimtel/views/myEsimModule/instructions_bloc/getInstructions_bloc.dart';
import 'package:esimtel/views/packageModule/regionsList/regionDetail_bloc/regionDetails_bloc.dart';
import 'package:esimtel/views/packageModule/regionsList/regionList_bloc/region_bloc.dart';
import 'package:esimtel/views/profileMoulde/editProfileModule/bloc/editProfile_bloc/editProfile_bloc.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/bloc/faq_bloc/faq_bloc.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/bloc/raiseticket_bloc/raiseticket_bloc.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/supportmodule/bloc/tickets_bloc/ticket_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:esimtel/theme/bloc/them_block.dart';
import 'package:esimtel/utills/services/ApiService.dart';
import 'package:esimtel/views/authModule/login_bloc/loginbloc.dart';
import 'package:esimtel/views/authModule/logout_bloc/logoutbloc.dart';
import 'package:esimtel/views/authModule/verify_bloc/Verifybloc.dart';
import 'package:esimtel/views/homeModule/getUsageModule/bloc/home_bloc.dart';
import 'package:esimtel/views/homeModule/kycFormModule/kycform_bloc/kyc_form_bloc.dart';
import 'package:esimtel/views/myEsimModule/myesimbloc/fetch_esim_list_bloc.dart';
import 'package:esimtel/views/packageModule/packagesList/bloc/country_bloc/countriesListbloc.dart';
import 'package:esimtel/views/packageModule/packagesList/bloc/order_bloc/order_now_bloc.dart';
import 'package:esimtel/views/packageModule/packagesList/bloc/package_List_bloc/packageList_bloc.dart';
import 'package:esimtel/views/packageModule/packagesList/bloc/package_detail_bloc/package_details_bloc.dart';
import 'package:esimtel/views/profileMoulde/editProfileModule/bloc/getCurrency_bloc/getCurrency_bloc.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/profile_bloc/userprofile_bloc.dart';
import 'package:esimtel/views/topUpModule/topup_bloc/topupbloc.dart';
import 'package:esimtel/views/topUpModule/topup_buy_bloc/topupbybloc.dart';
import '../views/homeModule/deviceinfo/device_info_bloc/device_info_bloc.dart';
import '../views/notificationModule/noti_bloc/noti_bloc.dart';
import '../views/packageModule/packagesList/bloc/payment_initial_bloc/bloc/payment_initiate_bloc.dart';
import '../views/packageModule/packagesList/bloc/payment_verify_bloc/bloc/payment_verify_bloc.dart';
import '../views/packageModule/packagesList/bloc/razorpay_error_bloc/razorpay_error_bloc.dart';
import '../views/profileMoulde/historyOrdermodule/order_history_bloc/fetchOrderhistory_bloc.dart';
import '../views/profileMoulde/userProfileModule/deleteAccount_bloc/deleteAccount_bloc.dart';
import 'connectivity/connectivity_bloc.dart';

List<SingleChildWidget> appProviders = [
  Provider<ApiService>(create: (_) => ApiService()),

  /// BLoCs
  BlocProvider<LoginBloc>(
    create: (context) => LoginBloc(context.read<ApiService>()),
  ),
  BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
  BlocProvider<ConnectivityBloc>(create: (_) => ConnectivityBloc()),
  BlocProvider<CountryBloc>(
    create: (context) => CountryBloc(
      context.read<ApiService>(),
      context.read<ConnectivityBloc>(),
    ),
  ),
  BlocProvider<PackagelistBloc>(
    create: (context) => PackagelistBloc(context.read<ApiService>()),
  ),
  BlocProvider<PackageDetailsBloc>(
    create: (context) => PackageDetailsBloc(context.read<ApiService>()),
  ),

  BlocProvider<Verifybloc>(
    create: (context) => Verifybloc(context.read<ApiService>()),
  ),
  BlocProvider<TopUpBloc>(
    create: (context) => TopUpBloc(context.read<ApiService>()),
  ),
  BlocProvider<TopUpBuyBloc>(
    create: (context) => TopUpBuyBloc(context.read<ApiService>()),
  ),

  BlocProvider<LogOutBloc>(
    create: (context) => LogOutBloc(context.read<ApiService>()),
  ),
  BlocProvider<KycFormBloc>(
    create: (context) => KycFormBloc(context.read<ApiService>()),
  ),
  BlocProvider<HomeBloc>(
    create: (context) =>
        HomeBloc(context.read<ApiService>(), context.read<ConnectivityBloc>()),
  ),
  BlocProvider<OrderNowBloc>(
    create: (context) => OrderNowBloc(context.read<ApiService>()),
  ),
  BlocProvider<FetchEsimListbloc>(
    create: (context) => FetchEsimListbloc(context.read<ApiService>()),
  ),
  BlocProvider<FetchOrderHistorybloc>(
    create: (context) => FetchOrderHistorybloc(context.read<ApiService>()),
  ),
  BlocProvider<UserProfileBloc>(
    create: (context) => UserProfileBloc(
      context.read<ApiService>(),
      context.read<ConnectivityBloc>(),
    ),
  ),
  BlocProvider<PaymentInitiatebloc>(
    create: (context) => PaymentInitiatebloc(context.read<ApiService>()),
  ),

  BlocProvider<PaymentVerifybloc>(
    create: (context) => PaymentVerifybloc(context.read<ApiService>()),
  ),

  BlocProvider<GetCurrencyBloc>(create: (_) => GetCurrencyBloc(ApiService())),
  BlocProvider<EditProfileBloc>(create: (_) => EditProfileBloc(ApiService())),
  BlocProvider<RegionsListBloc>(create: (_) => RegionsListBloc(ApiService())),
  BlocProvider<RegionDatailsBloc>(
    create: (_) => RegionDatailsBloc(ApiService()),
  ),
  BlocProvider<BannerBloc>(create: (_) => BannerBloc(ApiService())),
  BlocProvider<Devicebloc>(create: (_) => Devicebloc(ApiService())),

  BlocProvider<DeleteAccountBloc>(
    create: (_) => DeleteAccountBloc(ApiService()),
  ),

  BlocProvider<GetESimInstructionsBloc>(
    create: (_) => GetESimInstructionsBloc(ApiService()),
  ),

  BlocProvider<MostPopularbloc>(
    create: (context) =>
        MostPopularbloc(ApiService(), context.read<ConnectivityBloc>()),
  ),

  BlocProvider<FetchNotificationbloc>(
    create: (context) => FetchNotificationbloc(ApiService()),
  ),
  BlocProvider<RazorpayErrorBloc>(
    create: (context) => RazorpayErrorBloc(ApiService()),
  ),

  BlocProvider<DataPackBloc>(create: (context) => DataPackBloc(ApiService())),
  BlocProvider<TicketsBloc>(create: (context) => TicketsBloc(ApiService())),
  BlocProvider<RaiseTicketsBloc>(
    create: (context) => RaiseTicketsBloc(ApiService()),
  ),
  BlocProvider<FAQBloc>(create: (context) => FAQBloc(ApiService())),
];
