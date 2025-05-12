import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_switch.dart';
import 'models/sign_up_step_two_model.dart';
import 'provider/sign_up_step_two_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/sign_up_provider.dart';

class SignUpStepTwoScreen extends StatefulWidget {
  const SignUpStepTwoScreen({Key? key}) : super(key: key);

  @override
  SignUpStepTwoScreenState createState() => SignUpStepTwoScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpStepTwoProvider(),
      child: const SignUpStepTwoScreen(),
    );
  }
}

// ignore_for_file: must_be_immutable
class SignUpStepTwoScreenState extends State<SignUpStepTwoScreen> {
  bool _dailyCheckInEnabled = true;
  bool _quoteEnabled = true;
  TimeOfDay _quoteTime = const TimeOfDay(hour: 9, minute: 30);
  bool _isAddingReminder = false;
  
  // Top positions for each time slot
  double _firstTimeTop = 20.h;
  double _secondTimeTop = 80.h;
  double _thirdTimeTop = 140.h;
  double _fourthTimeTop = 200.h;

  void _updateTimePositions(double first, double second, double third, double fourth) {
    setState(() {
      _firstTimeTop = first;
      _secondTimeTop = second;
      _thirdTimeTop = third;
      _fourthTimeTop = fourth;
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize positions
    _updateTimePositions(20.h, 80.h, 140.h, 200.h);
  }

  Future<void> _selectTime(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Color(0xFFBCBCBC).withOpacity(0.04),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 44,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text(
                            'Done',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 250,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        initialDateTime: DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          _quoteTime.hour,
                          _quoteTime.minute,
                        ),
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newDateTime) {
                          setState(() {
                            _quoteTime = TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);
                            _isAddingReminder = false;
                          });
                        },
                      ),
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

