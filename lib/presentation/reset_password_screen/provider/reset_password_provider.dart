import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/reset_password_model.dart';

/// A provider class for the ResetPasswordScreen.
///
/// This provider manages the state of the ResetPasswordScreen,
/// including the current resetPasswordModelObj.
// ignore_for_file: must_be_immutable
class ResetPasswordProvider extends ChangeNotifier {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newPasswordOneController = TextEditingController();

  ResetPasswordModel resetPasswordModelObj = ResetPasswordModel();

  @override
  void dispose() {
    newPasswordController.dispose();
    newPasswordOneController.dispose();
    super.dispose();
  }
}
