import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/listtext_item_model.dart';
import 'models/log_input_model.dart';
import 'provider/log_input_provider.dart';
import 'widgets/listtext_item_widget.dart';

class LogInputScreen extends StatefulWidget {
  const LogInputScreen({Key? key}) : super(key: key);

  @override
  LogInputScreenState createState() => LogInputScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogInputProvider(),
      child: LogInputScreen(),
    );
  }
}

class LogInputScreenState extends State<LogInputScreen> {
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
        decoration: AppDecoration.gradientAmberToRed4001,
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 56.h),
            padding: EdgeInsets.only(
              left: 18.h,
              top: 40.h,
              right: 18.h,
            ),
            child: Column(
              spacing: 48,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "msg_let_s_unpack_those".tr,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.headlineMediumSFProOnPrimary
                      .copyWith(height: 1.15),
                ),
                _buildColumntext(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      actions: [
        AppbarTrailingIconbuttonOne(
          imagePath: ImageConstant.imgClose,
          margin: EdgeInsets.only(
            top: 13.h,
            right: 24.h,
            bottom: 13.h,
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildColumntext(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.maxFinite,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(
                horizontal: 12.h,
                vertical: 48.h,
              ),
              decoration: AppDecoration.outline3,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Consumer<LogInputProvider>(
                      builder: (context, provider, child) {
                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 36.h);
                          },
                          itemCount:
                              provider.logInputModelObj.listtextItemList.length,
                          itemBuilder: (context, index) {
                            ListtextItemModel model = provider
                                .logInputModelObj.listtextItemList[index];
                            return ListtextItemWidget(model);
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
