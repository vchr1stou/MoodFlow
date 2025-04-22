import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/listmum_one_item_model.dart';
import 'models/sign_up_step_3_filled_model.dart';
import 'provider/sign_up_step_3_filled_provider.dart';
import 'widgets/listmum_one_item_widget.dart';

class SignUpStep3FilledScreen extends StatefulWidget {
  const SignUpStep3FilledScreen({Key? key}) : super(key: key);

  @override
  SignUpStep3FilledScreenState createState() => SignUpStep3FilledScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpStep3FilledProvider(),
      child: SignUpStep3FilledScreen(),
    );
  }
}

class SignUpStep3FilledScreenState extends State<SignUpStep3FilledScreen> {
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
            child: SingleChildScrollView(
              child: Container(
                height: 760.h,
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(horizontal: 32.h),
                            decoration: AppDecoration.outline6,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgGroupOnprimary,
                                  height: 84.h,
                                  width: 154.h,
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  "lbl_your_safety_net".tr,
                                  style: theme.textTheme.headlineLarge,
                                ),
                                Text(
                                  "msg_we_all_have_people".tr,
                                  style: CustomTextStyles
                                      .titleSmallRobotoOnPrimary14,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 8.h,
                                    right: 10.h,
                                  ),
                                  child: Text(
                                    "msg_save_them_here".tr,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyles
                                        .titleSmallRobotoOnPrimary14
                                        .copyWith(height: 1.57),
                                  ),
                                ),
                                SizedBox(height: 388.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.only(bottom: 32.h),
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: Column(
                        spacing: 22,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildAlert(context),
                          CustomOutlinedButton(
                            width: 108.h,
                            text: "lbl_next".tr,
                            buttonStyle: CustomButtonStyles.none,
                            decoration:
                                CustomButtonStyles.outlineTL241Decoration,
                            alignment: Alignment.centerRight,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 46.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(left: 16.h, top: 13.h, bottom: 13.h),
        onTap: () {
          onTapArrowleftone(context);
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildAlert(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 12.h),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        spacing: 14,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<SignUpStep3FilledProvider>(
            builder: (context, provider, child) {
              return ListView.separated(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemCount: provider
                    .signUpStep3FilledModelObj.listmumOneItemList.length,
                itemBuilder: (context, index) {
                  ListmumOneItemModel model = provider
                      .signUpStep3FilledModelObj.listmumOneItemList[index];
                  return ListmumOneItemWidget(model);
                },
              );
            },
          ),
          CustomIconButton(
            height: 36.h,
            width: 38.h,
            padding: EdgeInsets.all(10.h),
            decoration: IconButtonStyleHelper.fillPrimaryTL18,
            child: CustomImageView(
              imagePath: ImageConstant.imgCloseOnprimary,
            ),
          ),
        ],
      ),
    );
  }

  /// Navigates to the previous screen.
  void onTapArrowleftone(BuildContext context) {
    NavigatorService.goBack();
  }
}
