import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/chipviewactiont_item_model.dart';

// ignore_for_file: must_be_immutable
class ChipviewactiontItemWidget extends StatelessWidget {
  ChipviewactiontItemWidget(
    this.chipviewactiontItemModelObj, {
    Key? key,
    this.onSelectedChipView,
  }) : super(key: key);

  ChipviewactiontItemModel chipviewactiontItemModelObj;
  Function(bool)? onSelectedChipView;

  @override
  Widget build(BuildContext context) {
    return RawChip(
      padding: EdgeInsets.only(
        top: 6.h,
        right: 14.h,
        bottom: 6.h,
      ),
      showCheckmark: false,
      labelPadding: EdgeInsets.zero,
      label: Text(
        chipviewactiontItemModelObj.actiontwoOne!,
        style: TextStyle(
          color: theme.colorScheme.onPrimary.withValues(alpha: 0.96),
          fontSize: 10.fSize,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w700,
        ),
      ),
      avatar: CustomImageView(
        imagePath: ImageConstant.imgFigurerun1,
        height: 18.h,
        width: 14.h,
        margin: EdgeInsets.only(right: 4.h),
      ),
      selected: (chipviewactiontItemModelObj.isSelected ?? false),
      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.3),
      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.18),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.circular(14.h),
      ),
      onSelected: (value) {
        onSelectedChipView?.call(value);
      },
    );
  }
}
