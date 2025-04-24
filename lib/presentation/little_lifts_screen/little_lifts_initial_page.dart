import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:gradient_borders/gradient_borders.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton_two.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/little_lifts_initial_model.dart';
import 'models/little_lifts_item_model.dart';
import 'provider/little_lifts_provider.dart';
import 'widgets/little_lifts_item_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LittleLiftsInitialPage extends StatefulWidget {
  const LittleLiftsInitialPage({Key? key})
      : super(
          key: key,
        );

  @override
  LittleLiftsInitialPageState createState() => LittleLiftsInitialPageState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LittleLiftsProvider(),
      child: LittleLiftsInitialPage(),
    );
  }
}

class LittleLiftsInitialPageState extends State<LittleLiftsInitialPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(top: 38.h),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: _buildAppbar(context),
                  ),
                  _buildRowalertone(context),
                  SizedBox(height: 30.h),
                  _buildLittlelifts(context),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 50.h,
      title: AppbarTitle(
        text: "lbl_little_lifts".tr,
        margin: EdgeInsets.only(left: 28.h),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            // Add your info button action here
          },
          child: Padding(
            padding: EdgeInsets.only(
              top: 6.h,
              right: 22.h,
              bottom: 13.h,
            ),
            child: SvgPicture.asset(
              'assets/images/info.svg',
              width: 30,
              height: 30,
            ),
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildRowalertone(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 50,
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 0,
            child: Container(
              width: 250,
              height: 39,
              child: SvgPicture.asset(
                'assets/images/little_lifts_desc.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            left: 35,
            top: 6,
            child: Text(
              "Tiny acts of care, for wherever you are.",
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 2,
            child: SvgPicture.asset(
              'assets/images/surprise_me.svg',
              fit: BoxFit.contain,
              width: 100,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildLittlelifts(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        child: Consumer<LittleLiftsProvider>(
          builder: (context, provider, child) {
            return ResponsiveGridListBuilder(
              minItemWidth: 1,
              minItemsPerRow: 3,
              maxItemsPerRow: 3,
              horizontalGridSpacing: 24.h,
              verticalGridSpacing: 24.h,
              builder: (context, items) => ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                children: items,
              ),
              gridItems: List.generate(
                provider.littleLiftsInitialModelObj.littleLiftsItemList.length,
                (index) {
                  LittleLiftsItemModel model = provider
                      .littleLiftsInitialModelObj.littleLiftsItemList[index];
                  return LittleLiftsItemWidget(
                    model: model,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
