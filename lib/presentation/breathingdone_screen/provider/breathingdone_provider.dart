import 'package:flutter/material.dart';
import '../models/breathingdone_model.dart';

class BreathingdoneProvider extends ChangeNotifier {
  BreathingdoneModel _model = BreathingdoneModel();

  BreathingdoneModel get model => _model;

  void initState(BuildContext context) {}

  void dispose() {}
}
