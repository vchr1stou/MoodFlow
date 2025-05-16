import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/custom_checkbox_button.dart';
import '../../services/auth_service.dart';
import '../../services/auth_persistence_service.dart';
import 'models/login_model.dart';
import 'provider/login_provider.dart';
import '../../providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginProvider(),
      child: LoginScreen(),
    );
  }
}

class LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

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
            // Content
            SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Welcome back to your space.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 96.h),
                        _buildEmailField(),
                        SizedBox(height: 20.h),
                        _buildPasswordField(),
                        SizedBox(height: 12.h),
                        _buildForgotPassword(),
                        SizedBox(height: 12.h),
                        _buildKeepMeSignedIn(context),
                        SizedBox(height: 42.h),
                        _buildSignInButton(),
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

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
            "Email Address",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 12),
        _buildInputField(
          controller: context.read<LoginProvider>().emailController,
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
                  controller: context.read<LoginProvider>().passwordtwoController,
                  obscureText: context.watch<LoginProvider>().isShowPassword,
                  keyboardType: TextInputType.visiblePassword,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: "••••••",
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  validator: (value) {
                    if (value == null || (!isValidPassword(value, isRequired: true))) {
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
                    context.read<LoginProvider>().changePasswordVisibility();
                  },
                  child: Container(
                    width: 30.h,
                    height: 30.h,
                    child: Opacity(
                      opacity: 0.7,
                      child: CustomPaint(
                        painter: EyeIconPainter(
                          isPasswordVisible: context.watch<LoginProvider>().isShowPassword,
                        ),
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
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
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

  Widget _buildForgotPassword() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.forgotPasswordScreen);
      },
      child: Text(
        "Forgot your Password?",
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }

  Widget _buildKeepMeSignedIn(BuildContext context) {
    return Selector<LoginProvider, bool?>(
      selector: (context, provider) => provider.keepmesignedin,
      builder: (context, keepMeSignedIn, child) {
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                context
                    .read<LoginProvider>()
                    .changeCheckBox(!(keepMeSignedIn ?? false));
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 20),
                curve: Curves.easeOut,
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: (keepMeSignedIn ?? false)
                      ? Colors.blue
                      : Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: (keepMeSignedIn ?? false)
                    ? Center(
                        child: Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
            ),
            SizedBox(width: 8),
            Text(
              "Keep me signed in",
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSignInButton() {
    return GestureDetector(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          final email = context.read<LoginProvider>().emailController.text;
          final password = context.read<LoginProvider>().passwordtwoController.text;
          final rememberMe = context.read<LoginProvider>().keepmesignedin;

          try {
            // Attempt to sign in using AuthService
            final user = await _authService.signInWithEmailAndPassword(
              email,
              password,
            );

            if (user != null && context.mounted) {
              // Save credentials if "Remember Me" is checked
              if (rememberMe) {
                await AuthPersistenceService.saveRememberMe(true, email, password);
              } else {
                await AuthPersistenceService.clearSavedCredentials();
              }
              
              await Provider.of<UserProvider>(context, listen: false).fetchUserData(email);
              // Navigate to home screen on success
              Navigator.pushReplacementNamed(context, AppRoutes.homescreenScreen);
            } else if (context.mounted) {
              // Show error if user is null
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to sign in. Please try again.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } catch (e) {
            // Show error message
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.toString()),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 5),
                ),
              );
            }
          }
        }
      },
      child: Container(
        width: 342.h,
        height: 48.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/sign_in.svg',
              width: 342.h,
              height: 48.h,
              fit: BoxFit.contain,
            ),
            Text(
              "Sign In",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
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
      ..strokeWidth = size.width * 0.08;

    // Draw the eye outline with rounded edges
    final path = Path();

    // Starting point
    path.moveTo(size.width * 0.15, size.height * 0.5);

    // Top curve
    path.cubicTo(
      size.width * 0.25, size.height * 0.25,
      size.width * 0.75, size.height * 0.25,
      size.width * 0.85, size.height * 0.5,
    );

    // Bottom curve
    path.cubicTo(
      size.width * 0.75, size.height * 0.75,
      size.width * 0.25, size.height * 0.75,
      size.width * 0.15, size.height * 0.5,
    );

    canvas.drawPath(path, paint);

    // Draw the pupil
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
