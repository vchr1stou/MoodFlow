import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/profile_model.dart';
import 'models/profile_one_item_model.dart';
import 'provider/profile_provider.dart';
import 'widgets/profile_one_item_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileProvider(),
      child: ProfileScreen(),
    );
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(top: 26.h),
              decoration:
                  AppDecoration.forBackgroundpinkyellowbggradient.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: _buildAppbar(context),
                  ),
                  SizedBox(height: 18.h),
                  _buildProfilewidget(context),
                  SizedBox(height: 10.h),
                  _buildProfileone(context),
                  _buildNotifications(context),
                  _buildPreferences(context),
                  _buildPreferencesone(context),
                  _buildPreferencestwo(context),
                  _buildPreferences1(context),
                  SizedBox(height: 50.h),
                ],
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
  Widget _buildProfilewidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.h),
      padding: EdgeInsets.all(20.h),
      decoration: AppDecoration.fillBlueGray.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      width: double.maxFinite,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "lbl_my_account".tr,
                            style:
                                CustomTextStyles.headlineSmallRobotoOnPrimary,
                          ),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgArrowRight,
                          height: 18.h,
                          width: 14.h,
                          margin: EdgeInsets.only(left: 4.h, top: 4.h),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    "msg_vasillis_christou".tr,
                    style: CustomTextStyles.titleLargeRobotoOnPrimary_1,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "msg_vchristou_gmail_com".tr,
                    style: CustomTextStyles.titleMediumBold_1,
                  ),
                ],
              ),
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgGroup1,
            height: 102.h,
            width: 102.h,
            radius: BorderRadius.circular(50.h),
            margin: EdgeInsets.only(top: 4.h, right: 6.h),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildProfileone(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.h),
      child: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: provider.profileModelObj.profileOneItemList.length,
            itemBuilder: (context, index) {
              ProfileOneItemModel model =
                  provider.profileModelObj.profileOneItemList[index];
              return ProfileOneItemWidget(
                model,
                changeSwitchBox: (value) {
                  provider.changeSwitchBox(index, value!);
                },
              );
            },
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildNotifications(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.h),
      padding: EdgeInsets.fromLTRB(16.h, 18.h, 16.h, 16.h),
      decoration: AppDecoration.viewsRegular,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgBellBadgeFill,
            height: 20.h,
            width: 18.h,
          ),
          Container(
            width: 136.h,
            margin: EdgeInsets.only(left: 4.h),
            child: Text(
              "msg_gentle_reminders".tr,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium,
            ),
          ),
          Spacer(),
          CustomImageView(
            imagePath: ImageConstant.imgArrowRight,
            height: 18.h,
            width: 16.h,
            margin: EdgeInsets.only(right: 4.h),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPreferences(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.h),
      padding: EdgeInsets.fromLTRB(10.h, 16.h, 10.h, 14.h),
      decoration: AppDecoration.viewsRegular,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgPersonBadgeKeyFill,
            height: 24.h,
            width: 28.h,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 58.h,
              margin: EdgeInsets.only(left: 2.h),
              child: Text(
                "lbl_set_pin".tr,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          Spacer(flex: 79),
          CustomImageView(
            imagePath: ImageConstant.imageNotFound,
            height: 22.h,
            width: 8.h,
          ),
          Spacer(flex: 20),
          CustomImageView(
            imagePath: ImageConstant.imgArrowRight,
            height: 18.h,
            width: 16.h,
            margin: EdgeInsets.only(right: 10.h),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPreferencesone(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.h),
      padding: EdgeInsets.all(16.h),
      decoration: AppDecoration.viewsRegular,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgSettingsOnprimary,
            height: 20.h,
            width: 22.h,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 124.h,
              margin: EdgeInsets.only(left: 4.h, top: 2.h),
              child: Text(
                "lbl_spotify_account".tr,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          Spacer(flex: 70),
          CustomImageView(
            imagePath: ImageConstant.imageNotFound,
            height: 22.h,
            width: 8.h,
          ),
          Spacer(flex: 29),
          CustomImageView(
            imagePath: ImageConstant.imgArrowRight,
            height: 18.h,
            width: 16.h,
            margin: EdgeInsets.only(right: 4.h),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPreferencestwo(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.h),
      padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 16.h),
      decoration: AppDecoration.viewsRegular,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgAccessibilityFill,
            height: 20.h,
            width: 22.h,
            alignment: Alignment.bottomCenter,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 98.h,
              margin: EdgeInsets.only(left: 4.h, top: 2.h),
              child: Text(
                "lbl_accessibility".tr,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          Spacer(flex: 74),
          CustomImageView(
            imagePath: ImageConstant.imageNotFound,
            height: 22.h,
            width: 8.h,
          ),
          Spacer(flex: 25),
          CustomImageView(
            imagePath: ImageConstant.imgArrowRight,
            height: 18.h,
            width: 16.h,
            margin: EdgeInsets.only(right: 4.h),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildPreferences1(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.h),
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 16.h),
      decoration: AppDecoration.viewsRegular,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgPerson3Fill2,
            height: 14.h,
            width: 28.h,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 120.h,
              margin: EdgeInsets.only(left: 2.h, top: 2.h),
              child: Text(
                "lbl_your_safety_net".tr,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          Spacer(),
          Container(
            height: 22.h,
            width: 16.h,
            margin: EdgeInsets.only(right: 6.h),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imageNotFound,
                  height: 22.h,
                  width: 8.h,
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: 2.h),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgArrowRight,
                  height: 18.h,
                  width: double.maxFinite,
                ),
              ],
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
