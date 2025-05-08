import 'package:flutter/material.dart';
import '../../core/services/storage_service.dart';

class LogScreenStep2NegativeScreen extends StatefulWidget {
  const LogScreenStep2NegativeScreen({Key? key}) : super(key: key);

  @override
  State<LogScreenStep2NegativeScreen> createState() => _LogScreenStep2NegativeScreenState();
}

class _LogScreenStep2NegativeScreenState extends State<LogScreenStep2NegativeScreen> {
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
    StorageService.saveNegativeFeelings(selectedFeelings);
    StorageService.saveNegativeIntensities(intensities);
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