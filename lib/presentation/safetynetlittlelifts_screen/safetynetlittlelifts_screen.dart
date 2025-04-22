import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/listmum_one_item_model.dart';
import 'models/safetynetlittlelifts_model.dart';
import 'provider/safetynetlittlelifts_provider.dart';
import 'widgets/listmum_one_item_widget.dart';

class SafetynetlittleliftsScreen extends StatefulWidget {
  const SafetynetlittleliftsScreen({Key? key}) : super(key: key);

  @override
  SafetynetlittleliftsScreenState createState() =>
      SafetynetlittleliftsScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SafetynetlittleliftsProvider(),
      child: const SafetynetlittleliftsScreen(),
    );
  }
}

class SafetynetlittleliftsScreenState
    extends State<SafetynetlittleliftsScreen> {
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
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 56.h),
              padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuoteCard(context),
                  SizedBox(height: 24.h),
                  _buildContactsList(context),
                  SizedBox(height: 134.h),
                  _buildSearchField(context),
                  SizedBox(height: 56.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// AppBar section
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 20.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevron,
        margin: EdgeInsets.only(left: 8.h),
      ),
      title: AppbarSubtitleOne(
        text: "lbl_little_lifts".tr,
        margin: EdgeInsets.only(left: 10.h),
      ),
    );
  }

  /// Quote card section
  Widget _buildQuoteCard(BuildContext context) {
    return Container(
      width: 324.h,
      decoration: AppDecoration.fillIndigo.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder14,
      ),
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgContrastIndigo50,
            height: 14.h,
            width: 20.h,
            alignment: Alignment.bottomCenter,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.h),
              child: Text(
                "msg_sometimes_all_you".tr,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyles.titleMediumSecondaryContainer.copyWith(
                  height: 1.29,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Contacts list section
  Widget _buildContactsList(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.h),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            decoration: AppDecoration.outline12,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.h, vertical: 32.h),
                  decoration: AppDecoration.windowsGlassBlur.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder32,
                  ),
                  child: Consumer<SafetynetlittleliftsProvider>(
                    builder: (context, provider, child) {
                      final contactList = provider
                          .safetynetlittleliftsModelObj.listmumOneItemList;
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: contactList.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16.h),
                        itemBuilder: (context, index) {
                          return ListmumOneItemWidget(contactList[index]);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Search field section
  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.h),
      child: Selector<SafetynetlittleliftsProvider, TextEditingController?>(
        selector: (context, provider) => provider.searchfieldoneController,
        builder: (context, controller, child) {
          return CustomTextFormField(
            controller: controller,
            hintText: "lbl_ask_me_anything".tr,
            textInputAction: TextInputAction.done,
            prefix: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.57.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgMic,
                    height: 24.h,
                    width: 14.84.h,
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgHighlightFrame,
                    height: 44.h,
                    width: 8.h,
                  ),
                ],
              ),
            ),
            prefixConstraints: BoxConstraints(maxHeight: 44.h),
            suffix: Container(
              margin: EdgeInsets.only(left: 30.h, right: 2.h),
              padding: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.h),
                gradient: LinearGradient(
                  begin: Alignment(0.5, 1),
                  end: Alignment(0.5, 0),
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withAlpha(0),
                  ],
                ),
              ),
              child: CustomImageView(
                imagePath: ImageConstant.imgPaperplanefill1,
                height: 22.h,
                width: 22.h,
                fit: BoxFit.contain,
              ),
            ),
            suffixConstraints: BoxConstraints(maxHeight: 44.h),
          );
        },
      ),
    );
  }
}
