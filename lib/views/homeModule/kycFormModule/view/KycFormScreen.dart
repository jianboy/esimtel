// --- The New KYC Form Screen ---

import 'dart:io';
import 'package:esimtel/widgets/CustomElevatedButton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:esimtel/core/bloc/api_state.dart';
import 'package:esimtel/utills/appColors.dart';
import '../../../profileMoulde/userProfileModule/profile_bloc/userprofile_bloc.dart';
import '../../../profileMoulde/userProfileModule/profile_bloc/userprofile_event.dart';
import '../kycform_bloc/kyc_form_bloc.dart';
import '../kycform_bloc/kycformevent.dart';
import '../model/KYCResponse.dart';

class KycFormScreen extends StatefulWidget {
  const KycFormScreen({super.key});

  @override
  State<KycFormScreen> createState() => _KycFormScreenState();
}

class _KycFormScreenState extends State<KycFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _identitycardNumber = TextEditingController();
  File? _identityCard;
  File? _panCard;
  File? _photo;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(void Function(File?) setImage) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        setImage(File(pickedFile.path));
      });
    }
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _identityCard != null &&
        _panCard != null &&
        _photo != null) {
      // Dispatch the event to the bloc
      BlocProvider.of<KycFormBloc>(context).add(
        KycFormEvent(
          fullname: _fullnameController.text,
          dob: _dobController.text,
          address: _addressController.text,
          identitycard: _identityCard!.path,
          pancard: _panCard!.path,
          photo: _photo!.path,
          icardno: _identitycardNumber.text,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields and select all images."),
        ),
      );
    }
  }

  Widget _buildImagePicker(
    String label,
    File? imageFile,
    void Function(File?) onImagePicked,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 60.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(3.w),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: imageFile != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 8),
                            Icon(
                              Icons.file_download_done,
                              color: Colors.grey,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            SizedBox(
                              width: 45.w,
                              child: Text(
                                imageFile.path.split('/').last,
                                style: TextStyle(color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              color: Colors.grey,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Click on upload",
                              style: TextStyle(color: Colors.grey),
                            ).tr(),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.grey,
                              size: 15,
                            ),
                          ],
                        ),
                ),
                SizedBox(width: 8),
                CustomElevatedButton(
                  width: 28.w,
                  height: 40,
                  onPressed: () => _pickImage(onImagePicked),
                  text: tr("Upload"),
                  padding: EdgeInsets.all(0.w),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete KYC Form").tr()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFormField(
                controller: _fullnameController,
                label: "Full Name",
                validator: (value) =>
                    value!.isEmpty ? tr('Please enter your full name') : null,
              ),
              SizedBox(height: 1.w),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Text(
                  "Use the same Name as on your identity card to avoid KYC rejection.",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.redColor,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              _buildTextFormField(
                controller: _dobController,
                label: 'Date of Birth (YYYY-MM-DD)',
                validator: (value) =>
                    value!.isEmpty ? tr('Please enter your DOB') : null,
                readOnly: true, // Make it non-editable
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    final formattedDate =
                        "${pickedDate.year.toString().padLeft(4, '0')}-"
                        "${pickedDate.month.toString().padLeft(2, '0')}-"
                        "${pickedDate.day.toString().padLeft(2, '0')}";

                    _dobController.text = formattedDate;
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Text(
                  "Use the same DOB as on your identity card to avoid KYC rejection.",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.redColor,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              _buildTextFormField(
                controller: _addressController,
                label: 'Address',
                validator: (value) =>
                    value!.isEmpty ? tr("Please enter your address") : null,
                maxLines: 3,
                minline: 1,
              ),
              SizedBox(height: 2.h),

              _buildTextFormField(
                controller: _identitycardNumber,
                label: 'Identity Card No',
                validator: (value) =>
                    value!.isEmpty ? tr("Please enter your I-Card No") : null,
                maxLines: 1,
                minline: 1,
              ),
              SizedBox(height: 2.h),
              _buildImagePicker(
                'Identity Card',
                _identityCard,
                (file) => _identityCard = file,
              ),
              SizedBox(height: 2.h),
              _buildImagePicker(
                "Pan Card",
                _panCard,
                (file) => _panCard = file,
              ),
              SizedBox(height: 2.h),
              _buildImagePicker('Photo', _photo, (file) => _photo = file),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
          child: BlocConsumer<KycFormBloc, ApiState<KYCResponse>>(
            listener: (context, state) {
              if (state is ApiSuccess) {
                context.read<UserProfileBloc>().add(UserProfileEvent());
                Get.back();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("KYC Form Submitted Successfully!").tr(),
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is ApiLoading;
              return SizedBox(
                height: 43,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitForm,
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
                          "Submit KYC Form",
                          style: TextStyle(fontSize: 16.sp),
                        ).tr(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    int? maxLines = 1,
    int? minline = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      minLines: minline,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(3.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(3.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(3.w),
        ),
        fillColor: readOnly == true ? Colors.grey.shade200 : Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
        labelText: tr(label),
        labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textGreyColor,
        ),
        floatingLabelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
