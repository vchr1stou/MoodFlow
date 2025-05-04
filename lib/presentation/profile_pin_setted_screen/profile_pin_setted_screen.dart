import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/listchange_pin_item_model.dart';
import 'models/profile_pin_setted_model.dart';
import 'provider/profile_pin_setted_provider.dart';
import 'widgets/listchange_pin_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfilePinSettedScreen extends StatefulWidget {
  const ProfilePinSettedScreen({Key? key}) : super(key: key);

  @override
  ProfilePinSettedScreenState createState() => ProfilePinSettedScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfilePinSettedProvider(),
      child: ProfilePinSettedScreen(),
    );
  }
}

class ProfilePinSettedScreenState extends State<ProfilePinSettedScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(top: 26.h),
          decoration: AppDecoration.forBackgroundpinkyellowbggradient.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: double.maxFinite,
                child: _buildAppbar(context),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: 110.h,
                child: Column(
                  spacing: 12,
                  children: [
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgVectorOnprimary72x60,
                            height: 72.h,
                            width: 62.h,
                            margin: EdgeInsets.only(bottom: 10.h),
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgVectorOnprimary50x26,
                            height: 50.h,
                            width: 28.h,
                            alignment: Alignment.bottomCenter,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "lbl_set_pin".tr(),
                      style: theme.textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "msg_create_a_pin_to".tr(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CustomTextStyles.titleSmallRobotoOnPrimary_1
                    .copyWith(height: 1.47),
              ),
              SizedBox(height: 16.h),
              _buildAlert(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 30.h,
      leadingWidth: 46.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          onTapArrowleftone(context);
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildAlert(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(left: 36.h, right: 26.h),
        padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 8.h),
        decoration: AppDecoration.windowsGlass.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder32,
        ),
        child: Column(
          spacing: 8,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "msg_a_pin_has_been_set".tr(),
              style: theme.textTheme.titleSmall,
            ),
            Expanded(
              child: Consumer<ProfilePinSettedProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: provider
                        .profilePinSettedModelObj.listchangePinItemList.length,
                    itemBuilder: (context, index) {
                      ListchangePinItemModel model = provider
                          .profilePinSettedModelObj
                          .listchangePinItemList[index];
                      return ListchangePinItemWidget(model);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  /// Navigates to the previous screen.
  void onTapArrowleftone(BuildContext context) {
    NavigatorService.goBackWithoutContext();
  }
}
