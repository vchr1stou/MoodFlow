import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_button.dart';
import '../models/history_preview_item_model.dart';

// ignore_for_file: must_be_immutable
class HistoryPreviewItemWidget extends StatelessWidget {
  HistoryPreviewItemWidget(this.historyPreviewItemModelObj, {Key? key})
      : super(
          key: key,
        );

  HistoryPreviewItemModel historyPreviewItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomIconButton(
          height: 42.h,
          width: 42.h,
          padding: EdgeInsets.all(10.h),
          decoration: IconButtonStyleHelper.fillOnPrimary,
          child: CustomImageView(
            imagePath: historyPreviewItemModelObj.bagOne!,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.h),
          child: Text(
            historyPreviewItemModelObj.work!,
            style: theme.textTheme.labelMedium,
          ),
        )
      ],
    );
  }
}
