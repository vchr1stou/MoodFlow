import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/softthanks_one_item_model.dart';

// ignore_for_file: must_be_immutable
class SoftthanksOneItemWidget extends StatelessWidget {
  SoftthanksOneItemWidget(
    this.softthanksOneItemModelObj, {
    Key? key,
  }) : super(key: key);

  final SoftthanksOneItemModel softthanksOneItemModelObj;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 32.h,
            vertical: 6.h,
          ),
          decoration: AppDecoration.windowsGlassBlur.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                softthanksOneItemModelObj.thewaythe!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CustomTextStyles.titleMediumBold18.copyWith(
                  height: 1.33,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
