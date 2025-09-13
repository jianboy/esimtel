import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esimtel/utills/config.dart';
import 'package:esimtel/utills/global.dart';
import 'package:esimtel/utills/global.dart' as global;
import 'package:esimtel/views/navbarModule/bloc/navbar_bloc.dart';
import 'package:esimtel/views/profileMoulde/editProfileModule/bloc/editProfile_bloc/editProfile_bloc.dart';
import 'package:esimtel/views/profileMoulde/editProfileModule/bloc/editProfile_bloc/editProfile_event.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/Model/userProfileModel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/appColors.dart';
import 'package:esimtel/utills/image.dart';
import 'package:esimtel/views/profileMoulde/editProfileModule/bloc/getCurrency_bloc/getCurrency_bloc.dart';
import 'package:esimtel/views/profileMoulde/editProfileModule/model/getCurrencyModel.dart';
import 'package:esimtel/views/profileMoulde/userProfileModule/profile_bloc/userprofile_event.dart';
import 'package:esimtel/widgets/textFieldWidget.dart';

import '../../../navbarModule/views/bottomNavBarScreen.dart'
    show BottomNavigationBarScreen;

class EditUserProfile extends StatefulWidget {
  final String? name;
  final String? email;
  final String? currencyId;
  final String? imagePath;
  final String? currencyName;

