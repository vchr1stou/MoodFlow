import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/logintwo_model.dart';

/// A provider class for the LogintwoScreen.
///
/// This provider manages the state of the LogintwoScreen, including the
/// current logintwoModelObj

// ignore_for_file: must_be_immutable
class LogintwoProvider extends ChangeNotifier {
  TextEditingController nametwoController = TextEditingController();

  TextEditingController emailthreeController = TextEditingController();

  TextEditingController passwordthreeController = TextEditingController();

  TextEditingController confirmpasswordController = TextEditingController();

  LogintwoModel logintwoModelObj = LogintwoModel();

  bool isShowPassword = true;

  bool isShowPassword1 = true;

  @override
  void dispose() {
    super.dispose();
    nametwoController.dispose();
    emailthreeController.dispose();
    passwordthreeController.dispose();
    confirmpasswordController.dispose();
  }

  void changePasswordVisibility() {
    isShowPassword = !isShowPassword;
    notifyListeners();
  }

  void changePasswordVisibility1() {
    isShowPassword1 = !isShowPassword1;
    notifyListeners();
  }
}
