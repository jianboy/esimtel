import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esimtel/views/packageModule/packagesList/model/countryListModel.dart';
import '../model/packageListModel.dart' hide Country;
import 'package:esimtel/views/packageModule/regionsList/model/regionsModel.dart';

class PackageListController extends GetxController {
  final scrollController = ScrollController();
  String? nextPageUrl;
  int selectedindex = 0;
  bool isLoadingMore = false;
  List<PackageList> packageListdata = [];
  TextEditingController searchController = TextEditingController();
  List<Country> allCountries = [];
  List<Datum> allRegions = [];
  List<Country> filteredCountries = [];
  List<Datum> filteredRegions = [];

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
