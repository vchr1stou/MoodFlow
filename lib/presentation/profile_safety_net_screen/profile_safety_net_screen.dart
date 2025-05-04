import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/listmum_one_item_model.dart';
import 'models/profile_safety_net_model.dart';
import 'provider/profile_safety_net_provider.dart';
import 'widgets/listmum_one_item_widget.dart';

class ProfileSafetyNetScreen extends StatefulWidget {
  const ProfileSafetyNetScreen({Key? key}) : super(key: key);

  @override
  ProfileSafetyNetScreenState createState() => ProfileSafetyNetScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileSafetyNetProvider(),
      child: ProfileSafetyNetScreen(),
    );
  }
}

class ProfileSafetyNetScreenState extends State<ProfileSafetyNetScreen> {
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
              padding: EdgeInsets.only(top: 26.h),
              decoration:
                  AppDecoration.forBackgroundpinkyellowbggradient.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAppbar(context),
                  SizedBox(height: 16.h),
                  CustomImageView(
                    imagePath: ImageConstant.imgGroupOnprimary,
                    height: 84.h,
                    width: 154.h,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Your Safety Net",
                    style: theme.textTheme.headlineLarge,
                  ),
                  SizedBox(height: 24.h),
                  _buildColumnMumOne(context),
                  SizedBox(height: 30.h),
                  CustomOutlinedButton(
                    text: AppStrings.addAnotherTrusted,
                    margin: EdgeInsets.symmetric(horizontal: 84.h),
                    buttonStyle: CustomButtonStyles.none,
                    decoration: CustomButtonStyles.outlineTL241Decoration,
                  ),
                  SizedBox(height: 180.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// App bar with back button
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 30.h,
      leadingWidth: 46.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () => onTapArrowLeft(context),
      ),
    );
  }

  /// Safety contacts container with list
  Widget _buildColumnMumOne(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.h),
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 14.h),
      decoration: AppDecoration.windowsGlass.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<ProfileSafetyNetProvider>(
            builder: (context, provider, child) {
              return ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                    provider.profileSafetyNetModelObj.listmumOneItemList.length,
                itemBuilder: (context, index) {
                  ListmumOneItemModel model = provider
                      .profileSafetyNetModelObj.listmumOneItemList[index];
                  return ListmumOneItemWidget(model);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// Back button navigation
  void onTapArrowLeft(BuildContext context) {
    NavigatorService.goBackWithoutContext();
  }
}