  Future<void> _selectDailyTime(BuildContext context, int index) async {
    final provider = Provider.of<SignUpStepTwoProvider>(context, listen: false);
    if (index < 0 || index >= provider.dailyCheckInTimes.length) {
      return;
    }

    TimeOfDay? selectedTime;
    
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Color(0xFFBCBCBC).withOpacity(0.04),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 44,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text(
                            'Done',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 250,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        initialDateTime: DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          provider.dailyCheckInTimes[index].hour,
                          provider.dailyCheckInTimes[index].minute,
                        ),
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newDateTime) {
                          selectedTime = TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // Always update the time when the picker is closed
    if (selectedTime != null) {
      provider.updateDailyCheckInTime(index, selectedTime!);
    } else {
      // If no time was selected, use the initial time
      provider.updateDailyCheckInTime(
        index,
        TimeOfDay(
          hour: provider.dailyCheckInTimes[index].hour,
          minute: provider.dailyCheckInTimes[index].minute,
        ),
      );
    }
    
    // Update the reminder state
    if (!provider.isAddingDailyReminders[index]) {
      provider.toggleAddingReminder(index, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpStepTwoProvider>(
      builder: (context, provider, child) {
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
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.h, left: 24.h, right: 24.h),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h),
                          Center(
                            child: Text(
                              "Gentle Reminders",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Roboto',
                                letterSpacing: -1,
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Center(
                            child: Text(
                              "We'll nudge you with two simple things:",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Roboto',
                                letterSpacing: -1,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            "📝 A daily check-in to reflect on your mood",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              letterSpacing: -1,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "💬 A quote of the day to lift or ground your thoughts",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              letterSpacing: -1,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Column(
                            children: [
                              Container(
                                width: 340.h,
                                height: _dailyCheckInEnabled ? 283.h : 79.h,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      _dailyCheckInEnabled 
                                        ? 'assets/images/daily_checkin.svg'
                                        : 'assets/images/daily_toggle_off.svg',
                                      width: 340.h,
                                      height: _dailyCheckInEnabled ? 283.h : 79.h,
                                    ),
                                    Positioned(
                                      top: 12.h,
                                      left: 0,
                                      right: 0,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/daily_toggle.svg',
                                          ),
                                          Positioned(
                                            left: 30.h,
                                            child: Text(
                                              "Daily Check-in",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 30.h,
                                            child: Transform.scale(
                                              scale: 0.9,
                                              child: CupertinoSwitch(
                                                value: _dailyCheckInEnabled,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    _dailyCheckInEnabled = value;
                                                  });
                                                },
                                                activeColor: CupertinoColors.systemGreen,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (_dailyCheckInEnabled)
                                      Positioned(
                                        top: 12.h + 55.h + 7.h,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/times_daily_checkin.svg',
                                              width: 340.h,
                                              height: 200.h,
                                            ),
                                            Positioned(
                                              left: 20.h,
                                              top: 16.h,
                                              child: GestureDetector(
                                                onTap: () => _selectDailyTime(context, 0),
                                                child: Text(
                                                  provider.isAddingDailyReminders[0]
                                                    ? "Add a Gentle Reminder"
                                                    : "${provider.dailyCheckInTimes[0].hour.toString().padLeft(2, '0')}:${provider.dailyCheckInTimes[0].minute.toString().padLeft(2, '0')}",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white.withOpacity(0.96),
                                                    fontFamily: 'Roboto',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (provider.isAddingDailyReminders[0])
                                              Positioned(
                                                right: 20.h,
                                                top: 20.h,
                                                child: GestureDetector(
                                                  onTap: () => _selectDailyTime(context, 0),
                                                  child: SvgPicture.asset(
                                                    'assets/images/plus_gr.svg',
                                                  ),
                                                ),
                                              ),
                                            if (!provider.isAddingDailyReminders[0])
                                              Positioned(
                                                right: 20.h,
                                                top: 16.h,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        provider.toggleAddingReminder(0, true);
                                                      },
                                                      child: SvgPicture.asset(
                                                        'assets/images/trash.svg',
                                                      ),
                                                    ),
                                                    SizedBox(width: 7.h),
                                                    GestureDetector(
                                                      onTap: () => _selectDailyTime(context, 0),
                                                      child: SvgPicture.asset(
                                                        'assets/images/edit.svg',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            Positioned(
                                              left: 20.h,
                                              top: 65.h,
                                              child: GestureDetector(
                                                onTap: () => _selectDailyTime(context, 1),
                                                child: Text(
                                                  provider.isAddingDailyReminders[1]
                                                    ? "Add a Gentle Reminder"
                                                    : "${provider.dailyCheckInTimes[1].hour.toString().padLeft(2, '0')}:${provider.dailyCheckInTimes[1].minute.toString().padLeft(2, '0')}",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white.withOpacity(0.96),
                                                    fontFamily: 'Roboto',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (provider.isAddingDailyReminders[1])
                                              Positioned(
                                                right: 20.h,
                                                top: 68.h,
                                                child: GestureDetector(
                                                  onTap: () => _selectDailyTime(context, 1),
                                                  child: SvgPicture.asset(
                                                    'assets/images/plus_gr.svg',
                                                  ),
                                                ),
                                              ),
                                            if (!provider.isAddingDailyReminders[1])
                                              Positioned(
                                                right: 20.h,
                                                top: 62.h,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        provider.toggleAddingReminder(1, true);
                                                      },
                                                      child: SvgPicture.asset(
                                                        'assets/images/trash.svg',
                                                      ),
                                                    ),
                                                    SizedBox(width: 7.h),
                                                    GestureDetector(
                                                      onTap: () => _selectDailyTime(context, 1),
                                                      child: SvgPicture.asset(
                                                        'assets/images/edit.svg',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            Positioned(
                                              left: 20.h,
                                              top: 113.h,
                                              child: GestureDetector(
                                                onTap: () => _selectDailyTime(context, 2),
                                                child: Text(
                                                  provider.isAddingDailyReminders[2]
                                                    ? "Add a Gentle Reminder"
                                                    : "${provider.dailyCheckInTimes[2].hour.toString().padLeft(2, '0')}:${provider.dailyCheckInTimes[2].minute.toString().padLeft(2, '0')}",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white.withOpacity(0.96),
                                                    fontFamily: 'Roboto',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (provider.isAddingDailyReminders[2])
                                              Positioned(
                                                right: 20.h,
                                                top: 114.h,
                                                child: GestureDetector(
                                                  onTap: () => _selectDailyTime(context, 2),
                                                  child: SvgPicture.asset(
                                                    'assets/images/plus_gr.svg',
                                                  ),
                                                ),
                                              ),
                                            if (!provider.isAddingDailyReminders[2])
                                              Positioned(
                                                right: 20.h,
                                                top: 110.h,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        provider.toggleAddingReminder(2, true);
                                                      },
                                                      child: SvgPicture.asset(
                                                        'assets/images/trash.svg',
                                                      ),
                                                    ),
                                                    SizedBox(width: 7.h),
                                                    GestureDetector(
                                                      onTap: () => _selectDailyTime(context, 2),
                                                      child: SvgPicture.asset(
                                                        'assets/images/edit.svg',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            Positioned(
                                              left: 20.h,
                                              top: 160.h,
                                              child: GestureDetector(
                                                onTap: () => _selectDailyTime(context, 3),
                                                child: Text(
                                                  provider.isAddingDailyReminders[3]
                                                    ? "Add a Gentle Reminder"
                                                    : "${provider.dailyCheckInTimes[3].hour.toString().padLeft(2, '0')}:${provider.dailyCheckInTimes[3].minute.toString().padLeft(2, '0')}",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white.withOpacity(0.96),
                                                    fontFamily: 'Roboto',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (provider.isAddingDailyReminders[3])
                                              Positioned(
                                                right: 20.h,
                                                top: 161.h,
                                                child: GestureDetector(
                                                  onTap: () => _selectDailyTime(context, 3),
                                                  child: SvgPicture.asset(
                                                    'assets/images/plus_gr.svg',
                                                  ),
                                                ),
                                              ),
                                            if (!provider.isAddingDailyReminders[3])
                                              Positioned(
                                                right: 20.h,
                                                top: 157.h,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        provider.toggleAddingReminder(3, true);
                                                      },
                                                      child: SvgPicture.asset(
                                                        'assets/images/trash.svg',
                                                      ),
                                                    ),
                                                    SizedBox(width: 7.h),
                                                    GestureDetector(
                                                      onTap: () => _selectDailyTime(context, 3),
                                                      child: SvgPicture.asset(
                                                        'assets/images/edit.svg',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),                              
                              SizedBox(height: 7.h),
                              Container(
                                width: 340.h,
                                height: _quoteEnabled ? 155.h : 79.h,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      _quoteEnabled 
                                        ? 'assets/images/quote_daily.svg'
                                        : 'assets/images/daily_toggle_off.svg',
                                      width: 340.h,
                                      height: _quoteEnabled ? 155.h : 79.h,
                                    ),
                                    Positioned(
                                      top: 12.h,
                                      left: 0,
                                      right: 0,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/daily_toggle.svg',
                                          ),
                                          Positioned(
                                            left: 30.h,
                                            child: Text(
                                              "Quote of the Day",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 30.h,
                                            child: Transform.scale(
                                              scale: 0.9,
                                              child: CupertinoSwitch(
                                                value: _quoteEnabled,
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    _quoteEnabled = value;
                                                  });
                                                },
                                                activeColor: CupertinoColors.systemGreen,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (_quoteEnabled)
                                      Positioned(
                                        top: 12.h + 55.h + 7.h,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/daily_toggle.svg',
                                            ),
                                            Positioned(
                                              left: 20.h,
                                              top: 0,
                                              bottom: 0,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  _isAddingReminder 
                                                    ? "Add a Gentle Reminder"
                                                    : "${_quoteTime.hour.toString().padLeft(2, '0')}:${_quoteTime.minute.toString().padLeft(2, '0')}",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white.withOpacity(0.96),
                                                    fontFamily: 'Roboto',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: 18.h,
                                              top: 0,
                                              bottom: 0,
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: _isAddingReminder
                                                  ? GestureDetector(
                                                      onTap: () => _selectTime(context),
                                                      child: SvgPicture.asset(
                                                        'assets/images/plus_gr.svg',
                                                      ),
                                                    )
                                                  : Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              _isAddingReminder = true;
                                                            });
                                                          },
                                                          child: SvgPicture.asset(
                                                            'assets/images/trash.svg',
                                                          ),
                                                        ),
                                                        SizedBox(width: 7.h),
                                                        GestureDetector(
                                                          onTap: () => _selectTime(context),
                                                          child: SvgPicture.asset(
                                                            'assets/images/edit.svg',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 17.h),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    final signUpProvider = context.read<SignUpProvider>();
                                    signUpProvider.updateStepTwoData(
                                      context.read<SignUpStepTwoProvider>().dailyCheckInTimes,
                                       context.read<SignUpStepTwoProvider>().enabledReminders,
                                      _quoteTime, _quoteEnabled
                                      );
                                      Navigator.pushNamed(context, AppRoutes.signUpStepThreeScreen);
                                  },
                                  child: Container(
                                    width: 130.h,
                                    height: 60.h,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/next.svg',
                                          width: 109.h,
                                          height: 48.h,
                                        ),
                                        Text(
                                          "Next",
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
                                ),
                              ),
                              SizedBox(height: 24.h),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
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
      ),
    );
  }


}