  const EditUserProfile({
    Key? key,
    this.name,
    this.email,
    this.currencyId,
    this.imagePath,
    this.currencyName,
  }) : super(key: key);

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  File? _selectedImage;
  String? selectedCurrencyId;
  final ImagePicker _picker = ImagePicker();
  final focusNode = FocusNode();
  String profileimagePath = "";
  String currencyName = "";
  Future<void> pickImage(Function(File?) setImage) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setImage(File(pickedFile.path));
      } else {
        setImage(null);
      }
    } catch (e) {
      print('Image pick error: $e');
      setImage(null);
    }
  }

  void _getUserDate() {
    nameController.text = widget.name ?? "";
    emailController.text = widget.email ?? "";
    profileimagePath = widget.imagePath ?? "";
    selectedCurrencyId = widget.currencyId ?? "";
    currencyName = widget.currencyName ?? "";
    setState(() {});
  }

  void _submitProfile() {
    if (nameController.text == "") {
      global.showToastMessage(message: "Name is Required");
    } else if (selectedCurrencyId != "") {
      BlocProvider.of<EditProfileBloc>(context).add(
        EditProfileEvent(
          name: nameController.text,
          email: emailController.text,
          profileImage: _selectedImage?.path != null
              ? _selectedImage!.path
              : "",
          currencyId: selectedCurrencyId.toString(),
        ),
      );
    } else {
      showToastMessage(message: "Please Select Currency");
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<GetCurrencyBloc>().add(GetCurrencyEvent());
      _getUserDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(title: Text('Profile').tr()),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 4.w, right: 4.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25),
                  Center(
                    child: Stack(
                      children: [
                        _selectedImage != null
                            ? Container(
                                height: 30.w,
                                width: 30.w,
                                padding: EdgeInsets.all(0.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.1,
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                child: ClipOval(
                                  child: _selectedImage != null
                                      ? Image.file(
                                          _selectedImage!,
                                          fit: BoxFit.cover,
                                          height: 30.w,
                                          width: 30.w,
                                        )
                                      : Image.asset(
                                          Images.userProfileIcon,
                                          fit: BoxFit.cover,
                                          color: AppColors.primaryColor,
                                          height: 30.w,
                                          width: 30.w,
                                        ),
                                ),
                              )
                            : profileimagePath != ""
                            ? Container(
                                height: 30.w,
                                width: 30.w,
                                padding: EdgeInsets.all(0.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                    width: 0.5,
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: "$imageBaseUrl/$profileimagePath",
                                  placeholder: (context, url) => const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        padding: EdgeInsets.all(4.w),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.1),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        child: Image.asset(
                                          Images.userProfileIcon,
                                          fit: BoxFit.cover,
                                          color: AppColors.whiteColor,
                                          height: 30.w,
                                          width: 30.w,
                                        ),
                                      ),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        height: 30.w,
                                        width: 30.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                ),
                              )
                            : Container(
                                height: 30.w,
                                width: 30.w,
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.1,
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                child: Image.asset(
                                  Images.userProfileIcon,
                                  fit: BoxFit.cover,
                                  color: AppColors.primaryColor,
                                  height: 30.w,
                                  width: 30.w,
                                ),
                              ),
                        Positioned(
                          bottom: 1,
                          right: 1,
                          child: GestureDetector(
                            onTap: () {
                              pickImage((file) {
                                setState(() {
                                  _selectedImage = file;
                                });
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryColor,
                                border: Border.all(color: AppColors.whiteColor),
                              ),
                              child: Image.asset(
                                Images.uploadImage,
                                color: AppColors.whiteColor,
                                height: 4.w,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.h),
                  TextFieldWidget(
                    textEditingController: nameController,
                    labelText: 'Full Name',
                    keyboardType: TextInputType.name,
                    formatter: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  TextFieldWidget(
                    readOnly: true,
                    textEditingController: emailController,
                    keyboardType: TextInputType.name,
                    formatter: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                    ],
                    labelText: 'Email',
                  ),
                  SizedBox(height: 2.h),
                  BlocBuilder<GetCurrencyBloc, ApiState<GetCurrencyModel>>(
                    builder: (context, state) {
                      var currencyList = [];
                      if (state is ApiLoading) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: "Currency:",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.blackColor,
                                        ),
                                    children: [
                                      TextSpan(text: "    "),
                                      TextSpan(
                                        text: '...',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.textGreyColor,
                                            ), 
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        );
                      } else if (state is ApiSuccess) {
                        currencyList = state.data?.data ?? [];
                      } else if (state is ApiFailure) {
                        return showToastMessage(
                          message: "Failed to Get Currency",
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                String? tempSelectedId = selectedCurrencyId;
                                String? tempCurrencyName = currencyName;
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text("Select Currency"),
                                      content: SizedBox(
                                        width: double.maxFinite,
                                        height: 300, 
                                        child: ListView.builder(
                                          itemCount: currencyList.length,
                                          itemBuilder: (context, index) {
                                            final currency =
                                                currencyList[index];
                                            return CheckboxListTile(
                                              title: Row(
                                                children: [
                                                  Text("${currency.name}"),
                                                  SizedBox(width: 6.w),
                                                  Text(
                                                    "${currency.symbol}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColors
                                                              .textGreyColor,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              value:
                                                  tempSelectedId ==
                                                  currency.id.toString(),
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  if (value == true) {
                                                    tempSelectedId = currency.id
                                                        .toString();
                                                    tempCurrencyName = currency
                                                        .symbol
                                                        .toString();
                                                  } else {
                                                    tempSelectedId = null;
                                                    tempCurrencyName = '';
                                                  }
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            this.setState(() {
                                              selectedCurrencyId =
                                                  tempSelectedId;
                                              currencyName =
                                                  tempCurrencyName ?? '';
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "Currency:",
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.blackColor,
                                      ),
                                  children: [
                                    TextSpan(text: "    "),
                                    TextSpan(
                                      text: currencyName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.textGreyColor,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 70),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: SafeArea(
          child: Container(
            width: double.infinity,
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2),
            margin: EdgeInsets.only(bottom: 2.w),
            child: BlocConsumer<EditProfileBloc, ApiState<UserProfileModel>>(
              listener: (context, state) async {
                if (state is ApiSuccess) {
                  global.sp = await SharedPreferences.getInstance();
                  await global.sp!.setString("Currency", currencyName);
                  global.activeCurrency = global.sp!.getString("Currency");
                  Get.find<BottomNavController>().jumpToTab(3);
                  Get.off(() => BottomNavigationBarScreen(index: 3));
                  showToastMessage(message: "Profile Updated Successfully");
                }
              },
              builder: (context, state) {
                final isLoading = state is ApiLoading;

                return SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submitProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Update Profile',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
