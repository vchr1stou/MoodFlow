import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/traveling_model.dart';
import 'provider/traveling_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class TravelingScreen extends StatefulWidget {
  const TravelingScreen({Key? key}) : super(key: key);

  @override
  TravelingScreenState createState() => TravelingScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TravelingProvider(),
      child: TravelingScreen(),
    );
  }
}

class TravelingScreenState extends State<TravelingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: AppDecoration.gradientAmberToRed,
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 56.h),
            padding: EdgeInsets.only(left: 14.h, top: 8.h, right: 14.h),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(right: 2.h),
                    child: Consumer<TravelingProvider>(
                      builder: (context, provider, child) {
                        return Chat(
                          showUserNames: false,
                          disableImageGallery: false,
                          dateHeaderThreshold: 86400000,
                          messages: provider.messageList!,
                          user: provider.chatUser!,
                          bubbleBuilder: (child,
                              {required message, required nextMessageInGroup}) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.h),
                              ),
                              child: child,
                            );
                          },
                          textMessageBuilder: (textMessage,
                              {required messageWidth, required showName}) {
                            return SizedBox(
                              height: 80.h,
                              width: 278.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant.imgBookmark,
                                    height: 16.h,
                                    width: 18.h,
                                    alignment: Alignment.bottomLeft,
                                  ),
                                  Container(
                                    width: double.maxFinite,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.h, vertical: 4.h),
                                    decoration: AppDecoration.fillGray.copyWith(
                                      borderRadius:
                                          BorderRadiusStyle.circleBorder18,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          textMessage.text.toString(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: CustomTextStyles
                                              .titleMediumSecondaryContainer
                                              .copyWith(
                                            color: theme
                                                .colorScheme.secondaryContainer
                                                .withValues(alpha: 1),
                                            height: 1.29,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          onSendPressed: (types.PartialText text) {},
                          customStatusBuilder: (message, {required context}) {
                            return Container();
                          },
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 58.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 20.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevron,
        margin: EdgeInsets.only(left: 8.h),
      ),
      title: AppbarSubtitleOne(
        text: "lbl_little_lifts".tr(),
        margin: EdgeInsets.only(left: 10.h),
      ),
    );
  }
}
