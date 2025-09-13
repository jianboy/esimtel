import 'package:easy_localization/easy_localization.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/views/homeModule/getUsageModule/views/countryCard.dart';
import 'package:esimtel/views/navbarModule/bloc/navbar_bloc.dart';
import 'package:esimtel/views/packageModule/packagesList/controller/packagelistcontorller.dart';
import 'package:esimtel/views/packageModule/regionsList/model/regionsModel.dart';
import 'package:esimtel/views/packageModule/regionsList/regionList_bloc/region_bloc.dart';
import 'package:esimtel/views/packageModule/regionsList/view/regionListScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Regionalplans extends StatelessWidget {
  Regionalplans({super.key});
  final navController = Get.find<BottomNavController>();
  final packageListController = Get.find<PackageListController>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegionsListBloc, ApiState<RegionsModel>>(
      builder: (context, state) {
        if (state is ApiLoading) {
          return SizedBox(
            height: 100,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Skeletonizer(
                  enabled: state is ApiLoading,
                  child: CountryCard(countryName: "India", imagePath: ""),
                );
              },
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          );
        } else if (state is ApiFailure) {
          return SizedBox();
        } else if (state is ApiSuccess<RegionsModel>) {
          final regionsList = (state.data?.data ?? []).reversed.toList();
          List<Datum> orderedList = List.from(regionsList);

          // Find the item with name == "Discover Global"
          final discoverGlobal = orderedList.firstWhere(
            (item) => item.name == "Discover Global",
          );
          // If found, move it to the front
          if (discoverGlobal != null) {
            orderedList.remove(discoverGlobal);
            orderedList.insert(0, discoverGlobal);
          }
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Regional Plans",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ).tr(),
                    InkWell(
                      onTap: () {
                        navController.jumpToTab(1);
                      },
                      child: Text(
                        "See All",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 15.sp,
                          color: AppColors.primaryColor,
                        ),
                      ).tr(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: orderedList.length < 5 ? orderedList.length : 5,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(
                          () => RegionListScreen(
                            regionId: orderedList[index].id.toString(),
                          ),
                        );
                      },
                      child: CountryCard(
                        countryName: "${orderedList[index].name}",
                        imagePath: "${orderedList[index].image}",
                      ),
                    );
                  },
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ],
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
