import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Added provider import

// Assuming these imports point to valid files in your project structure
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/book_model.dart'; // Assuming this model exists
import 'provider/book_provider.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key}); // Use super.key for constructor

  @override
  BookScreenState createState() => BookScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookProvider(),
      child: const BookScreen(), // Add const
    );
  }
}

class BookScreenState extends State<BookScreen> {
  @override
  void initState() {
    super.initState();
    // Initialization logic can go here
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery for responsive sizing instead of SizeUtils if possible
    // For demonstration, SizeUtils is kept as per the original code
    // final mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: _buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height, // Consider using mediaQueryData.size.height
        decoration: AppDecoration.gradientAmberToRed,
        child: SafeArea(
          child: Container(
            // Avoid fixed heights like 756.h if possible, let content define height
            // margin: EdgeInsets.only(top: 56.h), // SafeArea handles top padding
            child: SingleChildScrollView(
              child: Container(
                // Removed fixed height: height: 756.h,
                padding: EdgeInsets.symmetric(
                  horizontal: 14.h,
                  vertical: 10.h,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // This container seems to be a background element,
                    // consider if it's necessary within the Stack
                    // Container(
                    //   height: 514.h,
                    //   width: 366.h,
                    //   decoration: BoxDecoration(
                    //     color: appTheme.gray5019,
                    //   ),
                    // ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: double.maxFinite,
                        margin:
                            EdgeInsets.only(right: 2.h), // Consider if needed
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRowcontrastone(context),
                            SizedBox(height: 24.h),
                            // Removed outer Container, unnecessary nesting
                            Padding(
                              // Added Padding instead of margin
                              padding: EdgeInsets.only(
                                left: 8.h,
                                right: 4.h,
                              ),
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 100, // High blur values
                                    sigmaY: 100,
                                  ),
                                  child: Container(
                                    width: double.maxFinite,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.h,
                                      vertical: 16.h,
                                    ),
                                    decoration:
                                        AppDecoration.windowsGlassBlur.copyWith(
                                      borderRadius:
                                          BorderRadiusStyle.roundedBorder32,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      // Removed non-standard 'spacing' property
                                      children: [
                                        SizedBox(height: 8.h),
                                        Padding(
                                          // Added Padding instead of margin
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.h),
                                          child: CustomImageView(
                                            imagePath:
                                                ImageConstant.imgMurderexpress1,
                                            height: 174.h,
                                            // width: double.maxFinite, // Often redundant in Column
                                            radius: BorderRadius.circular(16.h),
                                            // margin removed, handled by Padding
                                          ),
                                        ),
                                        SizedBox(height: 10.h), // Added spacing
                                        _buildSettingsone(context),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 56.h),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.h), // Adjusted padding
                              child: Selector<BookProvider,
                                  TextEditingController?>(
                                selector: (context, provider) =>
                                    provider.searchfieldoneController,
                                builder:
                                    (context, searchfieldoneController, child) {
                                  return CustomTextFormField(
                                    controller: searchfieldoneController,
                                    hintText: "lbl_ask_me_anything".tr,
                                    textInputAction: TextInputAction.done,
                                    prefix: Padding(
                                      // Adjusted padding for potentially better spacing
                                      padding: EdgeInsets.only(
                                          left: 15.h, // Rounded value
                                          right: 15.h, // Equal spacing example
                                          top: 10.h,
                                          bottom: 10.h),
                                      child: IntrinsicWidth(
                                        // Ensures Row takes minimum width
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomImageView(
                                              imagePath: ImageConstant.imgMic,
                                              height: 24.h, // Keep height
                                              width: 24
                                                  .h, // Make it square? Or keep original
                                              // Removed complex margin, handled by Padding
                                            ),
                                            SizedBox(width: 8.h), // Spacing
                                            // Consider if this image is just a divider
                                            CustomImageView(
                                              imagePath: ImageConstant
                                                  .imgHighlightFrame,
                                              height:
                                                  24.h, // Match icon height?
                                              width: 2.h, // Thinner divider?
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    prefixConstraints: BoxConstraints(
                                      // Looser constraints might be better
                                      maxHeight: 48.h, // Adjusted
                                    ),
                                    suffix: Padding(
                                      // Added Padding for margin effect
                                      padding: EdgeInsets.only(
                                          right: 4
                                              .h), // Padding outside the InkWell
                                      child: InkWell(
                                        // Make the suffix tappable
                                        onTap: () {
                                          // Add send logic here using searchfieldoneController.text
                                          print(
                                              "Sending: ${searchfieldoneController?.text}");
                                          // Clear field? provider.clearSearch();
                                        },
                                        borderRadius:
                                            BorderRadius.circular(20.h),
                                        child: Container(
                                          padding: EdgeInsets.all(10.h),
                                          // margin: EdgeInsets.only(left: 30.h), // Handled by Padding
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.h),
                                            gradient: LinearGradient(
                                              begin: Alignment(0.5, 1),
                                              end: Alignment(0.5, 0),
                                              colors: [
                                                theme.colorScheme.primary,
                                                // Assuming .withValues was a typo for .withOpacity
                                                theme.colorScheme.primary
                                                    .withOpacity(
                                                        0.5), // Example opacity
                                                // Or maybe just a solid color:
                                                // theme.colorScheme.primary,
                                              ],
                                            ),
                                          ),
                                          child: CustomImageView(
                                            imagePath: ImageConstant
                                                .imgPaperplanefill1,
                                            height: 22.h,
                                            width: 22.h,
                                            fit: BoxFit
                                                .contain, // Keep contain if aspect ratio matters
                                            color: Colors
                                                .white, // Ensure icon visible on gradient
                                          ),
                                        ),
                                      ),
                                    ),
                                    suffixConstraints: BoxConstraints(
                                      maxHeight: 44.h,
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 20.h), // Add bottom padding/space
                          ],
                        ),
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

  /// Section Widget - AppBar
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 44.h, // Provide enough space for padding + icon
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevron,
        margin: EdgeInsets.only(
          left: 16.h, // Standard padding
          top: 16.v,
          bottom: 16.v,
        ),
        onTap: () {
          Navigator.maybePop(context); // Standard back navigation
        },
      ),
      title: AppbarSubtitleOne(
        text: "lbl_little_lifts".tr,
        margin: EdgeInsets.only(left: 10.h),
      ),
    );
  }

  /// Section Widget - Contrast Row (Storytime Mood)
  Widget _buildRowcontrastone(BuildContext context) {
    // Consider using Padding + Card or a simpler Container structure
    return Container(
      // width: 324.h, // Avoid fixed widths, let content or parent define
      padding: EdgeInsets.symmetric(
          horizontal: 12.h, vertical: 8.h), // Added padding
      decoration: AppDecoration.fillIndigo.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder14,
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center, // Let padding handle spacing
        mainAxisSize: MainAxisSize.min, // Take minimum space if centered
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgContrastIndigo50,
            height: 14.h,
            width: 20.h,
            // alignment: Alignment.bottomCenter, // Usually not needed in Row
          ),
          SizedBox(width: 10.h), // Spacing
          // Use Flexible or Expanded if text needs to wrap within available space
          Flexible(
            child: Container(
              // width: 282.h, // Avoid fixed width
              // margin: EdgeInsets.only( // Handled by Row spacing and parent padding
              //   top: 4.h,
              //   bottom: 6.h,
              // ),
              child: Text(
                "msg_storytime_mood".tr,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyles.titleSmallRobotoSecondaryContainer
                    .copyWith(
                  height: 1.47, // Line height
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget - Settings/Book Details (Blurred Card)
  Widget _buildSettingsone(BuildContext context) {
    // This seems identical to the parent blurred container structure.
    // Consider refactoring if it's truly separate content.
    // For now, formatting the inner content.
    return Container(
      // width: double.maxFinite, // Already takes available width from Column
      padding: EdgeInsets.all(12.h), // Adjusted padding
      // Decoration inherited from outer blurred container if nested,
      // or define it here if it's standalone.
      // decoration: AppDecoration.windowsGlassBlur.copyWith(
      //   borderRadius: BorderRadiusStyle.roundedBorder32,
      // ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 2.h),
            child: Text(
              "msg_murder_on_the_orient".tr,
              style: CustomTextStyles.titleLargeRobotoOnPrimarySemiBold,
            ),
          ),
          SizedBox(height: 4.h), // Spacing
          Padding(
            padding: EdgeInsets.only(left: 2.h),
            child: Text(
              "msg_agatha_christie".tr,
              style: CustomTextStyles.labelLargeRobotoOnPrimary13,
            ),
          ),
          SizedBox(height: 12.h), // Spacing
          Padding(
            padding: EdgeInsets.only(left: 2.h),
            child: Text(
              "lbl_about".tr,
              style: CustomTextStyles.labelLargeRobotoOnPrimary13,
            ),
          ),
          SizedBox(height: 4.h), // Spacing
          Padding(
            // Use Padding instead of Container+Stack for layout
            padding: EdgeInsets.only(left: 2.h),
            child: Column(
              // Changed Stack to Column for simpler layout
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "msg_just_after_midnight".tr,
                  // maxLines: 6, // Let it take needed lines or constrain height
                  // overflow: TextOverflow.ellipsis, // Use if height is constrained
                  style: CustomTextStyles.labelMediumRobotoOnPrimarySemiBold
                      .copyWith(
                    height: 1.8, // Adjusted line height
                  ),
                ),
                SizedBox(height: 16.h), // Spacing before buttons
                Row(
                  // Use Row for buttons side-by-side
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Space buttons
                  children: [
                    CustomElevatedButton(
                      height: 42.h,
                      // width: 120.h, // Let button size itself or use Expanded
                      text: "lbl_get_the_book".tr,
                      leftIcon: Container(
                        margin: EdgeInsets.only(right: 8.h),
                        child: CustomImageView(
                          imagePath: ImageConstant.imgUserOnprimary,
                          height: 18.h,
                          width: 20.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                      buttonStyle: CustomButtonStyles.none, // Keep if custom
                      decoration:
                          CustomButtonStyles.gradientPrimaryToPrimaryDecoration,
                      buttonTextStyle: CustomTextStyles.labelSmallRoboto,
                      onPressed: () {
                        // Add action for getting the book
                        print("Get the book tapped");
                      },
                    ),
                    CustomElevatedButton(
                      height: 42.h,
                      // width: 78.h, // Let button size itself
                      text: "lbl_save".tr,
                      // margin: EdgeInsets.only(right: 2.h), // Handled by Row spacing
                      leftIcon: Container(
                        margin: EdgeInsets.only(right: 4.h), // Adjust spacing
                        child: CustomImageView(
                          imagePath: ImageConstant.imgBookmarkOnprimary18x20,
                          height: 18.h,
                          width: 20.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                      buttonStyle: CustomButtonStyles.none,
                      decoration:
                          CustomButtonStyles.gradientPrimaryToPrimaryDecoration,
                      buttonTextStyle:
                          CustomTextStyles.labelMediumRobotoSemiBold,
                      onPressed: () {
                        // Add action for saving
                        print("Save tapped");
                      },
                      // alignment: Alignment.bottomRight, // Handled by Row
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h), // Final spacing at the bottom
        ],
      ),
    );
  }
}
