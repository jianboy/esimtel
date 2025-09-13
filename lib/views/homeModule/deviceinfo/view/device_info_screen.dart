import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:esimtel/utills/appcolors.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/failurewidget.dart';
import 'package:esimtel/widgets/skeletionListWidget.dart';
import 'package:esimtel/views/homeModule/deviceinfo/device_info_bloc/device_info_bloc.dart';
import 'package:esimtel/views/homeModule/deviceinfo/device_info_bloc/device_info_event.dart';
import 'package:esimtel/views/homeModule/deviceinfo/model/deviceInfoModel.dart';

class DeviceInfoScreen extends StatefulWidget {
  const DeviceInfoScreen({super.key});

  @override
  State<DeviceInfoScreen> createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DeviceData> _allDevices = [];
  List<DeviceData> _filteredDevices = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterDevices);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterDevices);
    _searchController.dispose();
    super.dispose();
  }

  void _filterDevices() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredDevices = _allDevices;
      } else {
        _filteredDevices = _allDevices.where((device) {
          return device.name?.toLowerCase().contains(query) ??
              false || device.brand!.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldbackgroudColor,
        appBar: AppBar(title: Text('Device Compatibility').tr()),
        body: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: BlocBuilder<Devicebloc, ApiState<DeviceInfoModel>>(
                builder: (context, state) {
                  if (state is ApiInitial) {
                    context.read<Devicebloc>().add(DeviceEvent());
                    return const SizedBox.shrink();
                  } else if (state is ApiLoading && _allDevices.isEmpty) {
                    return Skeletonizer(
                      child: SkeletonListScreen(isLoading: true),
                    );
                  } else if (state is ApiFailure && _allDevices.isEmpty) {
                    return ApiFailureWidget(
                      onRetry: () {
                        context.read<Devicebloc>().add(DeviceEvent());
                      },
                    );
                  } else if (state is ApiSuccess) {
                    if (_allDevices.isEmpty) {
                      _allDevices = state.data?.data ?? [];
                      // Sort the allDevices list alphabetically by brand name
                      _allDevices.sort((a, b) {
                        final brandA = a.name ?? '';
                        final brandB = b.name ?? '';
                        return brandA.toLowerCase().compareTo(
                          brandB.toLowerCase(),
                        );
                      });
                      _filteredDevices = _allDevices;
                    }

                    if (_filteredDevices.isEmpty &&
                        _searchController.text.isNotEmpty) {
                      return Center(
                        child: Text(
                          'No results found for "${_searchController.text}"',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textColor,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.w,
                      ),
                      itemCount: _filteredDevices.length,
                      itemBuilder: (context, index) {
                        final device = _filteredDevices[index];
                        return _buildDeviceCard(device);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 4.w),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search Your Model Name'.tr(),
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15.sp),
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.w),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 0.2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.w),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 0.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.w),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 0.2),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceCard(DeviceData device) {
    return Card(
      // color: AppColors.primaryColor,
      margin: EdgeInsets.only(bottom: 1.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              device.name ?? 'N/A',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 1.w),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Brand Name: ${device.brand ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.greyColor,
                    ),
                  ),
                ),
                Text(
                  'OS: ${device.os ?? 'N/A'}',
                  style: TextStyle(fontSize: 14.sp, color: AppColors.greyColor),
                ),
              ],
            ),
            Divider(color: AppColors.dividerColor),
          ],
        ),
      ),
    );
  }
}
