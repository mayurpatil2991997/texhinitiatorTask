import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:tech_initiator/Themes/app_colors_theme.dart';
import 'package:tech_initiator/Themes/app_text_theme.dart';

class CustomTextField extends StatelessWidget {
  // final String label;
  final String hintText;
  final String? counterText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  String? Function(String?)? validator;
  Widget? widget;
  GestureTapCallback? onTap, onSufixIconClick;
  ValueChanged<String>? onChanged;
  Function()? onEditingComplete;
  ValueChanged<String>? onSubmitted;
  FocusNode? focusNode;
  bool obscureText = false,
      showCursor = true,
      readOnly = true,
      autoFocus = false;
  TextStyle? style;
  TextStyle? hintStyle;
  int? maxLength;
  int? maxLine;
  double? borderRadius;
  double? left;
  double? right;
  bool enabled;
  final InputDecoration? decoration;
  Widget? suFixIcon;
  Widget? preFix;
  final TextInputAction? textInputAction;
  final EdgeInsetsGeometry? contentPadding;
  // final FormFieldValidator<String?>? validator;

  CustomTextField(
      {Key? key,
      // this.label,
      required this.hintText,
      this.borderRadius,
      this.right,
      this.left,
      this.inputFormatters,
      required this.controller,
      required this.keyboardType,
      // this.validator,
      this.onTap,
      this.onChanged,
      this.onEditingComplete,
      this.onSubmitted,
      this.focusNode,
      this.showCursor = false,
      this.obscureText = false,
      this.readOnly = false,
      this.autoFocus = false,
      this.decoration,
      this.style,
      this.hintStyle,
      this.counterText,
      this.maxLength,
      this.maxLine,
      this.enabled = true,
      this.preFix,
      this.suFixIcon,
      this.onSufixIconClick,
      this.textInputAction,
      this.validator,
      this.widget,
      this.contentPadding,
        // required this.label,
      })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right:right ?? 2.w, left: left ?? 0.w),
      child: TextFormField(
        style: style ?? AppTextStyle.normalText,
        keyboardType: keyboardType,
        controller: controller,
        validator: validator,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        maxLines: maxLine ?? 1,
        showCursor: true,
        enabled: enabled,
        readOnly: readOnly,
        autofocus: autoFocus,
        onTap: onTap,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onFieldSubmitted: onSubmitted,
        focusNode: FocusNode(),
        obscureText: obscureText,
        textInputAction: textInputAction,
        cursorColor: AppColor.primaryColor,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: decoration ??
            InputDecoration(
                border: const OutlineInputBorder(),
                hintText: hintText,
                hintStyle: hintStyle ?? AppTextStyle.normalText.copyWith(
                  color: AppColor.blackColor,
                  fontSize: 16
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColor.greyColor,
                    strokeAlign: 1
                  ),
                  borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColor.greyColor,
                      strokeAlign: 1
                  ),
                  borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColor.redColor,
                  ),
                  borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
                ),
                isDense: true,
                // label: Text(
                //   label,
                //   style: AppTextStyle.semiBold,
                // ),
                filled: true,
                fillColor: AppColor.greyColor.withOpacity(0.1),
                focusColor: AppColor.greyColor,
                counterText: counterText ?? "",
                contentPadding: contentPadding,
                prefixIcon: preFix,
                suffixIcon: suFixIcon,
            ),
      ),
    );
  }
}
