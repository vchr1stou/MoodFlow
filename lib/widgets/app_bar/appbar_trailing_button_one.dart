import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../custom_drop_down.dart';
import 'package:easy_localization/easy_localization.dart';

class AppbarTrailingButtonOne extends StatelessWidget {
  AppbarTrailingButtonOne({
    Key? key,
    this.onTap,
    this.margin,
  }) : super(key: key);

  final Function? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: CustomElevatedButton(
          height: 26.h,
          width: 48.h,
          text: "lbl_help".tr(),
          buttonStyle: CustomButtonStyles.outlineBlack,
          buttonTextStyle: theme.textTheme.labelLarge!,
        ),
      ),
    );
  }
}
