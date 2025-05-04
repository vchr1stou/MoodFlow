import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/custom_elevated_button.dart';
import 'models/workout_model.dart';
import 'provider/workout_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkoutProvider(),
      child: const WorkoutScreen(),
    );
  }

  @override
  WorkoutScreenState createState() => WorkoutScreenState();
}

class WorkoutScreenState extends State<WorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.primary,
        appBar: _buildAppBar(context),
        body: SizedBox(
          width: SizeUtils.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 24.v),
            child: Padding(
              padding: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 5.v),
              child: Column(
                children: [
                  _buildWorkoutType(context, workoutProvider),
                  SizedBox(height: 24.v),
                  _buildWorkoutDuration(context, workoutProvider),
                  SizedBox(height: 24.v),
                  _buildWorkoutIntensity(context, workoutProvider),
                  SizedBox(height: 24.v),
                  _buildWorkoutNotes(context, workoutProvider),
                  SizedBox(height: 24.v),
                  _buildSaveButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(left: 16.h, top: 16.v, bottom: 16.v),
        onTap: () {
          onTapArrowLeft(context);
        },
      ),
      title: AppbarSubtitleOne(
        text: "lbl_workout".tr(),
        margin: EdgeInsets.only(left: 8.h),
      ),
    );
  }

  Widget _buildWorkoutType(BuildContext context, WorkoutProvider workoutProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "lbl_workout_type".tr(),
          style: theme.textTheme.titleMedium,
        ),
        SizedBox(height: 8.v),
        CustomDropDown(
          icon: Container(
            margin: EdgeInsets.fromLTRB(30.h, 12.v, 12.h, 12.v),
            child: CustomImageView(
              imagePath: ImageConstant.imgArrowDown,
              height: 24.v,
              width: 24.v,
            ),
          ),
          hintText: "lbl_select_type".tr(),
          items: workoutProvider.workoutModelObj.workoutTypeItems,
          onChanged: (value) {
            workoutProvider.workoutModelObj.workoutType = value;
            workoutProvider.notifyListeners();
          },
        ),
      ],
    );
  }

  Widget _buildWorkoutDuration(BuildContext context, WorkoutProvider workoutProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "lbl_duration".tr(),
          style: theme.textTheme.titleMedium,
        ),
        SizedBox(height: 8.v),
        CustomTextFormField(
          controller: workoutProvider.workoutModelObj.durationController,
          hintText: "lbl_enter_duration".tr(),
          textInputType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildWorkoutIntensity(BuildContext context, WorkoutProvider workoutProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "lbl_intensity".tr(),
          style: theme.textTheme.titleMedium,
        ),
        SizedBox(height: 8.v),
        CustomDropDown(
          icon: Container(
            margin: EdgeInsets.fromLTRB(30.h, 12.v, 12.h, 12.v),
            child: CustomImageView(
              imagePath: ImageConstant.imgArrowDown,
              height: 24.v,
              width: 24.v,
            ),
          ),
          hintText: "lbl_select_intensity".tr(),
          items: workoutProvider.workoutModelObj.intensityItems,
          onChanged: (value) {
            workoutProvider.workoutModelObj.intensity = value;
            workoutProvider.notifyListeners();
          },
        ),
      ],
    );
  }

  Widget _buildWorkoutNotes(BuildContext context, WorkoutProvider workoutProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "lbl_notes".tr(),
          style: theme.textTheme.titleMedium,
        ),
        SizedBox(height: 8.v),
        CustomTextFormField(
          controller: workoutProvider.workoutModelObj.notesController,
          hintText: "lbl_enter_notes".tr(),
          textInputAction: TextInputAction.done,
          maxLines: 5,
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return CustomElevatedButton(
      text: "lbl_save".tr(),
      onPressed: () {
        onTapSave(context);
      },
    );
  }

  void onTapArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }

  void onTapSave(BuildContext context) {
    // TODO: Implement save functionality
  }
}
