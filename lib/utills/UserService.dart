import 'dart:convert';

import 'package:esimtel/views/authModule/model/verifymodel.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService extends GetxService {
  static UserService get to => Get.find();

  VerifyModel? _userData;
  String? _referralCode; // Add this

  VerifyModel? get currentUserData => _userData;
  String? get referralCode => _referralCode;

  void setReferralCode(String code) {
    _referralCode = code;
  }
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('UserProfileData');
    if (userJson != null) {
      _userData = VerifyModel.fromJson(jsonDecode(userJson));
    }
  }

  Future<void> clearUserData() async {
    _userData = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('UserProfileData');
  }
}
