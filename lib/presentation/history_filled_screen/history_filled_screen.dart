import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/history_filled_item_model.dart';
import 'models/history_filled_model.dart';
import 'provider/history_filled_provider.dart';
import 'widgets/history_filled_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class HistoryFilledScreen extends StatefulWidget {
  const HistoryFilledScreen({Key? key})
      : super(
          key: key,
        );

  @override
  HistoryFilledScreenState createState() => HistoryFilledScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HistoryFilledProvider(),
      child: HistoryFilledScreen(),
    );
  }
}

class HistoryFilledScreenState extends State<HistoryFilledScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: _buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: AppDecoration.gradientAmberToRed,
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 36.h),
            padding: EdgeInsets.symmetric(horizontal: 14.h),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "lbl_history".tr(),
                    style: theme.textTheme.displaySmall,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "msg_sun_march_30".tr().toUpperCase(),
                  style: CustomTextStyles.labelLargeOnPrimary13_2,
                ),
                SizedBox(height: 14.h),
                _buildHistoryfilled(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 36.h,
      leadingWidth: 20.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevron,
        margin: EdgeInsets.only(left: 8.h),
      ),
      title: AppbarSubtitleOne(
        text: "lbl_back".tr(),
        margin: EdgeInsets.only(left: 10.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildHistoryfilled(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          left: 12.h,
          right: 16.h,
        ),
        child: Consumer<HistoryFilledProvider>(
          builder: (context, provider, child) {
            return ListView.builder(
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount:
                  provider.historyFilledModelObj.historyFilledItemList.length,
              itemBuilder: (context, index) {
                HistoryFilledItemModel model =
                    provider.historyFilledModelObj.historyFilledItemList[index];
                return HistoryFilledItemWidget(
                  model,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
