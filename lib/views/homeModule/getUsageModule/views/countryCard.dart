import 'package:cached_network_image/cached_network_image.dart';
import 'package:esimtel/utills/appColors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:esimtel/utills/image.dart';
import 'package:esimtel/widgets/CanvasStyle/wavyBottomPainter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CountryCard extends StatelessWidget {
  final String imagePath;
  final String countryName;

  const CountryCard({
    Key? key,
    required this.imagePath,
    required this.countryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 37.w,
      margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2),
      decoration: BoxDecoration(
        color: countryName == "Discover Global"
            ? Colors.pinkAccent
            : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: countryName == "Discover Global"
              ? Colors.pinkAccent
              : Colors.grey.shade300,
          width: countryName == "Discover Global" ? 1.5 : 0.5,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(2.w), // Use fixed values
                bottomRight: Radius.circular(2.w),
              ),
              child: CustomPaint(
                size: const Size(150, 40),
                painter: countryName == "Discover Global"
                    ? null
                    : WavyBottomPainter(),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: countryName == "Discover Global"
                          ? Colors.white
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imagePath,
                    placeholder: (context, url) => Skeletonizer(
                      child: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      Images.earthImage,
                      width: 10.w,
                      height: 10.w,
                    ),
                    imageBuilder: (context, imageProvider) => Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 5), // Adjust spacing
                Text(
                  countryName,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: countryName == "Discover Global"
                        ? Colors.white
                        : AppColors.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
