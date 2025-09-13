import 'package:get/get.dart';
import 'package:esimtel/views/packageModule/regionsList/model/regionDetailsModel.dart';
enum FilterType {
  none,
  priceLowToHigh,
  priceHighToLow,
  unlimitedPlans,
  dataPack,
}

class RegionalListController extends GetxController {
  bool showLoadMoreHint = false;
  String? nextPageUrl;
  int selectedindex = 0;
  bool isLoadingMore = false;
  List<Datum> regionDatailsList = [];
  FilterType selectedFilter = FilterType.none;


 
}
