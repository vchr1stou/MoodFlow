import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_trailing_button_one.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/beneathlittlelifts_two_model.dart';
import 'provider/beneathlittlelifts_two_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class BeneathlittleliftsTwoScreen extends StatefulWidget {
  const BeneathlittleliftsTwoScreen({Key? key}) : super(key: key);

  @override
  BeneathlittleliftsTwoScreenState createState() =>
      BeneathlittleliftsTwoScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BeneathlittleliftsTwoProvider(),
      child: BeneathlittleliftsTwoScreen(),
    );
  }
}

class BeneathlittleliftsTwoScreenState
    extends State<BeneathlittleliftsTwoScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: AppDecoration.gradientAmberToRed,
        child: SafeArea(
          child: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Container(
                height: 830.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Selector<BeneathlittleliftsTwoProvider,
                        TextEditingController?>(
                      selector: (context, provider) =>
                          provider.miconeController,
                      builder: (context, miconeController, child) {
                        return CustomTextFormField(
                          controller: miconeController,
                          hintText: "lbl_ask_me_anything".tr(),
                          textInputAction: TextInputAction.done,
                          alignment: Alignment.bottomCenter,
                          prefix: Padding(
                            padding:
                                EdgeInsets.fromLTRB(29.58.h, 30.h, 30.h, 30.h),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgMic,
                                  height: 24.h,
                                  width: 14.83.h,
                                  margin: EdgeInsets.fromLTRB(
                                      29.58.h, 30.h, 14.59.h, 30.h),
                                ),
                                CustomImageView(
                                  imagePath: ImageConstant.imgHighlightFrame,
                                  height: 44.h,
                                  width: 8.h,
                                )
                              ],
                            ),
                          ),
                          prefixConstraints: BoxConstraints(
                            maxHeight: 234.h,
                          ),
                          suffix: Container(
                            padding: EdgeInsets.all(10.h),
                            margin: EdgeInsets.fromLTRB(30.h, 30.h, 14.h, 30.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.h),
                              gradient: LinearGradient(
                                begin: Alignment(0.5, 1),
                                end: Alignment(0.5, 0),
                                colors: [
                                  appTheme.gray700.withAlpha(36),
                                  appTheme.gray700.withAlpha(0),
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
                            maxHeight: 234.h,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 106.h),
                          boxDecoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.5, 0),
                              end: Alignment(0.5, 0.53),
                              colors: [
                                appTheme.black900.withAlpha(25),
                                appTheme.gray70019,
                              ],
                            ),
                          ),
                          borderDecoration:
                              TextFormFieldStyleHelper.gradientBlackToGray,
                          filled: false,
                        );
                      },
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgBoxBlur,
                      height: 158.h,
                      width: double.maxFinite,
                      alignment: Alignment.topCenter,
                    ),
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.only(top: 14.h),
                      decoration: AppDecoration.column12,
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.maxFinite,
                            child: _buildAppbar(context),
                          ),
                          _buildChatmessagelist(context),
                          SizedBox(height: 440.h),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 30.h,
      actions: [
        AppbarTrailingButtonOne(),
        AppbarTrailingIconbuttonOne(
          imagePath: ImageConstant.imgClose,
          margin: EdgeInsets.only(left: 13.h, right: 25.h),
        ),
      ],
    );
  }

  Widget _buildChatmessagelist(BuildContext context) {
    return Container(
      height: 318.h,
      margin: EdgeInsets.only(left: 16.h, right: 26.h),
      width: double.maxFinite,
      child: Consumer<BeneathlittleliftsTwoProvider>(
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
              return textMessage.author.id == provider.chatUser!.id
                  ? SizedBox(
                      height: 80.h,
                      width: 264.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            textMessage.text,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: CustomTextStyles
                                .labelLargeRobotoOnPrimaryContainer
                                .copyWith(
                              color: theme.colorScheme.onPrimaryContainer
                                  .withAlpha(230),
                              height: 1.25,
                            ),
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgUser,
                            height: 16.h,
                            width: 18.h,
                            alignment: Alignment.bottomRight,
                          )
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 50.h,
                      width: 282.h,
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
                            margin: EdgeInsets.only(left: 4.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.h, vertical: 6.h),
                            decoration: AppDecoration.fillGray.copyWith(
                              borderRadius: BorderRadiusStyle.circleBorder22,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 2.h),
                                Text(
                                  textMessage.text,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: CustomTextStyles
                                      .labelLargeRobotoGray800
                                      .copyWith(
                                    color: appTheme.gray800,
                                    height: 1.25,
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
    );
  }
}
