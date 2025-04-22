import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/grid_item_model.dart';

// ignore_for_file: must_be_immutable
class GridItemWidget extends StatelessWidget {
  GridItemWidget(this.gridItemModelObj, {Key? key})
      : super(
          key: key,
        );

  GridItemModel gridItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 30.h,
        vertical: 4.h,
      ),
      decoration: AppDecoration.outline11.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder14,
      ),
      child: Text(
        gridItemModelObj.button!,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: theme.textTheme.labelLarge,
      ),
    );
  }
}
