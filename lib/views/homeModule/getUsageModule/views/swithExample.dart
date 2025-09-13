import 'package:cached_network_image/cached_network_image.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/appColors.dart';
import 'package:esimtel/utills/global.dart';
import 'package:esimtel/utills/image.dart';
import 'package:esimtel/views/homeModule/controller/homeController.dart';
import 'package:esimtel/views/homeModule/datapackModule/bloc/datapack_bloc.dart';
import 'package:esimtel/views/homeModule/datapackModule/model/datapackModel.dart';
import 'package:esimtel/views/navbarModule/bloc/navbar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../packageModule/packagesList/view/packageDetailsScreen.dart';
import '../../datapackModule/bloc/datapack_event.dart';

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  final navController = Get.find<BottomNavController>();
  List<Datum> dataPackList = [];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (homeController) {
        return BlocBuilder<DataPackBloc, ApiState<DataPackModel>>(
          builder: (context, state) {
            final data = state.data?.data ?? [];
            dataPackList = state.data?.data ?? [];
            return Column(
              children: [
                Center(
                  child: ToggleButtons(
                    fillColor: AppColors.primaryColor,
                    selectedColor: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(30.w),
                    borderColor: AppColors.primaryColor,
                    selectedBorderColor: AppColors.primaryColor,
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    constraints: const BoxConstraints(
                      minHeight: 35,
                      minWidth: 120,
                    ),
                    isSelected: homeController.isSelected,
                    onPressed: (index) {
                      if (index == 0) {
                        context.read<DataPackBloc>().add(
                          DatapackEvent(isdatapack: true),
                        );
                      } else {
                        context.read<DataPackBloc>().add(
                          DatapackEvent(isdatapack: false),
                        );
                      }
                      for (
                        int i = 0;
                        i < homeController.isSelected.length;
                        i++
                      ) {
                        homeController.isSelected[i] = i == index;
                      }
                      homeController.update(); // only one selected
                    },
                    children: const [Text("Data"), Text("Data+Call+SMS")],
                  ),
                ),
                SizedBox(height: 5),
                SizedBox(
                  height: 20.h,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Get.to(
                              () => PackageDetailsScreen(
                                packageId: "${data[index].id}",
                              ),
                            );
                          },
                          child: Container(
                            width: 170,
                            margin: EdgeInsets.all(1.w),
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.w),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 35.w,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 3.w,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(30.w),
                                    ),
                                    child: Image.asset(
                                      Images.ESimTel_TextLogo,
                                      width: 30,
                                    ),
                                  ),
                                ),
                                homeController.isSelected[0]
                                    ? Text(
                                        "Coverage ${data[index].country['name']}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.textGreyColor,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : SizedBox(),
                                homeController.isSelected[0]
                                    ? SizedBox(height: 8)
                                    : SizedBox.shrink(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Image.asset(
                                              Images.signalIcon,
                                              height: 12,
                                              color: AppColors.redColor,
                                            ),
                                          ),
                                          const WidgetSpan(
                                            child: SizedBox(width: 4),
                                          ), // spacing
                                          TextSpan(
                                            text: "${data[index].data}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      AppColors.textGreyColor,
                                                ),
                                          ),
                                        ],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    homeController.isSelected[1]
                                        ? CachedNetworkImage(
                                            imageUrl:
                                                "${data[index].country['image']}",
                                            placeholder: (context, url) =>
                                                SizedBox(
                                                  width: 6.w,
                                                  height: 6.w,
                                                  child: Skeletonizer(
                                                    enabled: true,
                                                    child: Container(
                                                      width: 6.w,
                                                      height: 6.w,
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                  ),
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                                      Images.earthImage,
                                                      width: 10.w,
                                                      height: 10.w,
                                                    ),
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                                      width: 6.w,
                                                      height: 6.w,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                                SizedBox(height: 5),
                                homeController.isSelected[1]
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  child: Image.asset(
                                                    Images.CallIcon,
                                                    height: 12,
                                                    color: AppColors.blueColor,
                                                  ),
                                                ),
                                                const WidgetSpan(
                                                  child: SizedBox(width: 4),
                                                ), // spacing
                                                TextSpan(
                                                  text:
                                                      ((data[index].name ?? "")
                                                              .toString()
                                                              .split(" - "))
                                                          .firstWhere(
                                                            (part) =>
                                                                part.contains(
                                                                  "Mins",
                                                                ),
                                                            orElse: () => "N/A",
                                                          ),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors
                                                            .textGreyColor,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  child: Image.asset(
                                                    Images.messageIcon,
                                                    height: 12,
                                                    color: AppColors.greenColor,
                                                  ),
                                                ),
                                                const WidgetSpan(
                                                  child: SizedBox(width: 4),
                                                ), // spacing
                                                TextSpan(
                                                  text:
                                                      ((data[index].name ?? "")
                                                              .toString()
                                                              .split(" - "))
                                                          .firstWhere(
                                                            (part) =>
                                                                part.contains(
                                                                  "SMS",
                                                                ),
                                                            orElse: () => "0",
                                                          ),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors
                                                            .textGreyColor,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                                Spacer(),
                                Divider(color: AppColors.primaryColor),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        text: "$activeCurrency",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.textColor,
                                            ),
                                        children: [
                                          TextSpan(
                                            text: "${data[index].netPrice}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.textColor,
                                                ),
                                          ),
                                        ],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_sharp,
                                      size: 15.sp,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
