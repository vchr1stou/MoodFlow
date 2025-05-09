import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/size_utils.dart';
import '../log_screen/log_screen.dart';

class LogScreenStep3PositiveScreen extends StatefulWidget {
  const LogScreenStep3PositiveScreen({Key? key}) : super(key: key);

  @override
  State<LogScreenStep3PositiveScreen> createState() => _LogScreenStep3PositiveScreenState();
}

class _LogScreenStep3PositiveScreenState extends State<LogScreenStep3PositiveScreen> {
  List<String> selectedFeelings = [];
  Map<String, double> intensities = {};

  @override
  void initState() {
    super.initState();
    _loadSavedFeelings();
  }

  Future<void> _loadSavedFeelings() async {
    final savedFeelings = StorageService.getPositiveFeelings();
    final savedIntensities = StorageService.getPositiveIntensities();
    
    setState(() {
      selectedFeelings = savedFeelings;
      intensities = savedIntensities;
    });
  }

  void _onIntensityChanged(String feeling, double value) {
    setState(() {
      intensities[feeling] = value;
    });
    StorageService.savePositiveIntensities(intensities);
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Replace with your existing build implementation
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 200.h,
      leading: Row(
        children: [
          GestureDetector(
            onTap: () async {
              // Clear all saved data before navigating
              await StorageService.clearAll();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LogScreen.builder(
                    context,
                    feeling: "Bright 😊",
                  ),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(left: 16.h, top: 10.h),
              child: SvgPicture.asset(
                'assets/images/back_log.svg',
                width: 27.h,
                height: 27.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 