import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 12),
        _buildInputField(
          controller: context.read<LoginProvider>().passwordtwoController,
          hintText: "••••••",
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          validator: (value) {
            if (value == null || (!isValidPassword(value, isRequired: true))) {
              return "Please enter a valid password";
            }
            return null;
          },
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
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white.withOpacity(0.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
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
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            validator: validator,
          ),
        ),
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
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final email =
                    context.read<LoginProvider>().emailController.text;
                final password =
                    context.read<LoginProvider>().passwordtwoController.text;
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
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.homescreenScreen);
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
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.h),
              ),
            ),
            child: Text(
              "Sign in",
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
