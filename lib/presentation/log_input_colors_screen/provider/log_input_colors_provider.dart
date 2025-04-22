import 'package:flutter/material.dart';
import '../models/log_input_colors_model.dart';

class LogInputColorsProvider extends ChangeNotifier {
  LogInputColorsModel _model = LogInputColorsModel();

  LogInputColorsModel get model => _model;

  void initState(BuildContext context) {}

  void dispose() {}
}
