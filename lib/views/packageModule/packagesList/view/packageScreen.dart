import 'package:esimtel/utills/failurewidget.dart';
import 'package:esimtel/utills/global.dart';
import 'package:esimtel/utills/image.dart';
import 'package:esimtel/views/packageModule/packagesList/model/countryListModel.dart';
import 'package:esimtel/views/packageModule/regionsList/regionList_bloc/region_bloc.dart';
import 'package:esimtel/views/packageModule/regionsList/model/regionsModel.dart';
import 'package:esimtel/views/packageModule/regionsList/view/regionListScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:esimtel/utills/appcolors.dart';
import 'package:esimtel/views/packageModule/packagesList/bloc/country_bloc/countriesListbloc.dart';
import 'package:esimtel/views/packageModule/packagesList/bloc/country_bloc/country_event.dart';
import 'package:esimtel/views/packageModule/packagesList/view/packageListScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../regionsList/regionList_bloc/region_event.dart';
import '../controller/packagelistcontorller.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});
  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final packagelistcontroller = Get.find<PackageListController>();
  bool showLoadMoreHint = false; // <-- state variable
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      packagelistcontroller.searchController.addListener(_filterLists);
    });

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _filterLists() {
    final query = packagelistcontroller.searchController.text.toLowerCase();
    if (query.isEmpty) {
      packagelistcontroller.filteredCountries =
          packagelistcontroller.allCountries;
      packagelistcontroller.filteredRegions = packagelistcontroller.allRegions;
    } else {
      packagelistcontroller.filteredCountries = packagelistcontroller
          .allCountries
          .where(
            (country) => country.name?.toLowerCase().contains(query) ?? false,
          )
          .toList();
      packagelistcontroller.filteredRegions = packagelistcontroller.allRegions
          .where(
            (region) => region.name?.toLowerCase().contains(query) ?? false,
          )
          .toList();
    }
    packagelistcontroller.update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldbackgroudColor,
      body: SafeArea(
        child: GetBuilder<PackageListController>(
          builder: (packagelistcontroller) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              _buildTabs(),
              SizedBox(height: 2.w),
              _buildTabView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: packagelistcontroller.searchController,
        decoration: InputDecoration(
          hintText: tr("Search data packs for 200+ countries...."),
          prefixIcon: Container(
            padding: EdgeInsets.all(2.w),
            margin: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor,
            ),
            child: Icon(Icons.search, size: 18.sp, color: AppColors.whiteColor),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 1.w),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.w),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 0.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.w),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 0.2),
          ),
          hintStyle: TextStyle(fontSize: 14.sp),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 12.w,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 0.5.w),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Colors.transparent,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor, width: 0.5),
          borderRadius: BorderRadius.circular(2.w),
          color: Colors.white,
        ),
        indicatorPadding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 2),
        labelPadding: EdgeInsets.symmetric(horizontal: 4.w),
        labelStyle: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          color: AppColors.textColor,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          Tab(text: tr("Countries")),
          Tab(text: tr('Regions')),
        ],
        onTap: (index) {},
      ),
    );
  }

  Widget _buildTabView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          BlocBuilder<CountryBloc, ApiState<CountryListModel>>(
            builder: (context, state) {
              if (state is ApiInitial) {
                context.read<CountryBloc>().add(CountryEvent());
                context.read<RegionsListBloc>().add(RegionsListEvent());
              }
              if (state is ApiLoading) {
                return Skeletonizer(
                  enabled: true,
                  child: _buildItemList<Country>(
                    items: List.generate(
                      10,
                      (index) =>
                          Country(id: 0, name: 'Country Name', image: ''),
                    ),
                    onTap: (country) {},
                  ),
                );
              } else if (state is ApiFailure) {
                return ApiFailureWidget(
                  onRetry: () {
                    context.read<CountryBloc>().add(CountryEvent());
                  },
                );
              } else if (state is ApiSuccess<CountryListModel>) {
                // if (packagelistcontroller.allCountries.isEmpty ||
                //     packagelistcontroller.allCountries.length !=
                //         state.data?.data?.length) {
                //   packagelistcontroller.allCountries = state.data?.data ?? [];
                //   WidgetsBinding.instance.addPostFrameCallback((_) {
                //     packagelistcontroller.allCountries = state.data?.data ?? [];
                //     _filterLists();
                //   });
                // }
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  packagelistcontroller.allCountries = state.data?.data ?? [];
                  _filterLists();
                });
                return _buildItemList<Country>(
                  items: packagelistcontroller.filteredCountries,
                  onTap: (country) {
                    Get.to(() => PackageListScreen(id: country.id.toString()));
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),

          BlocBuilder<RegionsListBloc, ApiState<RegionsModel>>(
            builder: (context, state) {
              if (state is ApiLoading) {
                return Skeletonizer(
                  enabled: true,
                  child: _buildItemList<Country>(
                    items: List.generate(
                      10,
                      (index) =>
                          Country(id: 0, name: 'Country Name', image: ''),
                    ),
                    onTap: (country) {},
                  ),
                );
              } else if (state is ApiFailure) {
                return ApiFailureWidget(
                  onRetry: () {
                    context.read<RegionsListBloc>().add(RegionsListEvent());
                  },
                );
              } else if (state is ApiSuccess<RegionsModel>) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // if (packagelistcontroller.allRegions.isEmpty ||
                  //     packagelistcontroller.allRegions.length !=
                  //         state.data?.data?.length) {
                  //   packagelistcontroller.allRegions = state.data?.data ?? [];
                  //   _filterLists();
                  // }
                  packagelistcontroller.allRegions = state.data?.data ?? [];
                  _filterLists();
                });

                return _buildItemList<Datum>(
                  items: packagelistcontroller.filteredRegions,
                  onTap: (region) {
                    Get.to(
                      () => RegionListScreen(regionId: region.id.toString()),
                    );
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemList<T>({
    required List<T> items,
    required Function(T) onTap,
  }) {
    if (items.isEmpty &&
        packagelistcontroller.searchController.text.isNotEmpty) {
      return Center(
        child: Text(
          "No results found for '${packagelistcontroller.searchController.text}'",
          style: TextStyle(fontSize: 16.sp, color: AppColors.textColor),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<CountryBloc>().add(CountryEvent());
        context.read<RegionsListBloc>().add(RegionsListEvent());
      },
      child: Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
            controller: scrollController,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 5.w, left: 16, right: 16, bottom: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              final name = (item is Country)
                  ? item.name
                  : (item is Datum)
                  ? item.name
                  : '';
              final startedfrom = (item is Country)
                  ? item.startedfrom
                  : (item is Datum)
                  ? item.startedfrom
                  : '';
              final image = (item is Country)
                  ? item.image
                  : (item is Datum)
                  ? item.image
                  : '';

              return GestureDetector(
                onTap: () => onTap(item),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(width: 0.2, color: AppColors.greyColor),
                  ),
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: image ?? '',
                        placeholder: (context, url) => Skeletonizer(
                          enabled: true,
                          child: const SizedBox(width: 32, height: 32),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          Images.earthImage,
                          width: 30,
                          height: 30,
                        ),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name ?? '', style: TextStyle(fontSize: 16.sp)),
                            startedfrom != null
                                ? Text(
                                    "From $activeCurrency $startedfrom",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.greyColor,
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              );
            },
          ),

          if (showLoadMoreHint)
            Positioned(
              right: 16,
              bottom: 16,
              child: GestureDetector(
                onTap: () {
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
              ),
            ),
        ],
      ),
    );
  }
}
