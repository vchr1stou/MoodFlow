import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
        right: 12.h,
        bottom: 6.h,
        left: 12.h,
      ),
      showCheckmark: false,
      labelPadding: EdgeInsets.zero,
      label: Text(
        chipviewactiontItemModelObj.actiontwoOne?.tr() ?? "",
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: 13.fSize,
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: chipviewactiontItemModelObj.isSelected ?? false,
      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
      selectedColor: theme.colorScheme.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.circular(8.h),
      ),
      onSelected: (value) {
        onSelectedChipView?.call(value);
      },
    );
  }
}
