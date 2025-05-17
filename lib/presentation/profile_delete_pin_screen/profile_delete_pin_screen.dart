import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/profile_delete_pin_model.dart';
import 'provider/profile_delete_pin_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:moodflow/core/utils/size_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileDeletePinScreen extends StatefulWidget {
  const ProfileDeletePinScreen({Key? key}) : super(key: key);

  @override
  ProfileDeletePinScreenState createState() => ProfileDeletePinScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileDeletePinProvider(),
      child: const ProfileDeletePinScreen(),
    );
  }
}

class ProfileDeletePinScreenState extends State<ProfileDeletePinScreen> {
  String pin = '';
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _pinController.addListener(() {
      if (_pinController.text.length > 4) {
        _pinController.text = _pinController.text.substring(0, 4);
      }
      setState(() {
        pin = _pinController.text;
      });
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handlePinConfirmation() async {
    if (pin.length != 4) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.email != null) {
      try {
        // Verify the PIN matches before deleting
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userProvider.email)
            .get();
        
        if (userDoc.exists && userDoc.data()?['pin'] == pin) {
          // PIN matches, delete it
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userProvider.email)
              .update({
            'pinEnabled': false,
            'pin': null,
          });
          
          // Show success message and navigate to profile screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('PIN deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, AppRoutes.profileScreen);
        } else {
          // PIN doesn't match
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Incorrect PIN. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _pinController.clear();
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting PIN: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: SvgPicture.asset(
                      'assets/images/pin_person.svg',
                      width: 86.08,
                      height: 108,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Confirm PIN',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'You have to confirm your PIN',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 23),
                  GestureDetector(
                    onTap: () {
                      _pinFocusNode.requestFocus();
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/pin_input.svg',
                          width: 336,
                          height: 66,
                        ),
                        Container(
                          height: 66,
                          padding: EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  index < _pinController.text.length ? '•' : '_',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        Opacity(
                          opacity: 0,
                          child: TextField(
                            controller: _pinController,
                            focusNode: _pinFocusNode,
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            style: TextStyle(color: Colors.transparent),
                            decoration: InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 23),
                  GestureDetector(
                    onTap: _handlePinConfirmation,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/set_pin_2.svg',
                          width: 183,
                          height: 48,
                        ),
                        Text(
                          'Confirm PIN',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Handles back navigation
  void onTapArrowLeft(BuildContext context) {
    NavigatorService.goBackWithoutContext();
  }
}

