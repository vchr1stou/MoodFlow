import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_checkbox_button.dart';
import '../../widgets/custom_drop_down.dart';
import 'models/saved_model.dart';
import 'models/saved_one_item_model.dart';
import 'provider/saved_provider.dart';
import 'widgets/saved_one_item_widget.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  SavedScreenState createState() => SavedScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SavedProvider(),
      child: const SavedScreen(),
    );
  }
}

class SavedScreenState extends State<SavedScreen> {
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
          child: Padding(
            padding: EdgeInsets.only(top: 44.h, left: 14.h, right: 14.h),
            child: Column(
              children: [
                _buildHeaderRow(context),
                SizedBox(height: 24.h),
                Expanded(child: _buildSavedList(context)),
                SizedBox(height: 38.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// AppBar Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 44.h,
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

  /// Title + Dropdown Row
  Widget _buildHeaderRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "lbl_saved".tr,
            style: theme.textTheme.displaySmall,
          ),
        ),
        Selector<SavedProvider, SavedModel?>(
          selector: (context, provider) => provider.savedModelObj,
          builder: (context, savedModelObj, child) {
            return CustomDropDown(
              width: 66.h,
              icon: Padding(
                padding: EdgeInsets.only(left: 4.h),
                child: CustomImageView(
                  imagePath: ImageConstant.imgDropDownMenuIndicator,
                  height: 16.h,
                  width: 14.h,
                  fit: BoxFit.contain,
                ),
              ),
              iconSize: 16.h,
              hintText: "lbl_all".tr,
              items: savedModelObj?.dropdownItemList ?? [],
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 14.h, vertical: 6.h),
              onChanged: (value) {
                context.read<SavedProvider>().onSelected(value);
              },
            );
          },
        )
      ],
    );
  }

  /// Saved List Section
  Widget _buildSavedList(BuildContext context) {
    return Consumer<SavedProvider>(
      builder: (context, provider, child) {
        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              decoration: AppDecoration.outline12,
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: ListView.separated(
                padding: EdgeInsets.only(left: 8.h, right: 6.h),
                physics: BouncingScrollPhysics(),
                itemCount: provider.savedModelObj.savedOneItemList.length,
                separatorBuilder: (context, index) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final model = provider.savedModelObj.savedOneItemList[index];
                  return SavedOneItemWidget(model);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
