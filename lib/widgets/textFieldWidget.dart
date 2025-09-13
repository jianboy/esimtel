import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:esimtel/utills/appcolors.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    this.labelText,
    this.textEditingController,
    this.onEditingComplete,
    this.obscureText,
    this.readOnly,
    this.suffixIcon,
    this.onTap,
    this.keyboardType,
    this.focusNode,
    this.onFieldSubmitted,
    this.maxLines,
    this.enabledBorder,
    this.prefix,
    this.onChanged,
    this.textCapitalization,
    this.formatter,
    this.maxLength,
    this.counterText,
    this.contentPadding,
    this.validator,
  });

  final String? labelText;
  final TextEditingController? textEditingController;
  final Function()? onEditingComplete;
  final bool? obscureText;
  final bool? readOnly;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final int? maxLines;
  final int? maxLength;
  final dynamic counterText;
  final InputBorder? enabledBorder;
  final Widget? prefix;
  final void Function(String)? onChanged;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? formatter;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      onEditingComplete: onEditingComplete,
      focusNode: focusNode,
      maxLength: maxLength,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      maxLines: maxLines,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      obscureText: obscureText ?? false,
      readOnly: readOnly ?? false,
      onTap: readOnly == true ? null : onTap,
      cursorColor: const Color(0xFF757575),
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontSize: 17.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.blackColor,
      ),
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: formatter,
      onChanged: onChanged,
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
        fillColor: readOnly == true ? Colors.grey.shade300 : Colors.white,
        contentPadding: contentPadding,
        counterText: counterText,
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textGreyColor,
        ),
        floatingLabelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryColor,
        ),
        prefixIcon: prefix,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Icon(
            suffixIcon,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
