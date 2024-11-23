import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tech_initiator/Themes/app_colors_theme.dart';
import 'package:tech_initiator/Themes/app_text_theme.dart';


class ButtonWidget extends StatelessWidget {
  final String? text;
  final bool showShadow;
  final Function()? onTap;
  final Color? tColor, bColor,borderColor;
  final TextStyle? textStyle;
  final double? height, width, borderRadius;

  const ButtonWidget({
    Key? key,
    required this.text,
    this.tColor,
    this.bColor,
    this.borderColor,
    this.height,
    this.width,
    this.textStyle,
    this.showShadow = false,
    this.borderRadius,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: height ?? 6.h,
        width: width ?? 85.w,
        decoration: BoxDecoration(
          color: bColor ?? AppColor.primaryColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 20),
          border: Border.all(color: borderColor ?? Colors.transparent),
          boxShadow: showShadow
              ? <BoxShadow>[
            const BoxShadow(
              // color: AppColor.appBgColor,
              blurRadius: 60,
              offset: Offset(20, 20),
            ),
          ]
              : [],
        ),
        child: Text(
          text!,
          style: textStyle ??
              AppTextStyle.normalText,
        ),
      ),
    );
  }
}
