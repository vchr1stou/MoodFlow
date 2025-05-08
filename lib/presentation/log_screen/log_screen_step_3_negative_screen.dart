import 'package:flutter/material.dart';
import '../../core/services/storage_service.dart';

class LogScreenStep3NegativeScreen extends StatefulWidget {
  const LogScreenStep3NegativeScreen({Key? key}) : super(key: key);

  @override
  State<LogScreenStep3NegativeScreen> createState() => _LogScreenStep3NegativeScreenState();
}

class _LogScreenStep3NegativeScreenState extends State<LogScreenStep3NegativeScreen> {
  List<String> selectedFeelings = [];
  Map<String, double> intensities = {};

  @override
  void initState() {
    super.initState();
    _loadSavedFeelings();
  }

  Future<void> _loadSavedFeelings() async {
    final savedFeelings = StorageService.getNegativeFeelings();
    final savedIntensities = StorageService.getNegativeIntensities();
    
    setState(() {
      selectedFeelings = savedFeelings;
      intensities = savedIntensities;
    });
  }

  void _onIntensityChanged(String feeling, double value) {
    setState(() {
      intensities[feeling] = value;
    });
    StorageService.saveNegativeIntensities(intensities);
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Replace with your existing build implementation
  }
} 