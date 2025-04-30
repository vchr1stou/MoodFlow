import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/sign_up_step_one_model.dart';
import 'provider/sign_up_step_one_provider.dart';

class SignUpStepOneScreen extends StatefulWidget {
  const SignUpStepOneScreen({Key? key}) : super(key: key);

  @override
  SignUpStepOneScreenState createState() => SignUpStepOneScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpStepOneProvider(),
      child: SignUpStepOneScreen(),
    );
  }
}

// ignore_for_file: must_be_immutable
class SignUpStepOneScreenState extends State<SignUpStepOneScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Background blur overlay
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  color: Color(0xFFBCBCBC).withOpacity(0.04),
                ),
              ),
            ),
            // Top blur box
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 200.h,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Color(0xFFBCBCBC).withOpacity(0.04),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        Center(
                          child: Text(
                            "We're glad you're here",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Center(
                          child: Text(
                            "Let's set up your space",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                        SizedBox(height: 40.h),
                        _buildNameField(),
                        SizedBox(height: 20.h),
                        _buildPronounsField(),
                        SizedBox(height: 20.h),
                        _buildEmailField(),
                        SizedBox(height: 20.h),
                        _buildPasswordField(),
                        SizedBox(height: 20.h),
                        _buildConfirmPasswordField(),
                        SizedBox(height: 40.h),
                        _buildNextButton(),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 40,
      leading: Align(
        alignment: Alignment.centerLeft,
        child: _buildBackButton(),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(AppRoutes.welcomeScreen);
      },
      child: Padding(
        padding: EdgeInsets.only(left: 12.h),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            Positioned(
              child: Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
            "Name",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 12),
        _buildInputField(
          controller: context.read<SignUpStepOneProvider>().nametwoController,
          hintText: "John Appleseed",
        ),
      ],
    );
  }

  Widget _buildPronounsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
            "Pronouns",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 12),
        _buildInputField(
          controller: context.read<SignUpStepOneProvider>().pronounsController,
          hintText: "Select your pronouns",
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
            "Email Address",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 12),
        _buildInputField(
          controller: context.read<SignUpStepOneProvider>().emailtwoController,
          hintText: "johnappleseed@example.com",
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || (!isValidEmail(value, isRequired: true))) {
              return "Please enter a valid email address";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
            "Password",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 12),
        Container(
          width: 339.h,
          height: 44.h,
          child: Stack(
            children: [
              // Text box SVG
              IgnorePointer(
                child: SvgPicture.asset(
                  'assets/images/text_box.svg',
                  width: 339.h,
                  height: 44.h,
                  fit: BoxFit.fill,
                ),
              ),
              // Text field on top
              Positioned(
                left: 20.h,
                top: -2.5.h,
                right: 50.h,
                bottom: 10.h,
                child: TextFormField(
                  controller: context
                      .read<SignUpStepOneProvider>()
                      .passwordtwoController,
                  obscureText:
                      context.watch<SignUpStepOneProvider>().isShowPassword,
                  keyboardType: TextInputType.visiblePassword,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: "••••••",
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  validator: (value) {
                    if (value == null ||
                        (!isValidPassword(value, isRequired: true))) {
                      return "Please enter a valid password";
                    }
                    return null;
                  },
                ),
              ),
              // Eye icon
              Positioned(
                right: 12.h,
                top: 8.h,
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<SignUpStepOneProvider>()
                        .changePasswordVisibility();
                  },
                  child: Container(
                    width: 30.h,
                    height: 30.h,
                    child: CustomPaint(
                      painter: EyeIconPainter(
                        isPasswordVisible: context
                            .watch<SignUpStepOneProvider>()
                            .isShowPassword,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
            "Confirm Password",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 12),
        Container(
          width: 339.h,
          height: 44.h,
          child: Stack(
            children: [
              // Text box SVG
              IgnorePointer(
                child: SvgPicture.asset(
                  'assets/images/text_box.svg',
                  width: 339.h,
                  height: 44.h,
                  fit: BoxFit.fill,
                ),
              ),
              // Text field on top
              Positioned(
                left: 20.h,
                top: -2.5.h,
                right: 50.h,
                bottom: 10.h,
                child: TextFormField(
                  controller: context
                      .read<SignUpStepOneProvider>()
                      .confirmpasswordController,
                  obscureText:
                      context.watch<SignUpStepOneProvider>().isShowPassword1,
                  keyboardType: TextInputType.visiblePassword,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: "••••••",
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password";
                    }
                    if (value !=
                        context
                            .read<SignUpStepOneProvider>()
                            .passwordtwoController
                            .text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
              ),
              // Eye icon
              Positioned(
                right: 12.h,
                top: 8.h,
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<SignUpStepOneProvider>()
                        .changePasswordVisibility1();
                  },
                  child: Container(
                    width: 30.h,
                    height: 30.h,
                    child: CustomPaint(
                      painter: EyeIconPainter(
                        isPasswordVisible: context
                            .watch<SignUpStepOneProvider>()
                            .isShowPassword1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController? controller,
    required String hintText,
    bool obscureText = false,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
  }) {
    return Container(
      width: 339.h,
      height: 44.h,
      child: Stack(
        children: [
          // Text box SVG
          IgnorePointer(
            child: SvgPicture.asset(
              'assets/images/text_box.svg',
              width: 339.h,
              height: 44.h,
              fit: BoxFit.fill,
            ),
          ),
          // Text field on top
          Positioned(
            left: 20.h,
            top: -2.5.h,
            right: 30.h,
            bottom: 10.h,
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.h),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(24.h),
          ),
          child: TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Handle next step
              }
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.h),
              ),
            ),
            child: Text(
              "Next",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EyeIconPainter extends CustomPainter {
  final bool isPasswordVisible;

  EyeIconPainter({this.isPasswordVisible = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08; // Thicker stroke

    // Draw the eye outline with rounded edges
    final path = Path();

    // Starting point
    path.moveTo(size.width * 0.15, size.height * 0.5);

    // Top curve
    path.cubicTo(
      size.width * 0.25, size.height * 0.25, // First control point
      size.width * 0.75, size.height * 0.25, // Second control point
      size.width * 0.85, size.height * 0.5, // End point
    );

    // Bottom curve
    path.cubicTo(
      size.width * 0.75, size.height * 0.75, // First control point
      size.width * 0.25, size.height * 0.75, // Second control point
      size.width * 0.15, size.height * 0.5, // End point
    );

    canvas.drawPath(path, paint);

    // Draw the pupil (as a ring instead of filled circle)
    final pupilPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08;

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.15,
      pupilPaint,
    );

    // Draw the diagonal line when password is visible
    if (isPasswordVisible) {
      final crossPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.08;

      canvas.drawLine(
        Offset(size.width * 0.15, size.height * 0.15),
        Offset(size.width * 0.85, size.height * 0.85),
        crossPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant EyeIconPainter oldDelegate) =>
      oldDelegate.isPasswordVisible != isPasswordVisible;
}
