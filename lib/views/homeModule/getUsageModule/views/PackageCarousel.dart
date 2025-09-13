import 'package:esimtel/views/homeModule/getUsageModule/views/packageCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../utills/services/ApiService.dart';
import '../../../topUpModule/topup_bloc/topupbloc.dart';
import '../../../topUpModule/topup_bloc/topupfeatchevent.dart';
import '../../../topUpModule/view/topupscreen.dart';
import '../model/dataUsage_Model.dart';

class PackageCarousel extends StatefulWidget {
  final List<Datum> data;
  final bool isLoading;

  const PackageCarousel({Key? key, required this.data, this.isLoading = false})
    : super(key: key);

  @override
  State<PackageCarousel> createState() => _PackageCarouselState();
}

class _PackageCarouselState extends State<PackageCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int? next = _pageController.page?.round();
      if (next != null && _currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.data.length,
            itemBuilder: (context, index) {
              final datum = widget.data[index].usage!;
              final clickedData = widget.data[index];
              return PackageDetailCard(
                data_usage: datum,
                location: widget.data[index].location,
                esimStatus: widget.data[index].esimStatus.toString(),
                isloadingState: widget.isLoading,
                onCardTap: () {
                  Get.to(
                    () => BlocProvider(
                      create: (context) => TopUpBloc(ApiService())
                        ..add(
                          TopUpFetchEvent(ccid: clickedData.iccid.toString()),
                        ),
                      child: TopUpScreen(iccid: clickedData.iccid.toString()),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        widget.data.length > 1
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.data.length,
                  (index) => Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
