import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/grid_item_model.dart';
import 'models/logscreenstep_tab_model.dart';
import 'provider/log_screen_step_2_positive_provider.dart';
import 'widgets/grid_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class LogscreenstepTabPage extends StatefulWidget {
  const LogscreenstepTabPage({Key? key})
      : super(
          key: key,
        );

  @override
  LogscreenstepTabPageState createState() => LogscreenstepTabPageState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogScreenStep2PositiveProvider(),
      child: LogscreenstepTabPage(),
    );
  }
}

class LogscreenstepTabPageState extends State<LogscreenstepTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 32.h,
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  spacing: 74,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildGrid(context),
                    CustomOutlinedButton(
                      height: 36.h,
                      width: 118.h,
                      text: "lbl_next".tr(),
                      buttonStyle: CustomButtonStyles.none,
                      decoration: CustomButtonStyles.outlineTL18Decoration,
                      buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildGrid(BuildContext context) {
    return Container(
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Consumer<LogScreenStep2PositiveProvider>(
        builder: (context, provider, child) {
          return ResponsiveGridListBuilder(
            minItemWidth: 1,
            minItemsPerRow: 3,
            maxItemsPerRow: 3,
            horizontalGridSpacing: 18.h,
            verticalGridSpacing: 18.h,
            builder: (context, items) => ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              children: items,
            ),
            gridItems: List.generate(
              provider.logscreenstepTabModelObj.gridItemList.length,
              (index) {
                GridItemModel model =
                    provider.logscreenstepTabModelObj.gridItemList[index];
                return GridItemWidget(
                  model,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
