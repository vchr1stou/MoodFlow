import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/grid_item_model.dart';
import 'models/log_screen_step_2_negative_model.dart';
import 'provider/log_screen_step_2_negative_provider.dart';
import 'widgets/grid_item_widget.dart'; // ignore_for_file: must_be_immutable
import 'package:easy_localization/easy_localization.dart';

class LogScreenStep2NegativePage extends StatefulWidget {
  const LogScreenStep2NegativePage({Key? key})
      : super(
          key: key,
        );

  @override
  LogScreenStep2NegativePageState createState() =>
      LogScreenStep2NegativePageState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogScreenStep2NegativeProvider(),
      child: LogScreenStep2NegativePage(),
    );
  }
}

class LogScreenStep2NegativePageState extends State<LogScreenStep2NegativePage>
    with AutomaticKeepAliveClientMixin<LogScreenStep2NegativePage> {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        width: double.maxFinite,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(
                horizontal: 16.h,
                vertical: 32.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildGrid(BuildContext context) {
    return Container(
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Consumer<LogScreenStep2NegativeProvider>(
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
              provider.logScreenStep2NegativeModelObj.gridItemList.length,
              (index) {
                GridItemModel model =
                    provider.logScreenStep2NegativeModelObj.gridItemList[index];
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
