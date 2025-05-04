import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/beneathlittlelifts_three_model.dart';
import 'models/listcooking_one_item_model.dart';
import 'provider/beneathlittlelifts_three_provider.dart';
import 'widgets/listcooking_one_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class BeneathlittleliftsThreeScreen extends StatefulWidget {
  const BeneathlittleliftsThreeScreen({Key? key})
      : super(
          key: key,
        );

  @override
  BeneathlittleliftsThreeScreenState createState() =>
      BeneathlittleliftsThreeScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BeneathlittleliftsThreeProvider(),
      child: BeneathlittleliftsThreeScreen(),
    );
  }
}

class BeneathlittleliftsThreeScreenState
    extends State<BeneathlittleliftsThreeScreen> {
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
            margin: EdgeInsets.only(top: 56.h),
            padding: EdgeInsets.only(
              left: 14.h,
              top: 10.h,
              right: 14.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [_buildListcookingone(context)],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 20.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevron,
        margin: EdgeInsets.only(left: 8.h),
      ),
      title: AppbarSubtitleOne(
        text: "lbl_little_lifts".tr(),
        margin: EdgeInsets.only(left: 10.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildListcookingone(BuildContext context) {
    return Expanded(
      child: Consumer<BeneathlittleliftsThreeProvider>(
        builder: (context, provider, child) {
          return ListView.separated(
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 6.h,
              );
            },
            itemCount: provider
                .beneathlittleliftsThreeModelObj.listcookingOneItemList.length,
            itemBuilder: (context, index) {
              ListcookingOneItemModel model = provider
                  .beneathlittleliftsThreeModelObj
                  .listcookingOneItemList[index];
              return ListcookingOneItemWidget(
                model,
              );
            },
          );
        },
      ),
    );
  }
}
