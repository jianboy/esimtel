import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/config.dart';
import 'package:esimtel/views/homeModule/bannersModule/bloc/banner_bloc.dart';
import 'package:esimtel/views/homeModule/bannersModule/model/bannerModel.dart';
import 'package:esimtel/views/homeModule/controller/homeController.dart';
import 'package:esimtel/views/packageModule/packagesList/view/packageListScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BuildBannerWidget extends StatelessWidget {
  const BuildBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (homeController) {
        return BlocBuilder<BannerBloc, ApiState<BannersModel>>(
          builder: (context, state) {
            if (state is ApiLoading) {
              return Skeletonizer(
                containersColor: Colors.grey.shade300, // lighter shimmer color
                enabled: state is ApiLoading,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      height: 20.h, // looks more like a banner
                      color: Colors.grey.shade200,
                    ),
                  ),
                ),
              );
            } else if (state is ApiFailure) {
              return SizedBox.shrink();
            } else if (state is ApiSuccess) {
              final bannersList = state.data?.data;
              if (bannersList!.isEmpty) {
                return SizedBox();
              } else {
                return SizedBox(
                  height: 24.h,
                  child: Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: false,
                          reverse: false,
                          height: 20.h,
                          enlargeCenterPage: true,
                          viewportFraction: 0.8,
                          enlargeFactor: 0.2,
                          onPageChanged: (index, reason) {
                            homeController.bannerActiveIndex = index;
                            homeController.update();
                          },
                        ),
                        items: bannersList.asMap().entries.map((entry) {
                          int index = entry.key;
                          var banners = entry.value;
                          return Builder(
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  debugPrint(
                                    "Banners index $index and Banner Package Id ${banners.packageId}",
                                  );
                                  Get.to(
                                    () => PackageListScreen(
                                      id: "${banners.packageId}",
                                    ),
                                  );
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(2.w),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "$imageBaseUrl/${banners.image}",
                                      placeholder: (context, url) => SizedBox(
                                        child: Skeletonizer(
                                          child: SizedBox(height: 20.h),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          SizedBox(
                                            child: Skeletonizer(
                                              child: Container(
                                                color: Colors.grey.shade200,
                                                height: 20.h,
                                              ),
                                            ),
                                          ),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                            height: 15.h,
                                            width: 80.w,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 15),
                      bannersList.length > 1
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                bannersList.length,
                                (index) => Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        homeController.bannerActiveIndex ==
                                            index
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                );
              }
            } else {
              return SizedBox();
            }
          },
        );
      },
    );
  }
}
