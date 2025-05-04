import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/movies_model.dart';
import 'provider/movies_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({Key? key})
      : super(
          key: key,
        );

  @override
  MoviesScreenState createState() => MoviesScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MoviesProvider(),
      child: MoviesScreen(),
    );
  }
}

class MoviesScreenState extends State<MoviesScreen> {
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
            padding: EdgeInsets.only(
              left: 14.h,
              top: 8.h,
              right: 14.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Consumer<MoviesProvider>(
                      builder: (context, provider, child) {
                        return Chat(
                          showUserNames: false,
                          disableImageGallery: false,
                          dateHeaderThreshold: 86400000,
                          messages: provider.messageList!,
                          user: provider.chatUser!,
                          bubbleBuilder: (child,
                              {required message, required nextMessageInGroup}) {
                            return message.author.id == provider.chatUser!.id
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        4.h,
                                      ),
                                    ),
                                    child: child)
                                : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        4.h,
                                      ),
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
                                      horizontal: 12.h,
                                      vertical: 4.h,
                                    ),
                                    decoration: AppDecoration.fillGray.copyWith(
                                      borderRadius:
                                          BorderRadiusStyle.circleBorder18,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                .withValues(
                                              alpha: 1,
                                            ),
                                            height: 1.29,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
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
                SizedBox(height: 58.h)
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
