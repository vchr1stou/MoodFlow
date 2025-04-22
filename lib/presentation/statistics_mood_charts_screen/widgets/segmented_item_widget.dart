import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/segmented_item_model.dart';

// ignore_for_file: must_be_immutable
class SegmentedItemWidget extends StatelessWidget {
  SegmentedItemWidget(
    this.segmentedItemModelObj, {
    Key? key,
    this.onSelectedChipView,
  }) : super(key: key);

  SegmentedItemModel segmentedItemModelObj;
  Function(bool)? onSelectedChipView;

  @override
  Widget build(BuildContext context) {
    return RawChip(
      padding: EdgeInsets.symmetric(
        horizontal: 14.h,
        vertical: 10.h,
      ),
      showCheckmark: false,
      labelPadding: EdgeInsets.zero,
      label: Text(
        segmentedItemModelObj.buttononeOne!,
        style: TextStyle(
          color: theme.colorScheme.onPrimary.withOpacity(0.96),
          fontSize: 11.fSize,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w600,
        ),
      ),
      selected: (segmentedItemModelObj.isSelected ?? false),
      backgroundColor: theme.colorScheme.primary.withOpacity(0.3),
      shadowColor: appTheme.black900.withOpacity(0.1),
      elevation: 2,
      selectedColor: theme.colorScheme.primary.withOpacity(0.18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.h),
        side: BorderSide.none,
      ),
      onSelected: (value) {
        onSelectedChipView?.call(value);
      },
    );
  }
}
