import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/positiveaffirmations_model.dart';
import 'provider/positiveaffirmations_provider.dart';

class PositiveaffirmationsScreen extends StatefulWidget {
  const PositiveaffirmationsScreen({Key? key}) : super(key: key);

  @override
  PositiveaffirmationsScreenState createState() =>
      PositiveaffirmationsScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PositiveaffirmationsProvider(),
      child: PositiveaffirmationsScreen(),
    );
  }
}

class PositiveaffirmationsScreenState
    extends State<PositiveaffirmationsScreen> {
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
            padding: EdgeInsets.symmetric(
              horizontal: 14.h,
              vertical: 8.h,
            ),
            child: Column(
              children: [
                _buildChatmessagelist(context),
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.h),
                  child: Selector<PositiveaffirmationsProvider,
                      TextEditingController?>(
                    selector: (context, provider) =>
                        provider.searchfieldoneController,
                    builder: (context, searchfieldoneController, child) {
                      return CustomTextFormField(
                        controller: searchfieldoneController,
                        hintText: "lbl_ask_me_anything".tr,
                        textInputAction: TextInputAction.done,
                        prefix: Padding(
                          padding: EdgeInsets.only(
                            left: 14.580002.h,
                            right: 30.h,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomImageView(
                                imagePath: ImageConstant.imgMic,
                                height: 24.h,
                                width: 14.83.h,
                                margin: EdgeInsets.fromLTRB(
                                  14.580002.h,
                                  9.48999.h,
                                  14.589996.h,
                                  10.51001.h,
                                ),
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.imgHighlightFrame,
                                height: 44.h,
                                width: 8.h,
                              ),
                            ],
                          ),
                        ),
                        prefixConstraints: BoxConstraints(
                          maxHeight: 44.h,
                        ),
                        suffix: Container(
                          padding: EdgeInsets.all(10.h),
                          margin: EdgeInsets.only(left: 30.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.h),
                            gradient: LinearGradient(
                              begin: Alignment(0.5, 1),
                              end: Alignment(0.5, 0),
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.primary.withValues(
                                  alpha: 0,
                                ),
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
                        suffixConstraints: BoxConstraints(
                          maxHeight: 44.h,
                        ),
                      );
                    },
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

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 20.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevron,
        margin: EdgeInsets.only(left: 8.h),
      ),
      title: AppbarSubtitleOne(
        text: "lbl_activities".tr,
        margin: EdgeInsets.only(left: 10.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildChatmessagelist(BuildContext context) {
    return Container(
      height: 160.h,
      margin: EdgeInsets.only(right: 2.h),
      width: double.maxFinite,
      child: Consumer<PositiveaffirmationsProvider>(
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
                        horizontal: 12.h,
                        vertical: 4.h,
                      ),
                      decoration: AppDecoration.fillGray.copyWith(
                        borderRadius: BorderRadiusStyle.circleBorder18,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            textMessage.text.toString(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: CustomTextStyles
                                .titleMediumSecondaryContainer
                                .copyWith(
                              color: theme.colorScheme.secondaryContainer
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
    );
  }
}
