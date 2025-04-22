import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Added provider import

// Assuming these imports point to valid files in your project structure
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/breathingdone_model.dart';
import 'provider/breathingdone_provider.dart';

class BreathingdoneScreen extends StatefulWidget {
  const BreathingdoneScreen({super.key}); // Use super.key

  @override
  BreathingdoneScreenState createState() => BreathingdoneScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BreathingdoneProvider(),
      child: const BreathingdoneScreen(), // Add const
    );
  }
}

class BreathingdoneScreenState extends State<BreathingdoneScreen> {
  @override
  void initState() {
    super.initState();
    // Initialization logic if needed
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery for responsive sizing instead of SizeUtils if preferred
    // final mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height, // Consider using mediaQueryData.size.height
        decoration:
            AppDecoration.gradientAmberToRed4001, // Keep custom gradient
        child: SafeArea(
          child: Container(
            width: double.maxFinite, // Ensure container takes full width
            // Padding seems large, adjust if needed.
            // symmetric padding pushes content away from top and bottom edges.
            padding: EdgeInsets.symmetric(
                horizontal: 24.h, vertical: 40.h), // Adjusted padding example
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center content vertically
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center content horizontally
              children: [
                const Spacer(flex: 2), // Pushes content down more

                CustomImageView(
                  imagePath: ImageConstant.imgScreenshot20250329,
                  height: 160.adaptSize, // Use adaptSize for responsive scaling
                  width: 160.adaptSize, // Make it square or adjust as needed
                ),
                SizedBox(height: 32.v), // Spacing

                Text(
                  "lbl_well_done".tr,
                  style: CustomTextStyles.displayMediumSemiBold,
                ),
                SizedBox(height: 8.v), // Spacing

                Text(
                  "msg_the_world_can_wait".tr,
                  style: CustomTextStyles.titleLargeRobotoOnPrimarySemiBold_1,
                ),

                const Spacer(
                    flex:
                        3), // Pushes button down, takes more space than top spacer

                CustomOutlinedButton(
                  height: 48.v, // Slightly larger touch target?
                  // width: 150.h, // Let button size to text or set a minWidth?
                  text: "lbl_return".tr,
                  margin: EdgeInsets.symmetric(
                      horizontal: 60.h), // Add horizontal margin if needed
                  buttonStyle: CustomButtonStyles
                      .outlineTL18, // Use defined style directly if possible
                  // decoration: CustomButtonStyles.outlineTL18Decoration, // Decoration might be redundant if defined in buttonStyle
                  buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
                  onPressed: () {
                    // Add navigation logic, e.g., go back
                    Navigator.maybePop(context);
                  },
                ),
                const Spacer(flex: 1), // Add some space at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
