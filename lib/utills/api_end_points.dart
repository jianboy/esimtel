class ApiEndPoints {
  // ---------LoginEndpoint-------------------
  static const String LOGIN = "/loginWithOtp";
  static const String LOGOUT = "/signout";
  static const String COUNTRYLIST = "/country";
  static const String PACKAGE_DETAILS = "/packages";
  static const String PACKAGELIST = "/packages";
  static const String VERIFYEMAIL = "/verifyEmailOtp";
  static const String GETTOPUPLIST = "/getTopupList";
  static const String KYCFORM = "/kyc";
  static const String GET_USAGE = "/getUsage";
  static const String ESIMLIST = "/myEsims";
  static const String USERPROFILE = "/profile";
  static const String GETCURRENCY = "/currency";
  static const String PRIVACY_TREMSANDCONDITION = "/pages";
  static const String REGIONS = "/regions";
  static const String BANNERS = "/banners";
  static const String POPULAR_ESIMS = "/";

  // ---------Payment apis-------------------
  static const String PAYMENTINITIATE = "/payment/initiate";
  static const String PAYMENTVERIFY = "/payment/verifyPayment";
  static const String ORDERS = "/orders";
  static const String PAYMENTCANCELED = "/payment/cancel";

  // ---------Device compatibility info api-------------------
  static const String DEVICE_INFO = "/deviceCompatible";
  static const String DELETE_ACCOUNT = "/deleteAccount";
  static const String GETESIM_INSTRUCTIONS = "/instructions";

  // ---------notifications api-------------------
  static const String NOTIFICATION = "/notifications";

  //-------------Customer Support-------------------
  static const String GET_TICKETS = "/tickets";
  static const String GET_FAQ = "/faqs";
}
