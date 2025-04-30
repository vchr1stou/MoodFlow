import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/sign_up_step_one_model.dart';

/// A provider class for the SignUpStepOneScreen.
///
/// This provider manages the state of the SignUpStepOneScreen,
/// including the current signUpStepOneModelObj.
// ignore_for_file: must_be_immutable
class SignUpStepOneProvider extends ChangeNotifier {
  // Controllers for form input fields
  TextEditingController nametwoController = TextEditingController();
  TextEditingController emailtwoController = TextEditingController();
  TextEditingController passwordtwoController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController pronounsController = TextEditingController();

  // Model object for this screen
  SignUpStepOneModel signUpStepOneModelObj = SignUpStepOneModel();

  // Password visibility toggles
  bool isShowPassword = true;
  bool isShowPassword1 = true;

  // Clean up controllers
  @override
  void dispose() {
    nametwoController.dispose();
    emailtwoController.dispose();
    passwordtwoController.dispose();
    confirmpasswordController.dispose();
    pronounsController.dispose();
    super.dispose();
  }

  // Toggle visibility for password field
  void changePasswordVisibility() {
    isShowPassword = !isShowPassword;
    notifyListeners();
  }

  // Toggle visibility for confirm password field
  void changePasswordVisibility1() {
    isShowPassword1 = !isShowPassword1;
    notifyListeners();
  }
}
