import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/inhale_model.dart';
import 'provider/inhale_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';
import 'dart:math' as math;
import '../breathingdone_screen/breathingdone_screen.dart';

class InhaleScreen extends StatefulWidget {
  final int duration;
  
  const InhaleScreen({Key? key, required this.duration})
      : super(key: key);

  @override
  InhaleScreenState createState() => InhaleScreenState();

  static Widget builder(BuildContext context) {
    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final int duration = args?['duration'] ?? 1;
    
    return ChangeNotifierProvider(
      create: (context) => InhaleProvider(),
      child: InhaleScreen(duration: duration),
    );
  }
}

class InhaleScreenState extends State<InhaleScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _rotationAnimation;
  String _breathingText = "Inhale";
  Timer? _breathingTimer;
  int _remainingTime = 0;
  bool _isBreathing = true;

  // Apple Watch Breathe app colors
  final Color _primaryColor = const Color(0xFF4A90E2); // Blue
  final Color _secondaryColor = const Color(0xFF50E3C2); // Teal
  final Color _backgroundColor = const Color(0xFF1E1E1E); // Lighter black

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration;
    
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.4, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.1, end: 0.6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _breathingText = "Exhale";
        });
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _breathingText = "Inhale";
        });
        _controller.forward();
      }
    });

    _controller.forward();
    _startBreathingTimer();
  }

  void _startBreathingTimer() {
    _breathingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _isBreathing = false;
          _breathingTimer?.cancel();
          _controller.stop();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BreathingdoneScreen.builder(context),
            ),
            (route) => false,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _breathingTimer?.cancel();
    super.dispose();
  }

  Widget _buildPetal(double size, double angle, double opacity) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: size,
        height: size * 2.0, // More elongated petals
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size * 0.8),
            topRight: Radius.circular(size * 0.8),
            bottomLeft: Radius.circular(size * 0.2),
            bottomRight: Radius.circular(size * 0.2),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _primaryColor.withOpacity(opacity),
              _secondaryColor.withOpacity(opacity),
            ],
          ),
        ),
      ),
    );
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
          color: _backgroundColor,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Petals
                      ...List.generate(8, (index) {
                        final angle = (index * 45) * (math.pi / 180);
                        final petalSize = 100.0 * _scaleAnimation.value;
                        final opacity = _opacityAnimation.value * 0.3;
                        
                        return Transform.rotate(
                          angle: _rotationAnimation.value,
                          child: _buildPetal(petalSize, angle, opacity),
                        );
                      }),
                      // Center circle
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              _primaryColor.withOpacity(_opacityAnimation.value * 0.4),
                              _secondaryColor.withOpacity(_opacityAnimation.value * 0.4),
                            ],
                          ),
                        ),
                      ),
                      // Breathing text with background
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          _breathingText,
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 40),
              Text(
                "${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}",
                style: GoogleFonts.roboto(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 0,
    );
  }
}
