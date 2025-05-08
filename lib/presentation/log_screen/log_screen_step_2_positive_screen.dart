import 'package:flutter/material.dart';
import '../../core/services/storage_service.dart';

class LogScreenStep2PositiveScreen extends StatefulWidget {
  const LogScreenStep2PositiveScreen({Key? key}) : super(key: key);

  @override
  State<LogScreenStep2PositiveScreen> createState() => _LogScreenStep2PositiveScreenState();
}

class _LogScreenStep2PositiveScreenState extends State<LogScreenStep2PositiveScreen> {
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

  void _onFeelingSelected(String feeling) {
    setState(() {
      if (selectedFeelings.contains(feeling)) {
        selectedFeelings.remove(feeling);
        intensities.remove(feeling);
      } else {
        selectedFeelings.add(feeling);
        intensities[feeling] = 0.5; // Default intensity
      }
    });
    StorageService.savePositiveFeelings(selectedFeelings);
    StorageService.savePositiveIntensities(intensities);
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
} 